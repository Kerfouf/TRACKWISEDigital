/*
* Created on Mon Dec 6, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmCaseCommentsIntegrationRetryJob extends CrmRetryJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private CrmCaseCommentIntegrationService service;

    public CrmCaseCommentsIntegrationRetryJob(List<Error_Log__c> logs) {
        super(logs);
        this.service = (CrmCaseCommentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmCaseCommentIntegrationService.class);
    }

    public List<CaseComment__x> start(Database.BatchableContext bc) {
        List<CaseComment__x> caseComments = service.getExternalCaseCommentsByExternalIds(this.externalIds);
        return caseComments;
    }

    public void execute(Database.BatchableContext bc, List<CaseComment__x> scope) {
        service.upsertCaseComments(scope);
    }

    public void finish(Database.BatchableContext bc) {
        setLogStatusClosed();
    }

    public override String run() {
        Integer batchSize = Integer.valueOf(CRM_Integration_Settings__c.getOrgDefaults().Case_Comment_Batch_Size__c);
        return Database.executeBatch(this, batchSize);
    }
}