/* 
* @why  : BMX_CreateGlobalAssessmentBatchTest test class for the BMX_CreateGlobalAssessmentFrCMPLBatch class
* @when : CreatedDate :  may-28-2019        ModifiedDate : 
* @what : Class to Handle Different scenarios for BMX_CreateGlobalAssessmentFrCMPLBatch.
*/

@isTest
public class BMX_CreateGlobalAsmntFrCMPBatchTest {
    
/**    
* @description:   creating the required test data.
* @param:         void
* @return:        void
**/ 
    
    @testSetup static void setup(){
        
        // Create the Complaint Record
        CMPL123CME__Complaint__c complaint = (CMPL123CME__Complaint__c)BMX_TestDataFactory.createSObject(new CMPL123CME__Complaint__c(
         BMX_Reference__c = 'test',BMX_Product_Code__c = 'test',BMX_Product_Name__c = 'test',BMX_Contact_Name__c = 'test',
         BMX_Batch_Expiration_Date__c = Date.newInstance(2018, 12, 8), Visitor_Street__c = 'test',Visitor_City__c = 'test',
         BMX_Contact_Email__c = 'a@test.com',BMX_Contact_Phone__c = '1234567',Visitor_Postal_Code__c = '560066', 
         Visitor_Country__c = 'India',BMX_Batch_Number_Reagent__c ='2345',BMX_Customer_Contact_Date__c = Date.newInstance(2018, 10, 8),
         Visitor_Address_Name__c = 'test',BMX_Serial_Number_Asset__c = '123', BMX_PRE__c = 'Yes', BMX_Assessment_Created__c = False
        ),true);
        
        // Create the Complaint Record
        CMPL123CME__Complaint__c complaint1 = (CMPL123CME__Complaint__c)BMX_TestDataFactory.createSObject(new CMPL123CME__Complaint__c(
         BMX_Reference__c = 'test1',BMX_Product_Code__c = 'test11',BMX_Product_Name__c = 'test1',BMX_Contact_Name__c = 'test1',
         BMX_Batch_Expiration_Date__c = Date.newInstance(2018, 12, 8), Visitor_Street__c = 'test',Visitor_City__c = 'test',
         BMX_Contact_Email__c = 'ab@test.com',BMX_Contact_Phone__c = '1234567',Visitor_Postal_Code__c = '560066', 
         Visitor_Country__c = 'India',BMX_Batch_Number_Reagent__c ='2345',BMX_Customer_Contact_Date__c = Date.newInstance(2018, 10, 8),
         Visitor_Address_Name__c = 'test',BMX_Serial_Number_Asset__c = '123', BMX_PRE__c = 'Yes', BMX_Assessment_Created__c = False
        ),true);
    
     }
     
 /**    
* @description:   Test method for Auto creation of Global Assessment for Complaint.
* @param:         void
* @return:        void
**/ 
    
     public static testMethod void autoCreateGATestMethod(){
     
         List<CMPL123CME__Complaint__c> cmplList = [Select Id,BMX_PRE__c, Visitor_Country__c,BMX_Assessment_Created__c  FROM CMPL123CME__Complaint__c Where Visitor_Country__c = 'India' Limit 2];
         Test.startTest();
         BMX_CreateGlobalAssessmentFrCMPLBatch crGA = new BMX_CreateGlobalAssessmentFrCMPLBatch(cmplList);
         DataBase.executeBatch(crGA);
         Test.stopTest();
     }
}