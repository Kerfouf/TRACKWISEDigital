/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface WorkOrderSelector extends fflib_ISObjectSelector {
    Map<Id, Work_Order__c> selectWorkOrdersByExternalId(Set<Id> externalIds);
}