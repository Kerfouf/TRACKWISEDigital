/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface ExternalWorkOrderSelector extends fflib_ISObjectSelector {
    List<WorkOrder__x> selectByDateModified(DateTime asOf);
    List<WorkOrder__x> selectByExternalIds(Set<Id> externalIds);
}