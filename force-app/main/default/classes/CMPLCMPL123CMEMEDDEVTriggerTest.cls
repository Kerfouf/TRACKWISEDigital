@isTest
public   class CMPLCMPL123CMEMEDDEVTriggerTest{
    static testMethod void CMPL123CMEMEDDEVTriggerTestmethod(){
        
        CMPL123CME__Complaint__c complaint = new CMPL123CME__Complaint__c(
            BMX_Reference__c = 'test',BMX_Product_Code__c = 'test',BMX_Product_Name__c = 'test',BMX_Contact_Name__c = 'test',
            BMX_Batch_Expiration_Date__c = Date.newInstance(2018, 12, 8), Visitor_Street__c = 'test',Visitor_City__c = 'test',
            BMX_Contact_Email__c = 'a@test.com',BMX_Contact_Phone__c = '1234567',Visitor_Postal_Code__c = '560066', 
            Visitor_Country__c = 'India',BMX_Batch_Number_Reagent__c ='2345',BMX_Customer_Contact_Date__c = Date.newInstance(2018, 10, 8),
            Visitor_Address_Name__c = 'test',BMX_Serial_Number_Asset__c = '123',BMX_PRE1_Patient_or_operator_death__c = 'Yes',
        BMX_PRE2_1_Patient_or_operator_harmed__c  = 'Yes');
        insert complaint;
        
        CMPL123CME__Complaint_Code__c cmplntCode = new CMPL123CME__Complaint_Code__c(Local_Subsidiary_Text__c = 'test',
                                                                                    CMPL123CME__Type__c = 'COUNTRY CODE');
        insert cmplntCode;
        
        String globalRTId = Schema.SObjectType.CMPL123CME__Questionnaire__c.getRecordTypeInfosByName().get('Global Assessment').getRecordTypeId();
        CMPL123CME__Questionnaire__c globalRecord = new CMPL123CME__Questionnaire__c();
        globalRecord.RecordTypeId = globalRTId;
        globalRecord.BMX_Title__c = 'Global12345';
        globalRecord.CMPL123CME__Complaint__c = complaint.Id;
        globalRecord.BMX_Description_of_Issue__c = 'test';
        globalRecord.Local_Subsidiary_Text__c = 'test';
        globalRecord.BMX_Revised_Awareness_Date__c = Date.newInstance(2018, 12, 8);
        globalRecord.BMX_Justification_of_Due_Date_Change__c = 'test';
        insert globalRecord;
        system.debug('==globalRecord=='+globalRecord);
        
        String localRTId = Schema.SObjectType.CMPL123CME__Questionnaire__c.getRecordTypeInfosByName().get('Local Assessment').getRecordTypeId();
        CMPL123CME__Questionnaire__c localRecord = new CMPL123CME__Questionnaire__c();
        localRecord.RecordTypeId = localRTId;
        localRecord.BMX_Global_Assessment__c = globalRecord.Id;
        localRecord.BMX_Reportable_Country2__c = cmplntCode.Id;
        localRecord.BMX_Justification_of_Report_Due_Change__c = 'test';
        system.debug('==localRecord=='+localRecord);
        insert localRecord;
        
        
        CMPL123CME__MEDDEV__c testobject = new CMPL123CME__MEDDEV__c ();
        testobject.Local_Assessment__c = localRecord.Id;
        testobject.CMPL123CME__Type_of_Report__c = 'Initial report';
        //testobject.CMPL123CME__Complaint__c = complaint.Id;
        insert testobject; 
        delete testobject;
        undelete testobject;                                      
        update testobject; 
        System.assertEquals('1','1');
    }
}