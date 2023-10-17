/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalUserSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalUserSelectorImpl selector = (ExternalUserSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(User__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(User__x.Id));
        System.assert(returnList.contains(User__x.ExternalId));
        System.assert(returnList.contains(User__x.Name__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalUserSelectorImpl selector = (ExternalUserSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(User__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(User__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<User__x> records;

        Test.startTest();
        records = ((ExternalUserSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(User__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(User__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}