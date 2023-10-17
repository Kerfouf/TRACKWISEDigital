/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface ComplaintSelector extends fflib_ISObjectSelector {
    List<CMPL123CME__Complaint__c> selectByExternalCaseId(Set<Id> externalCaseIds);
    List<CMPL123CME__Complaint__c> selectPREsByDateModified(DateTime asOf);
    List<CMPL123CME__Complaint__c> selectPREsByExternalIds(Set<Id> externalIds);
}