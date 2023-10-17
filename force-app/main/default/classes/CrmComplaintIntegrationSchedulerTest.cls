/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmComplaintIntegrationSchedulerTest {
    
    @IsTest
    static void executeTest(){
        
        CRM_Integration_Settings__c configBefore = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);

        Test.startTest();
        CrmComplaintIntegrationScheduler scheduleable = new CrmComplaintIntegrationScheduler();
        scheduleable.execute(null);
        Test.stopTest();
        
        CRM_Integration_Settings__c configAfter = CRM_Integration_Settings__c.getOrgDefaults();
        
        System.assertNotEquals(configBefore.Complaints_As_Of__c, configAfter.Complaints_As_Of__c);
    }
}