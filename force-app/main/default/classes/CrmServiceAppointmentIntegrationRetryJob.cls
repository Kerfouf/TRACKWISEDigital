/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmServiceAppointmentIntegrationRetryJob extends CrmRetryJob implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {
    
    private CrmServiceAppointmentIntegrationService service;

    public CrmServiceAppointmentIntegrationRetryJob(List<Error_Log__c> logs) {
        super(logs);
        this.service = (CrmServiceAppointmentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmServiceAppointmentIntegrationService.class);
    }

    public List<ServiceAppointment__x> start(Database.BatchableContext bc) {
        List<ServiceAppointment__x> serviceAppointments = service.getExternalServiceAppointmentsByExternalIds(this.externalIds);
        return serviceAppointments;
    }

    public void execute(Database.BatchableContext bc, List<ServiceAppointment__x> scope) {
        service.upsertServiceAppointments(scope);
    }

    public void finish(Database.BatchableContext bc) {
        setLogStatusClosed();
    }

    public override String run() {
        Integer batchSize = Integer.valueOf(CRM_Integration_Settings__c.getOrgDefaults().Service_Appointment_Batch_Size__c);
        return Database.executeBatch(this, batchSize);
    }
}