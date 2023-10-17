/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class CrmCaseCommentIntegrationServiceImpl extends CrmIntegrationService implements CrmCaseCommentIntegrationService, DBSaveFailureCallback {
    
    public List<CaseComment__x> getExternalCaseCommentsByDateModified(DateTime asOf) {
        ExternalCaseCommentSelector selector = (ExternalCaseCommentSelector) CrmComplaintIntegrationApplication.selector.newInstance(CaseComment__x.SObjectType);
        return selector.selectByDateModified(asOf);
    }

    public List<CaseComment__x> getExternalCaseCommentsByExternalIds(Set<Id> externalIds) {
        ExternalCaseCommentSelector selector = (ExternalCaseCommentSelector) CrmComplaintIntegrationApplication.selector.newInstance(CaseComment__x.SObjectType);
        return selector.selectByExternalId(externalIds);
    }

    public void upsertCaseComments(List<CaseComment__x> externalCaseComments) {
        Set<Id> externalCaseCommentExternalIds = extractExternalIds(externalCaseComments);        
        CaseCommentSelector selector = (CaseCommentSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case_Comment__c.SObjectType);
        Map<Id, Case_Comment__c> caseCommentsByExternalId = selector.selectCaseCommentByExternalId(externalCaseCommentExternalIds);

        List<Case_Comment__c> caseCommentsToUpsert = new CrmCaseComments(externalCaseComments, caseCommentsByExternalId).toCaseCommentsUpsertList();
        upsertList(caseCommentsToUpsert, this);
    }

    public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
        logError(
            'Id',
            'ExternalId__c',
            'CrmCaseCommentIntegrationServiceImpl',
            'Case_Comment__c',
            failures
        );
    }
}