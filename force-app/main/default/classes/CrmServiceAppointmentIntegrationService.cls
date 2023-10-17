/*
 * Created on Tue Nov 23, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

 public interface CrmServiceAppointmentIntegrationService {
    List<ServiceAppointment__x> getExternalServiceAppointmentsByDateModified(DateTime asOf);
    List<ServiceAppointment__x> getExternalServiceAppointmentsByExternalIds(Set<Id> externalIds);
    void upsertServiceAppointments(List<ServiceAppointment__x> externalServiceAppointments);
}