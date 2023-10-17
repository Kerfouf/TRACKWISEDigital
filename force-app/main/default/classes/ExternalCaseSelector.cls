/*
* Created on Tues Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ExternalCaseSelector extends fflib_ISObjectSelector {
    List<Case__x> selectByDateModified(DateTime asOf);
    List<Case__x> selectByExternalId(Set<Id> externalIds);
}