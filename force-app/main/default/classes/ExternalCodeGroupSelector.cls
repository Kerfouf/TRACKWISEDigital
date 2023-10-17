/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface ExternalCodeGroupSelector extends fflib_ISObjectSelector {
    List<CodeGroup_c__x> selectById(Set<Id> recordIds);
}