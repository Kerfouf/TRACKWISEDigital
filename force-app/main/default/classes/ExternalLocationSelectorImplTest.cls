/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalLocationSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalLocationSelectorImpl selector = (ExternalLocationSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Location__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Location__x.Id));
        System.assert(returnList.contains(Location__x.ExternalId));
        System.assert(returnList.contains(Location__x.Name__c));
        System.assert(returnList.contains(Location__x.VisitorAddressId__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalLocationSelectorImpl selector = (ExternalLocationSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Location__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Location__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Location__x> records;

        Test.startTest();
        records = ((ExternalLocationSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Location__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Location__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}