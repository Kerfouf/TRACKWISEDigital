public with sharing class CauseInvestigationHelper {
    public static void verifyNoOpenedExtensionRequest(Map<Id, Cause_Investigation__c> newExtensionRequests) {
        
        Set<Id> IdOfExtensionRequestInApprovalStatus = new Set<Id>();
        
        for(Cause_Investigation__c loopCauseInvestigation : newExtensionRequests.values()){
            if(loopCauseInvestigation.CMPL123_WF_Status__c == 'Approval'){
                IdOfExtensionRequestInApprovalStatus.add(loopCauseInvestigation.Id);
            }
        }
        List<Cause_Investigation__c> causeIvest = [
                                                    SELECT
                                                        Id,
                                                        (SELECT Id FROM Extension_Requests__r WHERE (CMPL123_WF_Status__c != 'Closed' AND CMPL123_WF_Status__c != 'Canceled' AND CMPL123_WF_Status__c != 'Rejected'))
                                                    FROM
                                                        Cause_Investigation__c
                                                    WHERE
                                                        Id IN : IdOfExtensionRequestInApprovalStatus
        ];
        for(Cause_Investigation__c loopCauseInvestigation : causeIvest){
            if(!Helper.isEmpty(loopCauseInvestigation.Extension_Requests__r)){
                Cause_Investigation__c transactionObjectCI = newExtensionRequests.get(loopCauseInvestigation.Id);
                transactionObjectCI.addError(Label.ERROR_EXTENSION_REQUEST_OPENED);
            }
        }
    }
}