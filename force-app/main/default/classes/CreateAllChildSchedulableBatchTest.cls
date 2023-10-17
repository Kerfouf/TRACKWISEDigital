/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : CreateAllChildSchedulableBatchTest
* @Why   : 
* @When  : 24-JAN-2019
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        24-JAN-2019         Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/


@isTest
public class CreateAllChildSchedulableBatchTest{

/**
* @Method       : createComplaintForCaseBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of CreateComplaintForCaseBatch batch class
* @Return       : N/A
* @Params       : 
**/ 
    
    public static testMethod void createComplaintForCaseBatchTestMethod(){
        
        Case cs = BMX_TestDataFactory.getCaseRecord();
        insert cs;
        Integer count = 1;
        Complaint_Creation_Batch_Time__c setting = new Complaint_Creation_Batch_Time__c();
        DateTime now = System.now();
        setting.Batch_Completion_Time__c = now;
        insert setting;
        String caseQuery = 'SELECT Id FROM Case LIMIT 1';
        
        //CreateComplaintForCaseBatch bc = new CreateComplaintForCaseBatch(caseQuery,count);
        //Database.executeBatch(bc, count); 
        
        CreateAllChildSchedulableBatch ch = new CreateAllChildSchedulableBatch();
        ch.execute(null);
    }
    
/**
* @Method       : createCaseCommentForComplaintBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of CreateCaseCommentForComplaintBatch batch class
* @Return       : N/A
* @Params       : 
**/ 
    
    public static testMethod void createCaseCommentForComplaintBatchTestMethod(){
        
        Case cs = BMX_TestDataFactory.getCaseRecord();
        insert cs;
        DateTime now = System.now();
        CreateCaseCommentForComplaintBatch createCaseComment = new CreateCaseCommentForComplaintBatch(true, now);
        database.executebatch(createCaseComment); 
    }
    
/**
* @Method       : createWorkOrdrForComplaintBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of CreateWorkOrderForComplaintBatch batch class
* @Return       : N/A
* @Params       : 
**/ 
    
    public static testMethod void createWorkOrdrForComplaintBatchTestMethod(){
        
        Case cs = BMX_TestDataFactory.getCaseRecord();
        insert cs;
        DateTime now = System.now();
        CreateWorkOrderForComplaintBatch createWorkOrdr = new CreateWorkOrderForComplaintBatch(true, now);
        database.executebatch(createWorkOrdr); 
    }
    
/**
* @Method       : createProdConsumedForWorkOrdrBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of CreateProductConsumedForWorkOrderBatch batch class
* @Return       : N/A
* @Params       : 
**/
    
    public static testMethod void createProdConsumedForWorkOrdrBatchTestMethod(){
        
        Case cs = BMX_TestDataFactory.getCaseRecord();
        insert cs;
        DateTime now = System.now();
        CreateProductConsumedForWorkOrderBatch createProdConsumed = new CreateProductConsumedForWorkOrderBatch(true, now);
        database.executebatch(createProdConsumed); 
    }
    
/**
* @Method       : createServiceAppointForWorkOrdrBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of CreateServiceAppointmentForWorkOrdrBatch batch class
* @Return       : N/A
* @Params       : 
**/
    
    public static testMethod void createServiceAppointForWorkOrdrBatchTestMethod(){
        
        Case cs = BMX_TestDataFactory.getCaseRecord();
        insert cs;
        
        Complaint_Creation_Batch_Time__c cst = new Complaint_Creation_Batch_Time__c();
        cst.Time_Interval__c = 30;
        insert cst;
        DateTime now = System.now();
        CreateServiceAppointmentForWorkOrdrBatch createServiceAppoint = new CreateServiceAppointmentForWorkOrdrBatch(true, now);
        database.executebatch(createServiceAppoint); 
    }
    
/**
* @Method       : reprocessErrorLogsBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of ReprocessErrorLogsBatch batch class
* @Return       : N/A
* @Params       : 
**/
    
    public static testMethod void reprocessErrorLogsBatchTestMethod(){

        Error_Log__c errlog = new Error_Log__c(External_Case_Id__c = '5007E000006OyrBQAS', Class_Name__c = 'TestABCClass',
                                              Error_Message__c = 'Foreign key external ID: 0wo6e000000k9hfwac not found for field ExternalId__c in entity Work_Order__c',
                                              Error_Type__c = 'INVALID_FIELDBatch DML Exception', Object_Name__c = 'Service_Appointment__c', Record_ID__c = 'a0P2q000000GjVn');
        insert errlog;
        
        Complaint_Creation_Batch_Time__c cst = new Complaint_Creation_Batch_Time__c();
        cst.Email_Recipient__c = 'abc@gmail.com,pqr@gmail.com';
        insert cst;
        ReprocessErrorLogsBatch_Schedule ch = new ReprocessErrorLogsBatch_Schedule();
        ch.execute(null); 
    }
    
/**
* @Method       : processReopenCloseCmplntFrCaseBatchTestMethod 
* @Invoke       : 
* @Description  : Method to test the fucntionality of ProcessReopenCloseComplaintForCaseBatch batch class
* @Return       : N/A
* @Params       : 
**/
    
    public static testMethod void processReopenCloseCmplntFrCaseBatchTestMethod(){
        
        CMPL123CME__Complaint__c cmplnt = new CMPL123CME__Complaint__c();
        insert cmplnt;
        
        List<CMPL123CME__Complaint__c> cmplntList = new List<CMPL123CME__Complaint__c>();
        cmplntList.add(cmplnt);
        DateTime now = System.now();
        ProcessReopenCloseComplaintForCaseBatch bc = new ProcessReopenCloseComplaintForCaseBatch(cmplntList,cmplntList,cmplntList, now);
        database.executebatch(bc);  
    } 
}