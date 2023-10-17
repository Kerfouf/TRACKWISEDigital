/*
* Created on Wed Nov 17, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface GlobalAssessmentService {
    List<CMPL123CME__Complaint__c> getPREsByDateModified(DateTime asOf);
    List<CMPL123CME__Complaint__c> getPREsByExternalIds(Set<Id> externalIds);
    void createMissingGlobalAssessments(List<CMPL123CME__Complaint__c> complaints);
}