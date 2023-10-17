public with sharing class closeAuditsScheduleAfterQualityAudit {
    public static void closeAuditsScheduleAfterQualityAudit(Map<Id, BMX_Audits_Schedule__c> OldauditSchedules, Map<Id, BMX_Audits_Schedule__c> NewAuditSchedules) {
        Id internalRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
            Id externeRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
          Set<Id> auditScheduleSIdSets = new Set<Id>();
    
        // Iterate through new audit schedules
        for (BMX_Audits_Schedule__c auditsSch : NewAuditSchedules.values()) {
            // Get the corresponding old audit schedule
            BMX_Audits_Schedule__c OldauditSchedules = OldauditSchedules.get(auditsSch.Id);
    
            // Check new audit has Implementation status
            if (OldauditSchedules != null &&
            OldauditSchedules.CMPL123_WF_Status__c != 'Audit Schedule Executed' &&
                audits.CMPL123_WF_Status__c == 'Audit Schedule Executed') {
                auditScheduleIdSets.add(auditsSch.Id);
            }
        }
    
        // Query BMX_Quality_Audit__c records related to the Audit Schedules
        List<BMX_Quality_Audit__c> listQualityAuditsInParent = [SELECT Id, CMPL123_WF_Status__c, Audit_Schedule__c 
                                                         FROM BMX_Quality_Audit__c 
                                                         WHERE Audit_Schedule__c IN :auditScheduleIdSets];
    
        List<Id> listIdScheduleTrue = new List<Id>();
    
        // Check if listAuditsInParent is not empty
        if (!listQualityAuditsInParent.isEmpty()) {
            for (BMX_Quality_Audit__c qAudits : listQualityAuditsInParent) {
                // Check if the status meets certain criteria
                if (!(
                qAudits.CMPL123_WF_Status__c == Label.Status_Closed_Cancelled ||
                qAudits.CMPL123_WF_Status__c == Label.Status_Closed_Done)) {
                    listIdScheduleTrue.add(qAudits.Audit_Schedule__c);
                }
            }
        }
    
        if (listIdScheduleTrue.isEmpty()) {
            List<BMX_Audits_Schedule__c> listScheduleToUpdate = new List<BMX_Audits_Schedule__c>();
            // Iterate through the audit schedules to update
            for (BMX_Audits_Schedule__c audScheduleToUpdate : NewAuditSchedules.values()) {
                if (audScheduleToUpdate.RecordTypeId == internalRecordTypeId &&
                audScheduleToUpdate.CMPL123_WF_Status__c == 'Audit Schedule Executed') {
                    audScheduleToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE_INTER; 
                } else if (audScheduleToUpdate.RecordTypeId == externeRecordTypeId &&
                audScheduleToUpdate.CMPL123_WF_Status__c == 'Audit Schedule Executed') {
                    audScheduleToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE_EXTER;
                }
                //listSchedToUpdate.add(audSchToUpdate);
            }
}