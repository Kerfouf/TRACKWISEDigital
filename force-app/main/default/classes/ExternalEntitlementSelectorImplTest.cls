/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalEntitlementSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalEntitlementSelectorImpl selector = (ExternalEntitlementSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Entitlement__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Entitlement__x.Id));
        System.assert(returnList.contains(Entitlement__x.ExternalId));
        System.assert(returnList.contains(Entitlement__x.Name__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalEntitlementSelectorImpl selector = (ExternalEntitlementSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Entitlement__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Entitlement__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Entitlement__x> records;

        Test.startTest();
        records = ((ExternalEntitlementSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Entitlement__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Entitlement__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}