/*
* Created on Mon Nov 29, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ProductConsumedSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ProductConsumedSelectorImpl selector = (ProductConsumedSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Product_Consumed__c.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Product_Consumed__c.Id));
        System.assert(returnList.contains(Product_Consumed__c.ExternalId__c));
        System.assert(returnList.contains(Product_Consumed__c.Product_Consumed_WO__c));
        System.assert(returnList.contains(Product_Consumed__c.Product_Consumed_Price_Book_Entry__c));
        System.assert(returnList.contains(Product_Consumed__c.Product_Quantity_Consumed__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ProductConsumedSelectorImpl selector = (ProductConsumedSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Product_Consumed__c.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Product_Consumed__c.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByDateModifiedTest() {

        Product_Consumed__c productConsumed = CrmComplaintIntegrationTestDataFactory.createProductConsumed(true);
        Map<Id, Product_Consumed__c> recordMap;

        Test.startTest();
        recordMap = ((ProductConsumedSelector)CrmComplaintIntegrationApplication.selector.newInstance(Product_Consumed__c.SObjectType)).selectProductsConsumedByExternalId(
            new Set<Id> { productConsumed.ExternalId__c }
        );
        Test.stopTest();

        System.assertEquals(1, recordMap.keySet().size());
    }
}