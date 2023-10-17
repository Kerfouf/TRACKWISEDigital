/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalAssetSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalAssetSelectorImpl selector = (ExternalAssetSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Asset__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Asset__x.Id));
        System.assert(returnList.contains(Asset__x.ExternalId));
        System.assert(returnList.contains(Asset__x.Name__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalAssetSelectorImpl selector = (ExternalAssetSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Asset__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Asset__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Asset__x> records;

        Test.startTest();
        records = ((ExternalAssetSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Asset__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Asset__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}