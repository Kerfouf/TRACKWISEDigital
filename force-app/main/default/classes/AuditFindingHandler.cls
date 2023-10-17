/*
File Name: AuditFindingHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functioanlity on audit finding object. 
*/
public with sharing class AuditFindingHandler{

    /*
    Input: List< Audit_Finding__c >
    Output: Void
    Description: public method, which is referenced in the audit finding audit trigger, 
                 used to prevent deletion on closed complaints.
    Requirement: JIRA 303-A, Audit findings cannot be added or removed or edited after audit has been approved
    */
    public static void preventAuditFindingDelete(List< Audit_Finding__c > existingAuditFindings){
        Set<String> auditIds = new Set<String>();
        
        for(Audit_Finding__c t : existingAuditFindings)
               if(t.Audit__c != null)      
                   auditIds.add(t.Audit__c);
        
        Set<Id> AuditApprovedIdsSet = new Set<Id>();
        
        for(CMPL123QMS__Internal_Audit__c cp : [Select Id From CMPL123QMS__Internal_Audit__c Where Id IN :auditIds and Initial_Approval_Complete__c=true limit 49999])
            AuditApprovedIdsSet.add(cp.Id);
        
        for(Audit_Finding__c t : existingAuditFindings) 
            if(t.Audit__c != null && AuditApprovedIdsSet.contains(t.Audit__c))
                t.addError(System.Label.AUDITFINDING_REMOVE_ERROR_MESSAGE);    
        
    }
    
    public static void handleAfterUpdate(Map<Id,Audit_Finding__c> oldAudit_FindingMap,Map<Id,Audit_Finding__c> newAudit_FindingMap){
        Set<Id> qualityAuditId = new Set<Id>();
        List<Audit_Finding__c> auditFindingToUpdate = new List<Audit_Finding__c>();
        for(Audit_Finding__c auditFind : newAudit_FindingMap.values()){
            if(auditFind.CMPL123_WF_Action__c == 'Finding Action Plan Approved – To be Implemented' || auditFind.CMPL123_WF_Action__c == 'Closed-Cancelled' || auditFind.CMPL123_WF_Action__c == 'Closed-Done'){
                qualityAuditId.add(auditFind.Parent_Audit__c);
            }
        }
        List<BMX_Quality_Audit__c> qualityAuditList = [SELECT Id,CMPL123_WF_Action__c 
                                                       FROM BMX_Quality_Audit__c 
                                                       WHERE Id IN:qualityAuditId 
                                                       AND (CMPL123_WF_Action__c='Report Approved – Pending Action Plan Definition' 
                                                            OR CMPL123_WF_Action__c='Audit Action Plan Approved')];
        //MQATAAPA
        //MQATCD
        if(qualityAuditList.size()>0){
            List<Audit_Finding__c> allChildFindingList = [SELECT Id,Parent_Audit__c,CMPL123_WF_Action__c,Parent_Audit__r.CMPL123_WF_Action__c FROM Audit_Finding__c WHERE Parent_Audit__c IN : qualityAuditId];
            for(Audit_Finding__c find : allChildFindingList){
                if((find.CMPL123_WF_Action__c == 'Finding Action Plan Approved – To be Implemented' || find.CMPL123_WF_Action__c == 'Closed-Cancelled' || find.CMPL123_WF_Action__c == 'Closed-Done') && find.Parent_Audit__r.CMPL123_WF_Action__c =='Report Approved – Pending Action Plan Definition'){
                	find.CMPL123Task_Key_Value__c = 'MQATAAPA';
                    auditFindingToUpdate.add(find);
                }else if((find.CMPL123_WF_Action__c == 'Finding Action Plan Approved – To be Implemented' || find.CMPL123_WF_Action__c == 'Closed-Cancelled' || find.CMPL123_WF_Action__c == 'Closed-Done') && find.Parent_Audit__r.CMPL123_WF_Action__c =='Audit Action Plan Approved'){
                    find.CMPL123Task_Key_Value__c = 'MQATCD';
                    auditFindingToUpdate.add(find);
                }else{
                    find.CMPL123Task_Key_Value__c = '';
                    auditFindingToUpdate.add(find);
                }
            }
            /*
            if(findListNotSatifyCriteria.size()<1){
                List<BMX_Quality_Audit__c> qualityAuditToUpdate = new List<BMX_Quality_Audit__c>();
                
                for(BMX_Quality_Audit__c qua : qualityAuditList){
                    qua.CMPL123_WF_Action__c = 'Audit Action Plan Approved';
                    qualityAuditToUpdate.add(qua);
                }
                update qualityAuditToUpdate;
            }*/
        }
    }
}