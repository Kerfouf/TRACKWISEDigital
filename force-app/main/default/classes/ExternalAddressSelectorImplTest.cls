/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalAddressSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalAddressSelectorImpl selector = (ExternalAddressSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Address__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Address__x.Id));
        System.assert(returnList.contains(Address__x.ExternalId));
        System.assert(returnList.size() > 2);
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalAddressSelectorImpl selector = (ExternalAddressSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Address__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Address__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Address__x> records;

        Test.startTest();
        records = ((ExternalAddressSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Address__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Address__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}