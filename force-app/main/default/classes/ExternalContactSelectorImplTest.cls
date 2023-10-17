/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalContactSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalContactSelectorImpl selector = (ExternalContactSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Contact__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Contact__x.Id));
        System.assert(returnList.contains(Contact__x.ExternalId));
        System.assert(returnList.contains(Contact__x.Name__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalContactSelectorImpl selector = (ExternalContactSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Contact__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Contact__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Contact__x> records;

        Test.startTest();
        records = ((ExternalContactSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Contact__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Contact__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}