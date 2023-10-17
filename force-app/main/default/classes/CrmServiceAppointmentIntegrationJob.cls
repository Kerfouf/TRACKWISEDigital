/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmServiceAppointmentIntegrationJob extends CrmBatchableJob implements Database.Batchable<SObject>, Database.Stateful, Database.AllowsCallouts {

    private CrmServiceAppointmentIntegrationService service;

    public CrmServiceAppointmentIntegrationJob(CRM_Integration_Settings__c batchConfig) {
        super(batchConfig);
        this.service = (CrmServiceAppointmentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmServiceAppointmentIntegrationService.class);
    }

    public List<ServiceAppointment__x> start(Database.BatchableContext bc) {
        try {
            return service.getExternalServiceAppointmentsByDateModified(
                calculateAsOfDate()
            );
        }
        catch (Exception ex){
            CrmBatchableJob.batchErrors.add(ex);
            throw(ex);
        }
    }

    public void execute(Database.BatchableContext bc, List<ServiceAppointment__x> scope) {
        service.upsertServiceAppointments(scope);
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
        return executeBatch(this, (Integer)this.batchConfig.Service_Appointment_Batch_Size__c);
    }

    private DateTime calculateAsOfDate() {
        
        DateTime asOfDate = this.batchConfig.Service_Appointments_As_Of__c;

        if (asOfDate > this.batchConfig.Work_Orders_As_Of__c) {
            asOfDate = this.batchConfig.Work_Orders_As_Of__c;
        }
        if (asOfDate > this.batchConfig.Complaints_As_Of__c) {
            asOfDate = this.batchConfig.Complaints_As_Of__c;
        }

        return asOfDate;
    }

    private void setBatchAsOf() {
        update new CRM_Integration_Settings__c(
            Id = this.batchConfig.Id,
            Service_Appointments_As_Of__c = this.startTime
        );
    }
}