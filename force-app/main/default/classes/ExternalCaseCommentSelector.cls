/*
* Created on Tues Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ExternalCaseCommentSelector extends fflib_ISObjectSelector {
    List<CaseComment__x> selectByDateModified(DateTime asOf);
    List<CaseComment__x> selectByExternalId(Set<Id> externalIds);
}