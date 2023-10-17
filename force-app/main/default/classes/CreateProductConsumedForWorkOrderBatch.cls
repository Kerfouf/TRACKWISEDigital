/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : CreateProductConsumedForWorkOrderBatch
* @Why   : Batch class to create Product Consumed custom records from Product Consumed external records and linking them to 
*          their respective custom Work order parent records
* @When  : 14-DEC-2018
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        14-DEC-2018        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/



global class CreateProductConsumedForWorkOrderBatch implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts{
    private final String VALID_CASE_TYPE = 'TechnicalComplaint';
    
    //Intializing external Product Consumed Ids in the constructor
    global CreateProductConsumedForWorkOrderBatch(){}
    Boolean chained;
    DateTime lastExecuted;

    global CreateProductConsumedForWorkOrderBatch(Boolean chain, DateTime lastExecuted){
        this.chained = chain;
        this.lastExecuted = lastExecuted;
    }
    
    // querying the external Product Consumed recordss
    global Database.QueryLocator start(Database.BatchableContext bc) {
        if(!Test.isRunningTest()){
          /** We are pulling in Products Consumed associated with recently modified Cases because there is a scenario where a previously
            created Case gets reclassified as a Technical Complaint so we will need to grab the previously created Products Consumed. */
           String formattedTime = lastExecuted.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');
            return Database.getQueryLocator('SELECT Id,LastModifiedDate__c, WorkOrderId__r.CaseId__r.Type__c, WorkOrderId__r.CaseId__r.TWComplaintNumber_c__c, '+ 
                        ' WorkOrderId__r.ExternalId,ExternalId,WorkOrderId__r.WorkOrderNumber__c,QuantityConsumed__c, WorkOrderId__r.CaseId__r.CaseNumber_c__c, WorkOrderId__r.CaseId__r.CaseNumber__c, ' +
                        ' PricebookEntryId__r.LocalProductName_c__c FROM ProductConsumed__x WHERE WorkOrderId__r.CaseId__r.LastModifiedDate__c >=' + formattedTime +
                                            ' or LastModifiedDate__c >=' + formattedTime);
        }else{
            return Database.getQueryLocator('SELECT Id,WorkOrderId__r.CaseId__r.Type__c, WorkOrderId__r.CaseId__r.TWComplaintNumber_c__c, WorkOrderId__r.ExternalId,ExternalId,WorkOrderId__r.WorkOrderNumber__c,QuantityConsumed__c,' +
                       'PricebookEntryId__r.LocalProductName_c__c FROM ProductConsumed__x LIMIT 1');
        }
    }
    
    global void execute(Database.BatchableContext bc, List<sObject> prodConsumedList){
        
        List<ProductConsumed__x> records = new List<ProductConsumed__x>();
        if(!Test.isRunningTest()){
            for(Sobject sObj: prodConsumedList){
                ProductConsumed__x extProdConsumedObj = (ProductConsumed__x) sObj;
                if (extProdConsumedObj.WorkOrderId__r.CaseId__r.CaseNumber_c__c == extProdConsumedObj.WorkOrderId__r.CaseId__r.CaseNumber__c &&
                   extProdConsumedObj.WorkOrderId__r.CaseId__r.Type__c == 'TechnicalComplaint') {
                    records.add(extProdConsumedObj);
                }
            }
        }
        
        if(Test.isRunningTest()){
            records.add(BMX_TestDataFactory.getProdConsumedExRecord());
        }
        
        List<Product_Consumed__c> productConsumedList = new List<Product_Consumed__c>();
        List<Database.upsertResult> upsertResultList = new List<Database.upsertResult>();

        for(ProductConsumed__x  productconsumX: records){
            
            //mapping external Product Consumed fields to the Product Consumed custom object fields to create Product Consumed records
            if(Test.isRunningTest() || 
            (productconsumX.WorkOrderId__r.ExternalId != null && 
             productconsumX.WorkOrderId__r.CaseId__r.Type__c != null && 
             productconsumX.WorkOrderId__r.CaseId__r.Type__c == VALID_CASE_TYPE &&
             ( productconsumX.WorkOrderId__r.CaseId__r.TWComplaintNumber_c__c == null ||
            productconsumX.WorkOrderId__r.CaseId__r.TWComplaintNumber_c__c.contains('CN')))){
                Product_Consumed__c productConsumed = new Product_Consumed__c();
                productConsumed.workOrderId__r = new Work_Order__c(ExternalId__c = productconsumX.WorkOrderId__r.ExternalId);
                productConsumed.ExternalId__c = productconsumX.ExternalId;
                productConsumed.Product_Consumed_WO__c = productconsumX.WorkOrderId__r.WorkOrderNumber__c;
                productConsumed.Product_Consumed_Price_Book_Entry__c = productconsumX.PricebookEntryId__r.LocalProductName_c__c;
                productConsumed.Product_Quantity_Consumed__c = productconsumX.QuantityConsumed__c;
                productConsumedList.add(productConsumed);
            }
        }
        
        
        System.debug('-------productConsumedList------'+productConsumedList);
        
        if(!productConsumedList.isEmpty()) {
        
            // Upserting the external Product Consumed list of records 
            upsertResultList = Database.Upsert(productConsumedList,Product_Consumed__c.ExternalId__c, false);
        }
        
        // creating error log records if any record gets failed during the execution of the batch
        if(!upsertResultList.isEmpty()) {
            List<Error_Log__c> errLogList = new List<Error_Log__c>();
            for(Integer i=0; i <upsertResultList.size(); i++) {
                if(!upsertResultList[i].isSuccess() ) {
                    Error_Log__c el = Utils_CreateComplaintForCaseBatch.returnErrorLog(upsertResultList[i].getErrors(), 
                                                                                       'CreateProductConsumedForWorkOrderBatch', 'Product_Consumed__c');
                    el.Record_ID__c = productConsumedList[i].Id;
                    el.External_Case_Id__c = productConsumedList[i].ExternalId__c;
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
        system.debug('Product Conmsumed inserted/updated');
        if(!Test.isRunningTest()){
            // executing the CreateServiceAppointmentForWorkOrdrBatch batch class
            CreateServiceAppointmentForWorkOrdrBatch createServiceAppointment = new CreateServiceAppointmentForWorkOrdrBatch(true, lastExecuted);
            Database.executebatch(createServiceAppointment, 50);
        }
    }  
}