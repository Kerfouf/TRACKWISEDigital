/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmProductConsumedIntegrationRetryJob extends CrmRetryJob implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    private CrmProductsConsumedIntegrationService service;

    public CrmProductConsumedIntegrationRetryJob(List<Error_Log__c> logs) {
        super(logs);
        this.service = (CrmProductsConsumedIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmProductsConsumedIntegrationService.class);
    }

    public List<ProductConsumed__x> start(Database.BatchableContext bc) {
        List<ProductConsumed__x> productsConsumed = service.getExternalProductsConsumedByExternalIds(this.externalIds);
        return productsConsumed;
    }

    public void execute(Database.BatchableContext bc, List<ProductConsumed__x> scope) {
        service.upsertProductsConsumed(scope);
    }

    public void finish(Database.BatchableContext bc) {
        setLogStatusClosed();
    }

    public override String run() {
        Integer batchSize = Integer.valueOf(CRM_Integration_Settings__c.getOrgDefaults().Product_Consumed_Batch_Size__c);
        return Database.executeBatch(this, batchSize);
    }
}