public with sharing class QualityAuditsHelper {
    public static final String TASK_VALUE_INTERNAL = 'MoveAuditScheduleToClosedDoneINT';
    public static final String TASK_VALUE_EXTERNAL = 'ExtMoveToClosedOne';

    public static void moveAuditSchedule(Set<Id> IdSetQAudit_Schedule) {
        Map<Id,List<BMX_Quality_Audit__c>> mapAuditScheIdToListQAudit = new Map<Id,List<BMX_Quality_Audit__c>>();
        List<Id> schIdNotUp = new List<Id>();
        List<BMX_Audits_Schedule__c> listSchedToUpdate = new List <BMX_Audits_Schedule__c>();

        //Get Parent Audit Schedule From IdSetQAudit_Schedule
        List<BMX_Audits_Schedule__c> listParentQAudit = [SELECT Id,RecordType.DeveloperName,CMPL123Task_Key_Value__c 
                                                         FROM BMX_Audits_Schedule__c 
                                                         WHERE Id IN:IdSetQAudit_Schedule];
        System.debug('listParentQAudit : ' + listParentQAudit);

        List<BMX_Quality_Audit__c> listAuditsInParent = [SELECT Id,Audit_Schedule__c,RecordType.DeveloperName,CMPL123_WF_Status__c,CMPL123Task_Key_Value__c 
                                                         FROM BMX_Quality_Audit__c 
                                                         WHERE Audit_Schedule__c IN:listParentQAudit];
        System.debug('listAuditsInParent : ' + listAuditsInParent);

        //mapAuditScheIdToListQAudit 
        For(BMX_Quality_Audit__c qAudit : listAuditsInParent){
            If(!mapAuditScheIdToListQAudit.containsKey(qAudit.Audit_Schedule__c)){
                mapAuditScheIdToListQAudit.put(qAudit.Audit_Schedule__c,new List<BMX_Quality_Audit__c>());
            }
            mapAuditScheIdToListQAudit.get(qAudit.Audit_Schedule__c).add(qAudit);
        }

        For(Id auditScheId : mapAuditScheIdToListQAudit.keySet()){
            for(BMX_Quality_Audit__c qAud : mapAuditScheIdToListQAudit.get(auditScheId)){
                if(qAud.CMPL123_WF_Status__c != Label.Status_Closed_Cancelled &&
                   qAud.CMPL123_WF_Status__c != Label.Status_Closed_Done) {
                    schIdNotUp.add(qAud.Audit_Schedule__c);
                }
            }
        }
        System.debug('schIdNotUp : ' + schIdNotUp);

        //If(schIdNotUp == null || schIdNotUp.size()==0){ //Convert to Map after Test
            for(BMX_Audits_Schedule__c audSch : listParentQAudit){   //Convert to Map after Test
                if(audSch.RecordType.DeveloperName == Label.Internal_Record_Type){
                    audSch.CMPL123Task_Key_Value__c = TASK_VALUE_INTERNAL;
                } else if(audSch.RecordType.DeveloperName == Label.External_Record_Type){
                    audSch.CMPL123Task_Key_Value__c = TASK_VALUE_EXTERNAL;
                }
                listSchedToUpdate.add(audSch);
            }
      //  }

        If (listSchedToUpdate.size()>0){
            update(listSchedToUpdate);
        }
    }

    public static void qualityAuditStatusChange(Map<Id, BMX_Quality_Audit__c> oldQualityAudit, Map<Id, BMX_Quality_Audit__c> newQualityAudit){
        Set<Id> setIdQAuditSch = new Set<Id>();
        Id internalRecordTypeId = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get(Label.Internal_Record_Type).getRecordTypeId();
        Id externalRecordTypeId = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get(Label.External_Record_Type).getRecordTypeId();
        for(BMX_Quality_Audit__c qAud : newQualityAudit.values()){
            if(
               (oldQualityAudit.get(qAud.Id).CMPL123_WF_Status__c != Label.Status_Closed_Cancelled && qAud.CMPL123_WF_Status__c == Label.Status_Closed_Cancelled) ||
               (oldQualityAudit.get(qAud.Id).CMPL123_WF_Status__c != Label.Status_Closed_Done && qAud.CMPL123_WF_Status__c == Label.Status_Closed_Done)
                             
            ) {
                setIdQAuditSch.add(qAud.Audit_Schedule__c);
            }
        }
        System.debug('setIdQAuditSch : ' + setIdQAuditSch);
        moveAuditSchedule(setIdQAuditSch);
    }
}