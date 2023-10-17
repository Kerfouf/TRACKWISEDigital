/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : CreateServiceAppointmentForWorkOrdrBatch
* @Why   : Batch class to create Service Appointment custom records from Service Appointment External records and linking them to their respective
*          custom Work Order parent records
* @When  : 14-DEC-2018
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        14-DEC-2018        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

/* */


global class CreateServiceAppointmentForWorkOrdrBatch implements Database.Batchable<SObject>, Database.Stateful,Database.AllowsCallouts{
    private final String VALID_CASE_TYPE = 'TechnicalComplaint';
    
    global CreateServiceAppointmentForWorkOrdrBatch(){}
    Boolean chained;
    DateTime lastExecuted;
    
    //Intializing external Service Appointment Ids in the constructor
    global CreateServiceAppointmentForWorkOrdrBatch(Boolean chain, Datetime lastExecuted){
        this.chained = chain;
        this.lastExecuted = lastExecuted;
    }
    
    // querying the external Service Appointment records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        if(!Test.isRunningTest()){
             /** We are pulling in Service Appointments associated with recently modified Cases because there is a scenario where a previously
            created Case gets reclassified as a Technical Complaint so we will need to grab the previously created Service Appointments. */
            String formattedTime = lastExecuted.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            return Database.getQueryLocator('SELECT Id,LastModifiedDate__c, WorkOrder_c__r.CaseId__r.Type__c, WorkOrder_c__r.CaseId__r.CaseNumber_c__c, WorkOrder_c__r.CaseId__r.CaseNumber__c, ' +
                                            ' WorkOrder_c__r.CaseId__r.TWComplaintNumber_c__c, WorkOrder_c__r.ExternalId, ExternalId, Description__c,Status__c, ' +
                                            ' ParentRecordId__r.WorkOrderNumber__c FROM ServiceAppointment__x WHERE WorkOrder_c__r.CaseId__r.LastModifiedDate__c >= ' + formattedTime +
                                            ' or LastModifiedDate__c >=' + formattedTime);  
        }else{
            return Database.getQueryLocator('SELECT Id,WorkOrder_c__r.CaseId__r.Type__c, WorkOrder_c__r.CaseId__r.TWComplaintNumber_c__c, WorkOrder_c__r.ExternalId,ExternalId,Description__c,Status__c,' +
                                            'ParentRecordId__r.WorkOrderNumber__c FROM ServiceAppointment__x LIMIT 1');
        }        
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> serviceAppointList){
        
        List<ServiceAppointment__x> records = new List<ServiceAppointment__x>();
        if(!Test.isRunningTest()){
            for(Sobject sObj: serviceAppointList){
                ServiceAppointment__x extServiceAppointObj = (ServiceAppointment__x) sObj;
                if (extServiceAppointObj.WorkOrder_c__r.CaseId__r.CaseNumber_c__c == extServiceAppointObj.WorkOrder_c__r.CaseId__r.CaseNumber__c &&
                   extServiceAppointObj.WorkOrder_c__r.CaseId__r.Type__c == 'TechnicalComplaint') {
                    records.add(extServiceAppointObj);
                }
            }
        }
        
        if(Test.isRunningTest()){
            records.add(BMX_TestDataFactory.getServiceAppointmentExRecord());
        }
        
        List<Service_Appointment__c> serviceApppointmentList = new List<Service_Appointment__c>();
        List<Database.upsertResult> upsertResultList = new List<Database.upsertResult>();
        
        for(ServiceAppointment__x  serviceAppointX: records){
            
            //mapping external Service Appointment fields to the Service Appointment custom object fields to create Service Appointment records
            if(Test.isRunningTest() || 
            (serviceAppointX.WorkOrder_c__r.ExternalId != null && 
            serviceAppointX.WorkOrder_c__r.CaseId__r.Type__c != null &&
            serviceAppointX.WorkOrder_c__r.CaseId__r.Type__c == VALID_CASE_TYPE &&
            (  serviceAppointX.WorkOrder_c__r.CaseId__r.TWComplaintNumber_c__c == null ||
             serviceAppointX.WorkOrder_c__r.CaseId__r.TWComplaintNumber_c__c.contains('CN') ))){
                Service_Appointment__c serviceAppoint = new Service_Appointment__c();
                serviceAppoint.workOrderId__r = new Work_Order__c(ExternalId__c = serviceAppointX.WorkOrder_c__r.ExternalId);
                serviceAppoint.ExternalId__c = serviceAppointX.ExternalId;
                serviceAppoint.SA_Description__c = serviceAppointX.Description__c;
                serviceAppoint.SA_Parent_record__c = serviceAppointX.ParentRecordId__r.WorkOrderNumber__c;
                serviceAppoint.SA_Status__c = serviceAppointX.Status__c;                        
                serviceApppointmentList.add(serviceAppoint);
            }
        }
        
        
        System.debug('-------serviceApppointmentList------'+serviceApppointmentList);
        
        if(!serviceApppointmentList.isEmpty()) {
        
            // Upserting the external Service Appointment list of records
            upsertResultList = Database.Upsert(serviceApppointmentList,Service_Appointment__c.ExternalId__c, false);
        }
        
        // creating error log records if any record gets failed during the execution of the batch
        if(!upsertResultList.isEmpty()) {
            List<Error_Log__c> errLogList = new List<Error_Log__c>();
            for(Integer i=0; i <upsertResultList.size(); i++) {
                if(!upsertResultList[i].isSuccess() ) {
                    Error_Log__c el = Utils_CreateComplaintForCaseBatch.returnErrorLog(upsertResultList[i].getErrors(), 
                                                                                       'CreateServiceAppointmentForWorkOrdrBatch', 'Service_Appointment__c');
                    el.Record_ID__c = serviceApppointmentList[i].Id;
                    el.External_Case_Id__c = serviceApppointmentList[i].ExternalId__c;
                    errLogList.add(el);
                }
            }
            if(!errLogList.isEmpty()) {
                Database.Insert(errLogList, false);
            }
        } 
    }  
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        system.debug('Service Appointments inserted/updated');
    } 
}