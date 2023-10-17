/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmWorkOrderIntegrationRetryJob extends CrmRetryJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private CrmWorkOrderIntegrationService service;

    public CrmWorkOrderIntegrationRetryJob(List<Error_Log__c> logs) {
        super(logs);
        this.service = (CrmWorkOrderIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmWorkOrderIntegrationService.class);
    }

    public List<WorkOrder__x> start(Database.BatchableContext bc) {
        List<WorkOrder__x> workOrders = service.getExternalWorkOrdersByExternalIds(this.externalIds);
        return workOrders;
    }

    public void execute(Database.BatchableContext bc, List<WorkOrder__x> scope) {
        service.upsertWorkOrders(scope);
    }

    public void finish(Database.BatchableContext bc) {
        setLogStatusClosed();
    }

    public override String run() {
        Integer batchSize = Integer.valueOf(CRM_Integration_Settings__c.getOrgDefaults().Work_Order_Batch_Size__c);
        return Database.executeBatch(this, batchSize);
    }
}