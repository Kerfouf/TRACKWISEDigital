/*
 * Created on Tue Nov 23, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

public interface ExternalServiceAppointmentSelector extends fflib_ISObjectSelector {
    List<ServiceAppointment__x> selectByDateModified(DateTime asOf);
    List<ServiceAppointment__x> selectByExternalIds(Set<Id> externalIds);
}