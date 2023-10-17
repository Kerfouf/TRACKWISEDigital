/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalProductSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalProductSelectorImpl selector = (ExternalProductSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Product2__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Product2__x.Id));
        System.assert(returnList.contains(Product2__x.ExternalId));
        System.assert(returnList.contains(Product2__x.Name__c));
        System.assert(returnList.contains(Product2__x.ProductCode__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalProductSelectorImpl selector = (ExternalProductSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Product2__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Product2__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Product2__x> records;

        Test.startTest();
        records = ((ExternalProductSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Product2__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Product2__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}