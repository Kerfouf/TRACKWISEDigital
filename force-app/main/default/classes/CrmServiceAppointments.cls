/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CrmServiceAppointments {
    
    private List<ServiceAppointment__x> externalServiceAppointments;
    private Map<Id, Service_Appointment__c> serviceAppointmentsByExternalId;
    
    public CrmServiceAppointments(List<ServiceAppointment__x> externalServiceAppointments, Map<Id, Service_Appointment__c> serviceAppointmentsByExternalId) {
        this.externalServiceAppointments = externalServiceAppointments;
        this.serviceAppointmentsByExternalId = serviceAppointmentsByExternalId;
    }

    public List<Service_Appointment__c> toServiceAppointmentsUpsertList() {
        
        List<Service_Appointment__c> returnList = new List<Service_Appointment__c>();

        for (ServiceAppointment__x externalServiceAppointment : externalServiceAppointments) {
            Service_Appointment__c existingServiceAppointment = serviceAppointmentsByExternalId.get(externalServiceAppointment.ExternalId);

            if (existingServiceAppointment == null) {
                returnList.add(
                    new Service_Appointment__c(
                        workOrderId__r = new Work_Order__c(ExternalId__c = externalServiceAppointment.WorkOrder_c__r.ExternalId),
                        ExternalId__c = externalServiceAppointment.ExternalId,
                        SA_Description__c = externalServiceAppointment.Description__c,
                        SA_Parent_record__c = externalServiceAppointment.WorkOrder_c__r.WorkOrderNumber__c,
                        SA_Status__c = externalServiceAppointment.Status__c
                    )    
                );
            }
            else {
                if (requiresUpdate(externalServiceAppointment, existingServiceAppointment)) {
                    // update existing
                    existingServiceAppointment.SA_Description__c = externalServiceAppointment.Description__c;
                    existingServiceAppointment.SA_Parent_record__c = externalServiceAppointment.WorkOrder_c__r.WorkOrderNumber__c;
                    existingServiceAppointment.SA_Status__c = externalServiceAppointment.Status__c;
                    
                    // add to list
                    returnList.add(existingServiceAppointment);
                }
            }
        }

        return returnList;
    }

    private Boolean requiresUpdate(ServiceAppointment__x externalServiceAppointment, Service_Appointment__c existingServiceAppointment) {
        Boolean descriptionChanged = externalServiceAppointment.Description__c != existingServiceAppointment.SA_Description__c;
        Boolean parentWorkOrderNumberChanged = externalServiceAppointment.WorkOrder_c__r.WorkOrderNumber__c != existingServiceAppointment.SA_Parent_record__c;
        Boolean statusChanged = externalServiceAppointment.Status__c != existingServiceAppointment.SA_Status__c;
        
        return descriptionChanged || parentWorkOrderNumberChanged || statusChanged;
    }
}