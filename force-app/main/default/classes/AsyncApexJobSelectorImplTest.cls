/*
 * Created on Thur Dec 9, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class AsyncApexJobSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        AsyncApexJobSelectorImpl selector = (AsyncApexJobSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(AsyncApexJob.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(AsyncApexJob.Id));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        AsyncApexJobSelectorImpl selector = (AsyncApexJobSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(AsyncApexJob.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(AsyncApexJob.SObjectType, returnSObjectType);
    }

    @IsTest
    static void isJobRunningTest() {

        Boolean isRunning;
        Test.startTest();
        isRunning = ((AsyncApexJobSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(AsyncApexJob.SObjectType)).isJobRunning('ApexUnitTestBatchJob');
        Test.stopTest();

        System.assert(!isRunning);
    }
}