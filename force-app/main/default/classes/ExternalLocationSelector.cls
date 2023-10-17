/*
* Created on Wed Oct 27, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ExternalLocationSelector extends fflib_ISObjectSelector {
    List<Location__x> selectById(Set<Id> recordIds);
}