/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ServiceAppointmentSelector extends fflib_ISObjectSelector {
    Map<Id, Service_Appointment__c> selectServiceAppointmentsByExternalId(Set<Id> externalIds);
}