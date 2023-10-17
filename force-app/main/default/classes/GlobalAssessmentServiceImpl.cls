/*
* Created on Wed Nov 17, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class GlobalAssessmentServiceImpl extends CrmIntegrationService implements GlobalAssessmentService, DBSaveFailureCallback {

    private final string INITIAL_KEY_VALUE = 'Assessment';
    private final string ASSIGN_TO_QUEUE_NAME = 'BMX_RQC';

    public List<CMPL123CME__Complaint__c> getPREsByDateModified(DateTime asOf) {
        ComplaintSelector selector = (ComplaintSelector) CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType);
        return selector.selectPREsByDateModified(asOf);
    }

    public List<CMPL123CME__Complaint__c> getPREsByExternalIds(Set<Id> externalIds) {
        ComplaintSelector selector = (ComplaintSelector) CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType);
        return selector.selectPREsByExternalIds(externalIds);
    }

    public void createMissingGlobalAssessments(List<CMPL123CME__Complaint__c> complaints) {        
        List<CMPL123CME__Questionnaire__c> globalAssessmentsToCreate = getAssessmentsToCreate(complaints);
        upsertList(globalAssessmentsToCreate, this);
    }

    public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
        logError(
            'CMPL123CME__Complaint__c',
            'BMX_Case_External__c',
            'GlobalAssessmentServiceImpl',
            'CMPL123CME__Questionnaire__c',
            failures
        );
    }

    private List<CMPL123CME__Questionnaire__c> getAssessmentsToCreate(List<CMPL123CME__Complaint__c> complaints) {

        Id globalAssessmentRecordTypeId = Schema.SObjectType.CMPL123CME__Questionnaire__c.getRecordTypeInfosByName().get('Global Assessment').getRecordTypeId();
        Id assessmentOwnerId;
        List<CMPL123CME__Questionnaire__c> globalAssessmentsToCreate = new List<CMPL123CME__Questionnaire__c>();

        for (CMPL123CME__Complaint__c complaint : complaints) {
            // If no global assessments exist
            if (complaint.CMPL123CME__Questionnaires__r.size() == 0 && complaint.BMX_PRE__c == 'Yes') {

                // Perform queue id lookup exactly once, and only if we have assessments to create
                assessmentOwnerId = assessmentOwnerId == null ? getAssignedToQueueId() : assessmentOwnerId;

                // Manufacture new Global Assessment record and add it to the list for insertion
                globalAssessmentsToCreate.add(
                    new CMPL123CME__Questionnaire__c(
                        CMPL123CME__Complaint__c = complaint.Id,
                        CMPL123CME__Key_value__c = INITIAL_KEY_VALUE,
                        RecordTypeId = globalAssessmentRecordTypeId,
                        OwnerId = assessmentOwnerId
                    )
                );
            }
        }

        return globalAssessmentsToCreate;
    }

    private Id getAssignedToQueueId() {
        GroupSelector selector = (GroupSelector) CrmComplaintIntegrationApplication.selector.newInstance(Group.SObjectType);
        Group queue = selector.selectQueueByName(ASSIGN_TO_QUEUE_NAME);
        return queue.Id;
    }
}