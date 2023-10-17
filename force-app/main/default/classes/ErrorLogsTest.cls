/*
* Created on Thu Dec 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ErrorLogsTest {
    @IsTest
    static void retryTest(){
        
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        
        List<Error_Log__c> errorLogs = new List<Error_Log__c> {
            CrmComplaintIntegrationTestDataFactory.createErrorLog(
                false, 
                'CMPL123CME__Questionnaire__c', 
                fflib_IDGenerator.generate(Case__x.SObjectType)
              ),
              CrmComplaintIntegrationTestDataFactory.createErrorLog(
                  false, 
                  'Case_Comment__c', 
                  fflib_IDGenerator.generate(CaseComment__x.SObjectType)
              ),
              CrmComplaintIntegrationTestDataFactory.createErrorLog(
                  false, 
                  'CMPL123CME__Complaint__c', 
                  fflib_IDGenerator.generate(Case__x.SObjectType)
              ),
              CrmComplaintIntegrationTestDataFactory.createErrorLog(
                  false, 
                  'Product_Consumed__c', 
                  fflib_IDGenerator.generate(ProductConsumed__x.SObjectType)
              ),
              CrmComplaintIntegrationTestDataFactory.createErrorLog(
                  false, 
                  'Service_Appointment__c', 
                  fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType)
              ),
              CrmComplaintIntegrationTestDataFactory.createErrorLog(
                  false, 
                  'Work_Order__c', 
                  fflib_IDGenerator.generate(WorkOrder__x.SObjectType)
              )
        };

        insert errorLogs;

        for (Error_Log__c log : errorLogs) {
            log.Status__c = 'Retry';
        }
        
        Test.startTest();
            update errorLogs;
        Test.stopTest();

        System.assertEquals(0, [Select Count() From Error_Log__c Where Status__c = 'Retry']);
        System.assertNotEquals(0, [Select Count() From Error_Log__c Where Status__c = 'Complete']);
        
    }
}