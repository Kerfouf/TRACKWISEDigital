/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmWorkOrderIntegrationJob extends CrmBatchableJob implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    private CrmWorkOrderIntegrationService service;

    public CrmWorkOrderIntegrationJob(CRM_Integration_Settings__c batchConfig) {
        super(batchConfig);
        this.service = (CrmWorkOrderIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmWorkOrderIntegrationService.class);
    }

    public List<WorkOrder__x> start(Database.BatchableContext bc) {
        try {
            return service.getExternalWorkOrdersByDateModified(
                calculateAsOfDate()
            );
        }
        catch (Exception ex){
            CrmBatchableJob.batchErrors.add(ex);
            throw(ex);
        }
    }

    public void execute(Database.BatchableContext bc, List<WorkOrder__x> scope) {
        service.upsertWorkOrders(scope);
    }

    public void finish(Database.BatchableContext bc) {
        new CrmProductConsumedIntegrationJob(batchConfig).run();
        new CrmServiceAppointmentIntegrationJob(batchConfig).run();
        if (CrmBatchableJob.batchErrors.isEmpty()) {
            setBatchAsOf();
        }
        else {
            System.debug(CrmBatchableJob.batchErrors);
        }
    }

    public String run() {
        return executeBatch(this, (Integer)this.batchConfig.Work_Order_Batch_Size__c);
    }

    private DateTime calculateAsOfDate() {
        
        DateTime asOfDate = this.batchConfig.Work_Orders_As_Of__c;

        if (asOfDate > this.batchConfig.Complaints_As_Of__c) {
            asOfDate = this.batchConfig.Complaints_As_Of__c;
        }

        return asOfDate;
    }

    private void setBatchAsOf() {
        update new CRM_Integration_Settings__c(
            Id = this.batchConfig.Id,
            Work_Orders_As_Of__c = this.startTime
        );
    }
}