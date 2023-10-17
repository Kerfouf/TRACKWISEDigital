/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmServiceAppointmentIntServiceImpl extends CrmIntegrationService implements CrmServiceAppointmentIntegrationService, DBSaveFailureCallback {
    
    public List<ServiceAppointment__x> getExternalServiceAppointmentsByDateModified(DateTime asOf) {
        ExternalServiceAppointmentSelector selector = (ExternalServiceAppointmentSelector) CrmComplaintIntegrationApplication.selector.newInstance(ServiceAppointment__x.SObjectType);
        return selector.selectByDateModified(asOf);
    }

    public List<ServiceAppointment__x> getExternalServiceAppointmentsByExternalIds(Set<Id> externalIds) {
        ExternalServiceAppointmentSelector selector = (ExternalServiceAppointmentSelector) CrmComplaintIntegrationApplication.selector.newInstance(ServiceAppointment__x.SObjectType);
        return selector.selectByExternalIds(externalIds);
    }

    public void upsertServiceAppointments(List<ServiceAppointment__x> externalServiceAppointments) {
        Set<Id> externalServiceAppointmentExternalIds = extractExternalIds(externalServiceAppointments);
        ServiceAppointmentSelector selector = (ServiceAppointmentSelector) CrmComplaintIntegrationApplication.selector.newInstance(Service_Appointment__c.SObjectType);
        Map<Id, Service_Appointment__c> serviceAppointmentsByExternalId = selector.selectServiceAppointmentsByExternalId(externalServiceAppointmentExternalIds);
        List<Service_Appointment__c> serviceAppointmentsToUpsert = new CrmServiceAppointments(externalServiceAppointments, serviceAppointmentsByExternalId).toServiceAppointmentsUpsertList();
        upsertList(serviceAppointmentsToUpsert, this);
    }

    public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
        logError(
            'Id',
            'ExternalId__c',
            'CrmServiceAppointmentIntServiceImpl',
            'Service_Appointment__c',
            failures
        );
    }
}