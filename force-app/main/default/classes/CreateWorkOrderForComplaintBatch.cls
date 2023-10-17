/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : CreateWorkOrderForComplaintBatch
* @Why   : Batch class to create Work Order custom records from Work Order External records and linking them to their respective complaints
* @When  : 14-DEC-2018
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        14-DEC-2018        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/


global class CreateWorkOrderForComplaintBatch implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    private final String VALID_CASE_TYPE = 'TechnicalComplaint';
    
    global CreateWorkOrderForComplaintBatch(){} 
    global Boolean chained;
    DateTime lastExecuted;

    global CreateWorkOrderForComplaintBatch(Boolean chain, DateTime lastExecuted) {
        this.chained = chain;
        this.lastExecuted = lastExecuted;
    }
    
    // querying the external Work Order records
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(!Test.isRunningTest()){
          /** We are pulling in Work Orders associated with recently modified Cases because there is a scenario where a previously
            created Case gets reclassified as a Technical Complaint so we will need to grab the previously created Work Orders. */
            String formattedTime = lastExecuted.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            return Database.getQueryLocator('SELECT Id,LastModifiedDate__c,CaseId__r.Type__c,CaseId__r.TWComplaintNumber_c__c,  ' +
                                            ' CaseId__r.ExternalId,StartDate__c,ClosedDate_c__c,ExternalId,Status__c,Categories_c__c,SAP_ServiceOrderType_c__c,' +
                                            ' CaseId__r.CaseNumber_c__c,CaseId__r.CaseNumber__c, ' +
                                            ' SubCategory_c__c,Subject__c  FROM WorkOrder__x WHERE CaseId__r.LastModifiedDate__c >=' + formattedTime + 
                                            ' or LastModifiedDate__c >=' + formattedTime);
        }else{
            return Database.getQueryLocator('SELECT Id,CaseId__r.Type__c,CaseId__r.TWComplaintNumber_c__c, CaseId__r.ExternalId,StartDate__c,ClosedDate_c__c,ExternalId,Status__c,Categories_c__c,SAP_ServiceOrderType_c__c,' +
                                            'SubCategory_c__c,Subject__c  FROM WorkOrder__x LIMIT 1');
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> workOrdrList){
        
        List<WorkOrder__x> records = new List<WorkOrder__x>();
        if(!Test.isRunningTest()){
            for(Sobject sObj: workOrdrList){
                WorkOrder__x extWorkOrdrObj = (WorkOrder__x) sObj;
                if (extWorkOrdrObj.CaseId__r.CaseNumber_c__c == extWorkOrdrObj.CaseId__r.CaseNumber__c &&
                    extWorkOrdrObj.CaseId__r.Type__c == 'TechnicalComplaint') {
                    records.add(extWorkOrdrObj);
                }
            }
        }
        
        if(Test.isRunningTest()){
            records.add(BMX_TestDataFactory.getWorkOrdrExRecord());
        }
        
        List<Work_Order__c> workOrderList = new List<Work_Order__c>();
        List<Database.upsertResult> upsertResultList = new List<Database.upsertResult>();
        
        for(WorkOrder__x  workOrdX: records){
            //mapping external Work Order fields to the Work Order custom object fields to create Work Order records
            if(Test.isRunningTest() || 
            (workOrdX.CaseId__r.ExternalId != null && 
            workOrdX.CaseId__r.Type__c != null && 
            workOrdX.CaseId__r.Type__c == VALID_CASE_TYPE &&
            (  workOrdX.CaseId__r.TWComplaintNumber_c__c == null ||
             workOrdX.CaseId__r.TWComplaintNumber_c__c.contains('CN')
             ))){
                //Integer cmplntCount = (!Test.isRunningTest()) ? [SELECT Count() FROM CMPL123CME__Complaint__c WHERE BMX_Case_External_Id__c =: workOrdX.CaseId__r.ExternalId LIMIT 1] : 1;
                //If( cmplntCount > 0){
                    Work_Order__c workOrdr = new Work_Order__c();
                    workOrdr.ComplaintId__r = new CMPL123CME__Complaint__c(BMX_Case_External_Id__c = workOrdX.CaseId__r.ExternalId);
                    workOrdr.ExternalId__c = workOrdX.ExternalId;
                    workOrdr.WO_Category__c = workOrdX.Categories_c__c;
                    workOrdr.WO_Status__c = workOrdX.Status__c;
                    workOrdr.WO_Sub_Category__c = workOrdX.SubCategory_c__c;
                    workOrdr.WO_Subject__c = workOrdX.Subject__c;
                    workOrdr.WO_Type__c = workOrdX.SAP_ServiceOrderType_c__c;
                    workOrdr.StartDate__c = workOrdX.StartDate__c;
                    workOrdr.ClosedDate_c__c = workOrdX.ClosedDate_c__c;
                    workOrderList.add(workOrdr);
                //}
            }
        }
        
        System.debug('-------workOrderList------'+workOrderList);
        
        if(!workOrderList.isEmpty()) {
        
            // Upserting the external Work Order list of records
            upsertResultList = Database.Upsert(workOrderList,Work_Order__c.ExternalId__c, false);
        }
        
        // creating error log records if any record gets failed during the execution of the batch
        if(!upsertResultList.isEmpty()) {
            List<Error_Log__c> errLogList = new List<Error_Log__c>();
            for(Integer i=0; i <upsertResultList.size(); i++) {
                if(!upsertResultList[i].isSuccess() ) {
                    Error_Log__c el = Utils_CreateComplaintForCaseBatch.returnErrorLog(upsertResultList[i].getErrors(), 
                                                                                       'CreateWorkOrderForComplaintBatch', 'Work_Order__c');
                    el.Record_ID__c = workOrderList[i].Id;
                    el.External_Case_Id__c = workOrderList[i].ExternalId__c;
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
        system.debug('Work Orders inserted/updated');  
        
        // querying the external Product Consumed records which are created/updated in last 24 hours
        Boolean chainedAlready = !chained;
        if(!Test.isRunningTest()){
            CreateProductConsumedForWorkOrderBatch createProductConsumed = new CreateProductConsumedForWorkOrderBatch(chained && !chainedAlready, lastExecuted);
            chainedAlready = true;
            database.executebatch(createProductConsumed, 50);
        }
    } 
}