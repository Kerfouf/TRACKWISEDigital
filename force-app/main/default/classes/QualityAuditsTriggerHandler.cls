public with sharing class QualityAuditsTriggerHandler {
    
    public static final String TASK_VALUE_INTERNAL = 'ReviseAuditScheduleInternal';
    public static final String TASK_VALUE_EXTERNAL = 'ReviseAuditScheduleExternal';
    
    public static void qualityAuditActionChange(Map<Id, BMX_Quality_Audit__c> oldQualityAudit, Map<Id, BMX_Quality_Audit__c> newQualityAudit) {        
        
        Set<Id> setIdQAuditSch = new Set<Id>();
        for (BMX_Quality_Audit__c qAud : newQualityAudit.values()) {
            if (oldQualityAudit.get(qAud.Id).CMPL123_WF_Action__c != 'Send Back to Initiation' && qAud.CMPL123_WF_Action__c == 'Send Back to Initiation'
                //&& /*.CMPL123_WF_Status__c == 'Initiated'
               ) {
                   setIdQAuditSch.add(qAud.Audit_Schedule__c);
               }
        }
        System.debug('setIdQAuditSch : ' + setIdQAuditSch);
        moveAuditSchedule(setIdQAuditSch);
        notificationApprovalCheck(oldQualityAudit,newQualityAudit);//
    }
    
    public static void moveAuditSchedule(Set<Id> IdSetQAudit_Schedule) {
        Map<Id, List<BMX_Quality_Audit__c>> mapAuditScheIdToListQAudit = new Map<Id, List<BMX_Quality_Audit__c>>();
        Map<Id, List<BMX_Quality_Audit__c>> mapIdToListQAuditTrue = new Map<Id, List<BMX_Quality_Audit__c>>();
        List<Id> listIdScheduleTrue = new List<Id>();
        List<BMX_Audits_Schedule__c> listSchedToUpdate = new List<BMX_Audits_Schedule__c>();
        
        List<BMX_Audits_Schedule__c> listParentQAudit = [SELECT Id, RecordType.DeveloperName, CMPL123Task_Key_Value__c, CMPL123_WF_Status__c,Revision__c
                                                         FROM BMX_Audits_Schedule__c 
                                                         WHERE Id IN :IdSetQAudit_Schedule
                                                        ];
        
        /* List<BMX_Quality_Audit__c> listAuditsInParent = [SELECT Id, Audit_Schedule__c, RecordType.DeveloperName, CMPL123_WF_Action__c, CMPL123_WF_Status__c, CMPL123Task_Key_Value__c
FROM BMX_Quality_Audit__c
WHERE Audit_Schedule__c IN :listParentQAudit];

/* for (BMX_Quality_Audit__c qAudit : listAuditsInParent) {
if (!mapAuditScheIdToListQAudit.containsKey(qAudit.Audit_Schedule__c)) {
mapAuditScheIdToListQAudit.put(qAudit.Audit_Schedule__c, new List<BMX_Quality_Audit__c>());
}
mapAuditScheIdToListQAudit.get(qAudit.Audit_Schedule__c).add(qAudit);
}

System.debug('mapAuditScheIdToListQAudit : ' + mapAuditScheIdToListQAudit);

if (!mapAuditScheIdToListQAudit.isEmpty()) {
for (Id auditScheId : mapAuditScheIdToListQAudit.keySet()) {
for (BMX_Quality_Audit__c qAud : mapAuditScheIdToListQAudit.get(auditScheId)) {
if (qAud.CMPL123_WF_Action__c == Label.Send_back_to_Initiation) {
listIdScheduleTrue.add(auditScheId);
}
}
}
}*/
        
        if (listParentQAudit.size() > 0) {
            System.debug('IN IF IdSchedTrue');
            for (BMX_Audits_Schedule__c audSch : listParentQAudit) {
                // if (audSch != null) {{
                if (audSch.RecordType.DeveloperName == Label.Internal_Record_Type && audSch.CMPL123_WF_Status__c == 'Audit Schedule Implementation' ) {
                    audSch.CMPL123Task_Key_Value__c = TASK_VALUE_INTERNAL;
                    audSch.Revision__c +=1;
                    System.debug('IN IF INternal');
                } else if (audSch.RecordType.DeveloperName == Label.External_Record_Type && audSch.CMPL123_WF_Status__c == 'Audit Schedule Implementation' ) {
                    audSch.CMPL123Task_Key_Value__c = TASK_VALUE_EXTERNAL;
                    audSch.Revision__c +=1;
                    System.debug('IN IF EXternal');
                }
                listSchedToUpdate.add(audSch);
            }
        }
        
        
        System.debug('listSchedToUpdate : ' + listSchedToUpdate);
        
        if (listSchedToUpdate.size() > 0) {
            
            update listSchedToUpdate;
            System.debug('AFTER UPDATE ');
        }
    }
    
    public static void notificationApprovalCheck(Map<Id, BMX_Quality_Audit__c> oldQualityAudit, Map<Id, BMX_Quality_Audit__c> newQualityAudit){
        Map<Id,BMX_Quality_Audit__c> auditSchduleMap = new Map<Id,BMX_Quality_Audit__c>();
        for (BMX_Quality_Audit__c qAud : newQualityAudit.values()) {
            if (qAud.CMPL123_WF_Action__c == 'Notification Approval') {
                if(qAud.Scope__c== 'Distributor' 
                   &&(String.Isblank(qAud.Distributor_Number__c) 
                   || String.Isblank(qAud.Distributor_Name__c)
                   || String.Isblank(qAud.Distributor_Category__c)
                   || String.Isblank(qAud.Distributor_Type__c))){
                       qAud.AddError('Distributor Number,Distributor Name,Distributor Category and Distributor Type must be filled');
                   }else if(qAud.Audit_Method__c !='Mail in Audit' && qAud.AgendaItem__c < 1){
                       qAud.AddError('Quality Audit must have at least one Agenda Item');
                   }else if(qAud.Distribution_List__c < 1){
                       qAud.AddError('Quality Audit must have at least one Distribution List');
                   }
                //auditSchduleMap.put(qAud.Id,qAud);
            }
        }        
    }
    public static void handleAfterUpdate(Map<Id, BMX_Quality_Audit__c> oldQualityAudit, Map<Id, BMX_Quality_Audit__c> newQualityAudit){
        Map<Id,BMX_Quality_Audit__c> qualityAuditMap = new Map<Id,BMX_Quality_Audit__c>();
        //updates audit finding
        for(BMX_Quality_Audit__c audit : newQualityAudit.values()){
            if(audit.CMPL123_WF_Status__c != oldQualityAudit.get(audit.Id).CMPL123_WF_Status__c && (audit.CMPL123_WF_Status__c =='Pending Audit Report Approval' || audit.CMPL123_WF_Status__c =='Report Approved - Pending Action Plan Definition')){
                qualityAuditMap.put(audit.Id,audit);
            }
        }
        if(qualityAuditMap.size()>0){
            updateRelatedAuditFindings(qualityAuditMap);
        }
        
    }
    public static void updateRelatedAuditFindings(Map<Id, BMX_Quality_Audit__c> currentQualityAudit){
        List<Audit_Finding__c> auditFindingToUpdate = new List<Audit_Finding__c>();
        List<Audit_Finding__c> relatedAuditFindings = [SELECT Id,Parent_Audit__c,Parent_Audit__r.CMPL123_WF_Action__c,CMPL123_WF_Status__c,
                                                       CMPL123_WF_Action__c,CMPL123Task_Key_Value__c,recordtype.DeveloperName,
                                                       Parent_Audit__r.CMPL123_WF_Status__c
                                                       FROM Audit_Finding__c 
                                                       WHERE Parent_Audit__c IN:currentQualityAudit.Keyset()];
        for(Audit_Finding__c auditFinding : relatedAuditFindings){
            if(auditFinding.Parent_Audit__r.CMPL123_WF_Status__c =='Pending Audit Report Approval'){
                if(auditFinding.recordtype.DeveloperName == 'Internal'){
                    auditFinding.CMPL123Task_Key_Value__c = 'MIAFTPPA';
                }else if(auditFinding.recordtype.DeveloperName == 'External'){
                    auditFinding.CMPL123Task_Key_Value__c = 'MEAFTPPA';
                }
                auditFindingToUpdate.add(auditFinding);
            }else if(auditFinding.Parent_Audit__r.CMPL123_WF_Status__c =='Report Approved - Pending Action Plan Definition'){
                if(auditFinding.recordtype.DeveloperName == 'Internal'){
                    auditFinding.CMPL123Task_Key_Value__c = 'MIAFFPPATAR';
                }else if(auditFinding.recordtype.DeveloperName == 'External'){
                    auditFinding.CMPL123Task_Key_Value__c = 'MEAFFPPATAR';
                }
                auditFindingToUpdate.add(auditFinding);
            }
        }
        update auditFindingToUpdate;
    }
}