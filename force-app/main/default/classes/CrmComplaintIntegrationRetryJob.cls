/*
* Created on Fri Dec 10, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmComplaintIntegrationRetryJob extends CrmRetryJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private CrmComplaintIntegrationService service;
    
    public CrmComplaintIntegrationRetryJob(List<Error_Log__c> logs) {
        super(logs);
        this.service = (CrmComplaintIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
    }

    public List<Case__x> start(Database.BatchableContext bc) {
        return service.getExternalCasesByExternalId(this.externalIds);
    }

    public void execute(Database.BatchableContext bc, List<Case__x> scope) {
        service.upsertComplaints(scope);
    }

    public void finish(Database.BatchableContext bc) {
        setLogStatusClosed();
    }

    public override String run() {
        Integer batchSize = Integer.valueOf(CRM_Integration_Settings__c.getOrgDefaults().Complaint_Batch_Size__c);
        return Database.executeBatch(this, batchSize);
    }
}