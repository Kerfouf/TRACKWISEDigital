/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ProductConsumedSelectorImpl extends fflib_SObjectSelector implements ProductConsumedSelector {

    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Product_Consumed__c.Id,
            Product_Consumed__c.ExternalId__c,
            Product_Consumed__c.Product_Consumed_WO__c,
            Product_Consumed__c.Product_Consumed_Price_Book_Entry__c,
            Product_Consumed__c.Product_Quantity_Consumed__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return Product_Consumed__c.SObjectType;
    }

    public Map<Id, Product_Consumed__c> selectProductsConsumedByExternalId(Set<Id> externalIds) {
        
        Map<Id, Product_Consumed__c> returnMap = new Map<Id, Product_Consumed__c>();
        String queryCondition = 'ExternalId__c in :externalIds';

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(queryCondition)
            .selectFields(getSObjectFieldList());

        fflib_SObjectSelector workOrderSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Work_Order__c.SObjectType);
        workOrderSelector.configureQueryFactoryFields(queryFactory, 'workOrderId__r');
        
        for (Product_Consumed__c productConsumed : Database.query(queryFactory.toSOQL())) {
            returnMap.put(productConsumed.ExternalId__c, productConsumed);
        }

        return returnMap;
    }
}