/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface ExternalRecordTypeSelector extends fflib_ISObjectSelector {
    List<RecordType__x> selectById(Set<Id> recordIds);
}