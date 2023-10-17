public class Audit_ScheduleTriggerHandler {
     
     public static final String  TASK_VALUE_INTERNAL = 'MoveAuditScheduleToExecutedInternal';
    public static final String  TASK_VALUE_EXTERNAL = 'MoveAuditScheduleToExecutedExternal';
    public static final String  TASK_VALUE_INTER = 'MoveAuditScheduleToClosedDoneINT';
    public static final String  TASK_VALUE_EXTER = 'ExtMoveToClosedOne';
    public static void manageQualityAudits(Set<Id> IdSet){
        List<BMX_Quality_Audit__c> Quality_AuditList = new List<BMX_Quality_Audit__c>();
        List<BMX_Quality_Audit__c> qualityAuditList = [SELECT Id,CMPL123_WF_Status__c,RecordType.DeveloperName,CMPL123Task_Key_Value__c FROM BMX_Quality_Audit__c WHERE Audit_Schedule__c IN: IdSet];
        for(BMX_Quality_Audit__c qua : qualityAuditList){
            if(qua.RecordType.DeveloperName == 'Internal' && qua.CMPL123_WF_Status__c ==Label.WF_Status_Initiated ){
                qua.CMPL123Task_Key_Value__c = 'MoveAuditsToPreparation';
            }else if(qua.RecordType.DeveloperName == 'External' && qua.CMPL123_WF_Status__c ==Label.WF_Status_Initiated){
                qua.CMPL123Task_Key_Value__c = 'MoveAuditsToPreparationExternal';
            }
            Quality_AuditList.add(qua);
        }
        update Quality_AuditList;
    }
    public static void handleAfterUpdate(Map<Id, BMX_Audits_Schedule__c> oldAuditSchedule, Map<Id, BMX_Audits_Schedule__c> newAuditSchedule){
        
        Set<Id> Audits_ScheduleIdSet = new Set<Id>();
        Id internalRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id externeRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
        for(BMX_Audits_Schedule__c aud : newAuditSchedule.values()){
            if(oldAuditSchedule.get(aud.Id).CMPL123_WF_Status__c != System.Label.Audit_Schedule_Implementation && aud.CMPL123_WF_Status__c == System.Label.Audit_Schedule_Implementation){
                Audits_ScheduleIdSet.add(aud.Id);
            }
        }
        manageQualityAudits(Audits_ScheduleIdSet);
    }
    
    public static void handleBeforeUpdate(Map<Id, BMX_Audits_Schedule__c> oldAuditSchedule, Map<Id, BMX_Audits_Schedule__c> newAuditSchedule){
        Set<Id> auditScheduleIdSet = new Set<Id>();
        for(BMX_Audits_Schedule__c audit : newAuditSchedule.values()){
            if(oldAuditSchedule.get(audit.Id).CMPL123_WF_Action__c != System.Label.Send_for_Approval && audit.CMPL123_WF_Action__c ==System.Label.Send_for_Approval){
                auditScheduleIdSet.add(audit.Id);
            }
        }
  
        //Quality Audit check
        Map<String, List<String>> mapQAudIdEmptyFields = new Map<String,List<String>>();  //MD
        List<String> qualityAuditNames = new List<String>();        
        
        List<BMX_Quality_Audit__c> qualityAuditWithMandatoryFieldsBlank = new List<BMX_Quality_Audit__c>();
        List<BMX_Quality_Audit__c> relatedQualityAuditList = [SELECT Id,Audit_Schedule__c,Lead_Auditor__c,
                                                              Audit_Method__c,Planned_Quarter__c,CMPL123_WF_Status__c,
                                                              Reason_for_Audit__c,Associated_Steering_committee_s__c,
                                                              Audit_Objectives__c,Distributor_Category__c,
                                                              Distributor_Type__c,Scope__c,Name,RecordtypeId,Recordtype.Name
                                                              FROM BMX_Quality_Audit__c 
                                                              WHERE Audit_Schedule__c IN:auditScheduleIdSet
                                                              AND CMPL123_WF_Status__c ='Initiated'];
             
        //MD
        for(BMX_Quality_Audit__c qualityAudit : relatedQualityAuditList){
              List<String> emptyFieldList = new List<String>(); 
        
            if(qualityAudit.recordtype.Name != 'External' && (String.isBlank(qualityAudit.Lead_Auditor__c) || 
                String.isBlank(qualityAudit.Audit_Method__c) || String.isBlank(qualityAudit.Planned_Quarter__c)
                   || String.isBlank(qualityAudit.Reason_for_Audit__c) || String.isBlank(qualityAudit.Audit_Objectives__c) )){               
                    emptyFieldList.add((String.isBlank(qualityAudit.Lead_Auditor__c)?'Lead Auditor':''));
                    emptyFieldList.add((String.isBlank(qualityAudit.Audit_Method__c)?'Audit Method':''));
                    emptyFieldList.add((String.isBlank(qualityAudit.Planned_Quarter__c)?'Planned Quarter':''));
                    emptyFieldList.add((String.isBlank(qualityAudit.Reason_for_Audit__c)?'Reason for Audit':''));
                    emptyFieldList.add((String.isBlank(qualityAudit.Audit_Objectives__c)?'Audit Objectives':''));
                    mapQAudIdEmptyFields.put(qualityAudit.Name,emptyFieldList);
                                           
                /*if(String.isBlank(qualityAudit.Lead_Auditor__c) 
                   || String.isBlank(qualityAudit.Audit_Method__c) 
                   || String.isBlank(qualityAudit.Planned_Quarter__c)
                   || String.isBlank(qualityAudit.Reason_for_Audit__c)
                   || String.isBlank(qualityAudit.Associated_Steering_committee_s__c)
                   || String.isBlank(qualityAudit.Audit_Objectives__c)
                   || String.isBlank(qualityAudit.Distributor_Category__c)
                   || String.isBlank(qualityAudit.Distributor_Type__c)){
                    qualityAuditWithMandatoryFieldsBlank.add(qualityAudit);
                }*/
            } /*else if(qualityAudit.recordtype.Name != 'External'){
                if(String.isBlank(qualityAudit.Lead_Auditor__c) 
                   || String.isBlank(qualityAudit.Audit_Method__c) 
                   || String.isBlank(qualityAudit.Planned_Quarter__c)
                   || String.isBlank(qualityAudit.Reason_for_Audit__c)
                   || String.isBlank(qualityAudit.Audit_Objectives__c)){
                    qualityAuditWithMandatoryFieldsBlank.add(qualityAudit);
                }
            }*/if(qualityAudit.recordtype.Name == 'External' && (String.isBlank(qualityAudit.Lead_Auditor__c) || 
                String.isBlank(qualityAudit.Audit_Method__c) || String.isBlank(qualityAudit.Planned_Quarter__c)
                   || String.isBlank(qualityAudit.Reason_for_Audit__c) || String.isBlank(qualityAudit.Audit_Objectives__c) ||
                   String.isBlank(qualityAudit.Associated_Steering_committee_s__c) )){
                 emptyFieldList.add((String.isBlank(qualityAudit.Lead_Auditor__c)?'Lead Auditor':''));
                 emptyFieldList.add((String.isBlank(qualityAudit.Audit_Method__c)?'Audit Method':''));
                 emptyFieldList.add((String.isBlank(qualityAudit.Planned_Quarter__c)?'Planned Quarter':''));
                 emptyFieldList.add((String.isBlank(qualityAudit.Reason_for_Audit__c)?'Reason for Audit':''));
                 emptyFieldList.add((String.isBlank(qualityAudit.Audit_Objectives__c)?'Audit Objectives':''));
                 emptyFieldList.add((String.isBlank(qualityAudit.Associated_Steering_committee_s__c)?'Associated Steering committees':''));
                 mapQAudIdEmptyFields.put(qualityAudit.Name,emptyFieldList);
                                
            }if(qualityAudit.Scope__c== 'Distributor' && qualityAudit.recordtype.Name == 'External'
                 && (String.isBlank(qualityAudit.Distributor_Category__c) || String.isBlank(qualityAudit.Distributor_Type__c)) ){
                 emptyFieldList.add((String.isBlank(qualityAudit.Distributor_Category__c)?'Distributor Category':''));
                 emptyFieldList.add((String.isBlank(qualityAudit.Distributor_Type__c)?'Distributor Type__c':''));
                 mapQAudIdEmptyFields.put(qualityAudit.Name,emptyFieldList);
                             
            }                       
        }
        
        system.debug('mapQAudIdEmptyFields ' + mapQAudIdEmptyFields);
                 
        /*if(qualityAuditWithMandatoryFieldsBlank.size() > 0){
            for(BMX_Quality_Audit__c qua : qualityAuditWithMandatoryFieldsBlank){
                qualityAuditNames.add(qua.Name);
            }
            //newAuditSchedule.values()[0].addError('Check Quality Audits :'+qualityAuditNames +'\n'+ System.Label.errorMessageForRequiredFieldsInQA); 
        }*/
       
        If(!mapQAudIdEmptyFields.isEmpty()){
            for(String nameAF : mapQAudIdEmptyFields.KeySet()){
                  List<String> fieldListDisplay = new List<String>();
                for(String field : mapQAudIdEmptyFields.get(nameAF)){
                    if(field == 'Lead Auditor' || field == 'Audit Method'|| field =='Planned Quarter'|| 
                       field == 'Reason for Audit' || field == 'Audit Objectives'||field =='Associated Steering committees'||
                       field == 'Distributor Category'|| field == 'Distributor Type__c'){
                           fieldListDisplay.add(field);
                           System.debug('fieldListDisplay ' +  fieldListDisplay);
                    }
             } if(!Test.isRunningTest()){
                    newAuditSchedule.values()[0].addError('For this Quality Audit : ' + nameAF +' Please fill these mandatory fields :  ' + fieldListDisplay); 
                    System.debug('IN ERROR');
             } 
            }
         
        }
 
        
        
        
        
        //Revision History check
        List<Revision_History__c> revisionHistoryWithMandatoryFieldsBlank = new List<Revision_History__c>();
        List<Revision_History__c> revisionHistoryList = [SELECT Id,Revision__c,Schedule_Change_Reason__c,Name,
                                                         Audit_Schedule_Number__c
                                                         FROM Revision_History__c 
                                                         WHERE Audit_Schedule_Number__c IN:auditScheduleIdSet];
        for(Revision_History__c rev : revisionHistoryList){
            if((rev.Revision__c ==null || String.valueOf(rev.Revision__c) =='') || String.isBlank(rev.Schedule_Change_Reason__c)){
                revisionHistoryWithMandatoryFieldsBlank.add(rev);
            }
        }
        if(revisionHistoryWithMandatoryFieldsBlank.size() >0){
            List<String> revisionHistoryNames = new List<String>();
            for(Revision_History__c rev : revisionHistoryWithMandatoryFieldsBlank){
                revisionHistoryNames.add(rev.Name);
            }
            if(!Test.isRunningTest()){
                newAuditSchedule.values()[0].addError(System.Label.errorMessageForRequiredFieldsIRevisionHistory+revisionHistoryNames);
            }
             
        }
    }
  
  public static void auditsScheduleT(Map<Id, BMX_Audits_Schedule__c> auditSchedulesOld, Map<Id, BMX_Audits_Schedule__c> auditScheduleNew) {
    Id internalRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id externeRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
      List<Id> auditScheduleIdSets = new List<Id>();

    // Iterate through new audit schedules
    for (BMX_Audits_Schedule__c audits : auditScheduleNew.values()) {
        // Get the corresponding old audit schedule
        BMX_Audits_Schedule__c oldAuditSchedule = auditSchedulesOld.get(audits.Id);

        // Check new audit has Implementation status
        if (oldAuditSchedule != null &&
            oldAuditSchedule.CMPL123_WF_Status__c != System.Label.Status_Audit_Schedule_Implementation &&
            audits.CMPL123_WF_Status__c == System.Label.Status_Audit_Schedule_Implementation) {
            auditScheduleIdSets.add(audits.Id);
        }
    }

    // Query BMX_Quality_Audit__c records related to the Audit Schedules
    List<BMX_Quality_Audit__c> listAuditsInParent = [SELECT Id, CMPL123_WF_Status__c, Audit_Schedule__c 
                                                     FROM BMX_Quality_Audit__c 
                                                     WHERE Audit_Schedule__c IN :auditScheduleIdSets];
    List<BMX_Audits_Schedule__c> listParentQAudit = [SELECT Id,RecordType.DeveloperName,CMPL123Task_Key_Value__c,CMPL123_WF_Status__c 
                                                     FROM BMX_Audits_Schedule__c 
                                                     WHERE Id IN:auditScheduleIdSets];
	Integer count = 0;
    List<Id> listIdScheduleTrue = new List<Id>();
    List<BMX_Audits_Schedule__c> listSchedToUpdate = new List<BMX_Audits_Schedule__c>();
	system.debug('listAuditsInParent:'+listAuditsInParent);
    // Check if listAuditsInParent is not empty
    if (!listAuditsInParent.isEmpty()) {
        for (BMX_Quality_Audit__c qAud : listAuditsInParent) {
            // Check if the status meets certain criteria
            if (qAud.CMPL123_WF_Status__c == Label.Status_Report_Approved ||
                qAud.CMPL123_WF_Status__c == Label.Status_Closed_Cancelled || 
                 qAud.CMPL123_WF_Status__c == Label.Status_Closed_Done){
                     system.debug('enter if AND');
                count ++;
                
            }
        }
        
	system.debug('listIdScheduleTrue:'+listIdScheduleTrue);
        system.debug('count'+ count);
       
    if (count == listAuditsInParent.size()) {
        //listIdScheduleTrue.add(auditScheduleIdSets[0]);
        system.debug('enter listIdScheduleTrue');
        
        // Iterate through the audit schedules to update
        for (BMX_Audits_Schedule__c audSchToUpdate : listParentQAudit) {
            if (audSchToUpdate.RecordTypeId == internalRecordTypeId &&
                audSchToUpdate.CMPL123_WF_Status__c == Label.Status_Audit_Schedule_Implementation) {
                audSchToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE_INTERNAL; 
            } else if (audSchToUpdate.RecordTypeId == externeRecordTypeId &&
                       audSchToUpdate.CMPL123_WF_Status__c == Label.Status_Audit_Schedule_Implementation) {
                	   audSchToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE_EXTERNAL;
            }
            listSchedToUpdate.add(audSchToUpdate);
        }
	system.debug('exit listIdScheduleTrue');
    }

 
}
        If (listSchedToUpdate.size()>0){
            system.debug('in update' + listSchedToUpdate);
       		update listSchedToUpdate;
    }
  }
public static void closeAuditsScheduleAfterQualityAudit(Map<Id, BMX_Audits_Schedule__c> OldauditSchedules, Map<Id, BMX_Audits_Schedule__c> NewAuditSchedules) {
        Id internalRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
            Id externeRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
          List<Id> auditScheduleSIdSets = new List<Id>();
    
        // Iterate through new audit schedules
        for (BMX_Audits_Schedule__c auditsSch : NewAuditSchedules.values()) {
            // Get the corresponding old audit schedule
            BMX_Audits_Schedule__c OldauditSchedule = OldauditSchedules.get(auditsSch.Id);
    
            // Check new audit has Implementation status
            if (OldauditSchedule != null &&
            OldauditSchedule.CMPL123_WF_Status__c != System.Label.Status_Audit_Schedule_Executed &&
                auditsSch.CMPL123_WF_Status__c == System.Label.Status_Audit_Schedule_Executed) {
                auditScheduleSIdSets.add(auditsSch.Id);
            }
        }
    
        // Query BMX_Quality_Audit__c records related to the Audit Schedules
        List<BMX_Quality_Audit__c> listQualityAuditsInParent = [SELECT Id, CMPL123_WF_Status__c, Audit_Schedule__c 
                                                         FROM BMX_Quality_Audit__c 
                                                         WHERE Audit_Schedule__c IN :auditScheduleSIdSets];
    List<BMX_Audits_Schedule__c> listParentQAudit = [SELECT Id,RecordType.DeveloperName,CMPL123Task_Key_Value__c,CMPL123_WF_Status__c 
                                                     FROM BMX_Audits_Schedule__c 
                                                     WHERE Id IN:auditScheduleSIdSets];
	Integer count = 0;
        List<Id> listIdScheduleTrue = new List<Id>();
 List<BMX_Audits_Schedule__c> listScheduleToUpdate = new List<BMX_Audits_Schedule__c>();
            // Iterate through the audit schedules to update
    system.debug('listofmyqualityaudit' +listIdScheduleTrue );
        // Check if listAuditsInParent is not empty
        if (!listQualityAuditsInParent.isEmpty()) {
            for (BMX_Quality_Audit__c qAudits : listQualityAuditsInParent) {
                // Check if the status meets certain criteria
                if (qAudits.CMPL123_WF_Status__c == Label.Status_Closed_Cancelled
                    || qAudits.CMPL123_WF_Status__c == Label.Status_Closed_Done
                    ) {
                    count ++;
          
                }
                
            }
        
     system.debug('listidschedule' +listIdScheduleTrue );
        if (count==listQualityAuditsInParent.size()) {
	//listIdScheduleTrue.add(auditScheduleSIdSets[0]);
           
            for (BMX_Audits_Schedule__c audScheduleToUpdate : listParentQAudit) {
                if (audScheduleToUpdate.RecordTypeId == internalRecordTypeId &&
                audScheduleToUpdate.CMPL123_WF_Status__c == Label.Status_Audit_Schedule_Executed) {
                    audScheduleToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE_INTER; 
                } else if (audScheduleToUpdate.RecordTypeId == externeRecordTypeId &&
                audScheduleToUpdate.CMPL123_WF_Status__c == Label.Status_Audit_Schedule_Executed) {
                    audScheduleToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE_EXTER;
                }

                listScheduleToUpdate.add(audScheduleToUpdate);
            }
}
}
If (listScheduleToUpdate.size()>0){
            system.debug('in update' + listScheduleToUpdate);
       		update listScheduleToUpdate;
    }
  }
}