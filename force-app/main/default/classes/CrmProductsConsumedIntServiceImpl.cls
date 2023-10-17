/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmProductsConsumedIntServiceImpl extends CrmIntegrationService implements CrmProductsConsumedIntegrationService, DBSaveFailureCallback {
    
    public List<ProductConsumed__x> getExternalProductsConsumedByDateModified(DateTime asOf) {
        ExternalProductConsumedSelector selector = (ExternalProductConsumedSelector) CrmComplaintIntegrationApplication.selector.newInstance(ProductConsumed__x.SObjectType);
        return selector.selectByDateModified(asOf);
    }

    public List<ProductConsumed__x> getExternalProductsConsumedByExternalIds(Set<Id> externalIds) {
        ExternalProductConsumedSelector selector = (ExternalProductConsumedSelector) CrmComplaintIntegrationApplication.selector.newInstance(ProductConsumed__x.SObjectType);
        return selector.selectByExternalIds(externalIds);
    }

    public void upsertProductsConsumed(List<ProductConsumed__x> externalProductsConsumed) {
        Set<Id> externalProductConsumedExternalIds = extractExternalIds(externalProductsConsumed);
        ProductConsumedSelector selector = (ProductConsumedSelector) CrmComplaintIntegrationApplication.selector.newInstance(Product_Consumed__c.SObjectType);
        Map<Id, Product_Consumed__c> productsConsumedByExternalId = selector.selectProductsConsumedByExternalId(externalProductConsumedExternalIds);
        List<Product_Consumed__c> productsConsumedToUpsert = new CrmProductsConsumed(externalProductsConsumed, productsConsumedByExternalId).toProductsConsumedUpsertList();
        upsertList(productsConsumedToUpsert, this);
    }

    public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
        logError(
            'Id',
            'ExternalId__c',
            'CrmProductsConsumedIntServiceImpl',
            'Product_Consumed__c',
            failures
        );
    }
}