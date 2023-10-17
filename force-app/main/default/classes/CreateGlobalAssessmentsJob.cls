/*
* Created on Fri Dec 03, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CreateGlobalAssessmentsJob extends CrmBatchableJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    
    private GlobalAssessmentService service;

    public CreateGlobalAssessmentsJob(CRM_Integration_Settings__c batchConfig) {
        super(batchConfig);
        this.service = (GlobalAssessmentService) CrmComplaintIntegrationApplication.service.newInstance(GlobalAssessmentService.class);
    }

    public List<CMPL123CME__Complaint__c> start(Database.BatchableContext bc) {
        try {
            return service.getPREsByDateModified(
                calculateAsOfDate()
            );
        }
        catch (Exception ex){
            CrmBatchableJob.batchErrors.add(ex);
            throw(ex);
        }
    }

    public void execute(Database.BatchableContext bc, List<CMPL123CME__Complaint__c> scope) {
        service.createMissingGlobalAssessments(scope);
    }

    public void finish(Database.BatchableContext bc) {
        if (CrmBatchableJob.batchErrors.isEmpty()) {
            setBatchAsOf();
        }
        else {
            System.debug(CrmBatchableJob.batchErrors);
        }
    }

    public String run() {
        return executeBatch(this, (Integer)this.batchConfig.Global_Assessment_Batch_Size__c);
    }
    
    private DateTime calculateAsOfDate() {
        
        DateTime asOfDate = this.batchConfig.Global_Assessments_As_Of__c;

        if (asOfDate > this.batchConfig.Complaints_As_Of__c) {
            asOfDate = this.batchConfig.Complaints_As_Of__c;
        }

        return asOfDate;
    }

    private void setBatchAsOf() {
        update new CRM_Integration_Settings__c(
            Id = this.batchConfig.Id,
            Global_Assessments_As_Of__c = this.startTime
        );
    }
}