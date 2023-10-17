/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmProductsConsumed {

    private List<ProductConsumed__x> externalProductsConsumed;
    private Map<Id, Product_Consumed__c> productsConsumedByExternalId;

    public CrmProductsConsumed(List<ProductConsumed__x> externalProductsConsumed, Map<Id, Product_Consumed__c> productsConsumedByExternalId) {
        this.externalProductsConsumed = externalProductsConsumed;
        this.productsConsumedByExternalId = productsConsumedByExternalId;
    }

    public List<Product_Consumed__c> toProductsConsumedUpsertList() {
        List<Product_Consumed__c> returnList = new List<Product_Consumed__c>();

        for (ProductConsumed__x externalProductConsumed : externalProductsConsumed) {
            Product_Consumed__c existingProductConsumed = productsConsumedByExternalId.get(externalProductConsumed.ExternalId);

            if (existingProductConsumed == null) {
                returnList.add(
                    new Product_Consumed__c(
                        WorkOrderId__r = new Work_Order__c(ExternalId__c = externalProductConsumed.WorkOrderId__r.ExternalId),
                        ExternalId__c = externalProductConsumed.ExternalId,
                        Product_Consumed_WO__c = externalProductConsumed.WorkOrderId__r.WorkOrderNumber__c,
                        Product_Consumed_Price_Book_Entry__c = externalProductConsumed.PricebookEntryId__r.LocalProductName_c__c,
                        Product_Quantity_Consumed__c = externalProductConsumed.QuantityConsumed__c
                    )    
                );
            }
            else {
                if (requiresUpdate(externalProductConsumed, existingProductConsumed)) {
                    // update existing
                    existingProductConsumed.Product_Consumed_WO__c = externalProductConsumed.WorkOrderId__r.WorkOrderNumber__c;
                    existingProductConsumed.Product_Consumed_Price_Book_Entry__c = externalProductConsumed.PricebookEntryId__r.LocalProductName_c__c;
                    existingProductConsumed.Product_Quantity_Consumed__c = externalProductConsumed.QuantityConsumed__c;
                    
                    // add to list
                    returnList.add(existingProductConsumed);
                }
            }
        }

        return returnList;
    }

    private Boolean requiresUpdate(ProductConsumed__x externalProductConsumed, Product_Consumed__c existingProductConsumed) {
        Boolean workOrderNumberChanged = externalProductConsumed.WorkOrderId__r.WorkOrderNumber__c != existingProductConsumed.Product_Consumed_WO__c;
        Boolean pricebookEntryChanged = externalProductConsumed.PricebookEntryId__r.LocalProductName_c__c != existingProductConsumed.Product_Consumed_Price_Book_Entry__c;
        Boolean quantityConsumedChanged = externalProductConsumed.QuantityConsumed__c != existingProductConsumed.Product_Quantity_Consumed__c;

        return workOrderNumberChanged || pricebookEntryChanged || quantityConsumedChanged;
    }
}