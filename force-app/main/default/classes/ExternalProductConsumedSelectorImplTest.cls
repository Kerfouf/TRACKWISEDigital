/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ExternalProductConsumedSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalProductConsumedSelectorImpl selector = (ExternalProductConsumedSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(ProductConsumed__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(ProductConsumed__x.Id));
        System.assert(returnList.contains(ProductConsumed__x.LastModifiedDate__c));
        System.assert(returnList.contains(ProductConsumed__x.ExternalId));
        System.assert(returnList.contains(ProductConsumed__x.QuantityConsumed__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalProductConsumedSelectorImpl selector = (ExternalProductConsumedSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(ProductConsumed__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(ProductConsumed__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByDateModifiedTest() {

        List<ProductConsumed__x> records;

        Test.startTest();
        records = ((ExternalProductConsumedSelector)CrmComplaintIntegrationApplication.selector.newInstance(ProductConsumed__x.SObjectType)).selectByDateModified(
            Datetime.now()
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }

    @IsTest
    static void selectByExternalIdsTest() {

        Id externalId = fflib_IDGenerator.generate(ProductConsumed__x.SObjectType);
        List<ProductConsumed__x> records;

        Test.startTest();
        records = ((ExternalProductConsumedSelector)CrmComplaintIntegrationApplication.selector.newInstance(ProductConsumed__x.SObjectType)).selectByExternalIds(
            new Set<Id> { externalId }
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}