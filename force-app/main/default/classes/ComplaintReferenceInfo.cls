public with sharing class ComplaintReferenceInfo {

    private Set<Id> externalCaseIds;
    private Map<Id, CMPL123CME__Complaint__c> cmpResultMap = new Map<Id, CMPL123CME__Complaint__c>();
    
    public ComplaintReferenceInfo(Set<Id> externalCaseIds) {
        this.externalCaseIds = externalCaseIds;
        initialize();
    }

    public CMPL123CME__Complaint__c getComplaintData(Id externalId) {
        return cmpResultMap.containsKey(externalId) ? cmpResultMap.get(externalId) : new CMPL123CME__Complaint__c();
    }

    private void initialize() {
        ComplaintSelector selector = (ComplaintSelector) CrmComplaintIntegrationApplication.selector.newInstance(
            CMPL123CME__Complaint__c.SObjectType
        );

        for (CMPL123CME__Complaint__c complaint : selector.selectByExternalCaseId(externalCaseIds)){
            cmpResultMap.put(complaint.BMX_Case_External__c, complaint);
        }
    }
}