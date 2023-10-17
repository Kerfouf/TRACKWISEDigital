/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public without sharing class CrmComplaintIntegrationJob extends CrmBatchableJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private CrmComplaintIntegrationService service;

    public CrmComplaintIntegrationJob(CRM_Integration_Settings__c batchConfig) {
        super(batchConfig);
        this.service = (CrmComplaintIntegrationService)CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
    }

    public List<Case__x> start(Database.BatchableContext bc) {
        try {
            return service.getExternalCasesByDateModified(
                this.batchConfig.Complaints_As_Of__c
            );
        }
        catch (Exception ex){
            CrmBatchableJob.batchErrors.add(ex);
            throw(ex);
        }
    }

    public void execute(Database.BatchableContext bc, List<Case__x> scope) {
        service.upsertComplaints(scope);
    }

    public void finish(Database.BatchableContext bc) {
        new CreateGlobalAssessmentsJob(batchConfig).run();
        new CrmCaseCommentsIntegrationJob(batchConfig).run();
        new CrmWorkOrderIntegrationJob(batchConfig).run();
        if (CrmBatchableJob.batchErrors.isEmpty()) {
            setBatchAsOf();
        }
        else {
            System.debug(CrmBatchableJob.batchErrors);
        }
    }

    public String run() {
        return executeBatch(this, (Integer)this.batchConfig.Complaint_Batch_Size__c);
    }

    private void setBatchAsOf() {
        update new CRM_Integration_Settings__c(
            Id = this.batchConfig.Id,
            Complaints_As_Of__c = this.startTime
        );
    }
}