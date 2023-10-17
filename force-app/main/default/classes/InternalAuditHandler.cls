/*
File Name: InternalAuditHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functionality on audit finding object. 
*/
public with sharing class InternalAuditHandler{

    /*
    Input: List< CMPL123QMS__Internal_Audit__c >
    Output: Void
    Description: public method, which is referenced in the internal audit audit trigger, 
                 used to prevent closure of audits when associated related audit findings are not yet closed.
    Requirement: Any Audit Findings have to be closed */
    
    public static void preventInternalAuditClosure(List< CMPL123QMS__Internal_Audit__c > internalAudits, Map<Id,CMPL123QMS__Internal_Audit__c > internalAuditMap, Map<Id,CMPL123QMS__Internal_Audit__c > oldInternalAuditMap){
        Set<String> auditsWithPendingFindings = new Set<String>();
        for(CMPL123QMS__Internal_Audit__c internalAudit : [Select Id, Name, (Select Id, CMPL123_WF_Action__c From Audit_Findings__r Where CMPL123_WF_Action__c != 'Close' AND CMPL123_WF_Action__c != 'Cancel Finding') From CMPL123QMS__Internal_Audit__c Where Id IN : internalAuditMap.keySet()]){
            if(internalAudit.Audit_Findings__r.size() > 0)
                auditsWithPendingFindings.add(internalAudit.Id);    
        }
        
        for(CMPL123QMS__Internal_Audit__c internalAudit : internalAudits){
            if(internalAudit.CMPL123_WF_Action__c == 'Approve Audit' && internalAudit.CMPL123_WF_Action__c != oldInternalAuditMap.get(internalAudit.Id).CMPL123_WF_Action__c && auditsWithPendingFindings.contains(internalAudit.Id))
                internalAudit.addError(System.Label.INTERNALAUDIT_PENDING_ERROR_MESSAGE);    
        }
    }
}