/*
* Created on Fri Nov 19, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface CaseCommentSelector extends fflib_ISObjectSelector {
    Map<Id, Case_Comment__c> selectCaseCommentByExternalId(Set<Id> externalCaseCommentExternalIds);
}