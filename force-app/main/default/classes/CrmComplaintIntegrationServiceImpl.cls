/*
* Created on Thurs Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class CrmComplaintIntegrationServiceImpl extends CrmIntegrationService 
    implements CrmComplaintIntegrationService, DBSaveFailureCallback {

    public List<Case__x> getExternalCasesByDateModified(DateTime asOf) {
        ExternalCaseSelector selector = (ExternalCaseSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        return selector.selectByDateModified(asOf);
    }

    public List<Case__x> getExternalCasesByExternalId(Set<Id> externalIds) {
        ExternalCaseSelector selector = (ExternalCaseSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        return selector.selectByExternalId(externalIds);
    }

    public void upsertComplaints(List<Case__x> cases) {
        upsertComplaints(cases, this);
    }

    public void upsertComplaints(List<Case__x> cases, DBSaveFailureCallback callback) {
        
        CrmCases crmCases = new CrmCases(cases);
        List<CMPL123CME__Complaint__c> complaintsToUpsert = crmCases.toComplaintsUpsertList();

        upsertList(complaintsToUpsert, callback);
    }

    public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
        logError(
            'Id',
            'BMX_Case_External__c',
            'CrmComplaintIntegrationServiceImpl',
            'CMPL123CME__Complaint__c',
            failures
        );
    }
}