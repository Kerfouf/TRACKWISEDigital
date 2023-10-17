/*
* Created on Thur Dec 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmIntegrationErrorNotificationSchedTest {
    
    @IsTest
    static void executeTest(){
        
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        insert new Error_Log__c(Status__c = 'Failed');
        CrmIntegrationErrorNotificationSched scheduleable = new CrmIntegrationErrorNotificationSched();

        Test.startTest();
        scheduleable.execute(null);
        Test.stopTest();
        
        CRM_Integration_Settings__c configAfter = CRM_Integration_Settings__c.getOrgDefaults();
        
        System.assertEquals(scheduleable.activeFailures, 1);
    }
}