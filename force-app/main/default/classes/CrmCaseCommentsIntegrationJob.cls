/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class CrmCaseCommentsIntegrationJob extends CrmBatchableJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private CrmCaseCommentIntegrationService service;
    
    public CrmCaseCommentsIntegrationJob(CRM_Integration_Settings__c batchConfig) {
        super(batchConfig);
        this.service = (CrmCaseCommentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmCaseCommentIntegrationService.class);
    }

    public List<CaseComment__x> start(Database.BatchableContext bc) {
        try {
            return service.getExternalCaseCommentsByDateModified(
                calculateAsOfDate()
            );           
        }
        catch (Exception ex){
            CrmBatchableJob.batchErrors.add(ex);
            throw(ex);
        }
    }

    public void execute(Database.BatchableContext bc, List<CaseComment__x> scope) {
        service.upsertCaseComments(scope);
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
        return executeBatch(this, (Integer)this.batchConfig.Case_Comment_Batch_Size__c);
    }

    private DateTime calculateAsOfDate() {
        
        DateTime asOfDate = this.batchConfig.Case_Comments_As_Of__c;

        if (asOfDate > this.batchConfig.Complaints_As_Of__c) {
            asOfDate = this.batchConfig.Complaints_As_Of__c;
        }

        return asOfDate;
    }

    private void setBatchAsOf() {
        update new CRM_Integration_Settings__c(
            Id = this.batchConfig.Id,
            Case_Comments_As_Of__c = this.startTime
        );
    }
}