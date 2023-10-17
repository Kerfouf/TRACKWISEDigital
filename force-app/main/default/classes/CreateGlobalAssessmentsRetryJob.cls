/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CreateGlobalAssessmentsRetryJob extends CrmRetryJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private GlobalAssessmentService service;

    public CreateGlobalAssessmentsRetryJob(List<Error_Log__c> logs) {
        super(logs);
        this.service = (GlobalAssessmentService) CrmComplaintIntegrationApplication.service.newInstance(GlobalAssessmentService.class);
    }

    public List<CMPL123CME__Complaint__c> start(Database.BatchableContext bc) {
        List<CMPL123CME__Complaint__c> complaints = service.getPREsByExternalIds(this.externalIds);
        return complaints;
    }

    public void execute(Database.BatchableContext bc, List<CMPL123CME__Complaint__c> scope) {
        service.createMissingGlobalAssessments(scope);
    }

    public void finish(Database.BatchableContext bc) {
        setLogStatusClosed();
    }

    public override String run() {
        Integer batchSize = Integer.valueOf(CRM_Integration_Settings__c.getOrgDefaults().Global_Assessment_Batch_Size__c);
        return Database.executeBatch(this, batchSize);
    }
}