@isTest
public class TestHandler {

    @TestSetup
    static void makeData() {
        Id internalRecordType = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id externalRecordType = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();

        BMX_Audits_Schedule__c Audits_Schedule = new BMX_Audits_Schedule__c(
            RecordTypeId = internalRecordType,
            Title__c = 'Test Internal',
            Year__c = '2022',
            CMPL123_WF_Status__c = 'Audit Schedule Implementation'
        );
        insert Audits_Schedule;

        BMX_Audits_Schedule__c Audits_Schedule2 = new BMX_Audits_Schedule__c(
            RecordTypeId = externalRecordType,
            Title__c = 'Test',
            Year__c = '2022',
            CMPL123_WF_Status__c = 'Audit Schedule Definition'
        );
        insert Audits_Schedule2;

        BMX_Quality_Audit__c qualityAudit = new BMX_Quality_Audit__c(
            Audit_Schedule__c = Audits_Schedule.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit;

        BMX_Quality_Audit__c qualityAudit2 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = Audits_Schedule2.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit2;
    }

    @isTest
    static void testHandleAfterUpdate() {
        Test.startTest();
        makeData(); // Create necessary data

        // Retrieve the created records and call the method to be tested
        List<BMX_Audits_Schedule__c> auditSchedules = [SELECT Id FROM BMX_Audits_Schedule__c];
        Map<Id, BMX_Audits_Schedule__c> newAuditSchedule = new Map<Id, BMX_Audits_Schedule__c>([SELECT Id, CMPL123_WF_Status__c FROM BMX_Audits_Schedule__c WHERE Id IN :auditSchedules]);

        // Create a map with the same records as newAuditSchedule for oldAuditSchedule
        Map<Id, BMX_Audits_Schedule__c> oldAuditSchedule = new Map<Id, BMX_Audits_Schedule__c>(newAuditSchedule);

        // Trigger the handleAfterUpdate method
        Audit_ScheduleTriggerHandler.handleAfterUpdate(oldAuditSchedule, newAuditSchedule);
        Test.stopTest();

        // Verify the changes in Quality Audits
        List<BMX_Quality_Audit__c> updatedQualityAudits = [SELECT Id, CMPL123Task_Key_Value__c FROM BMX_Quality_Audit__c];
        System.assertEquals('MoveAuditsToPreparation', updatedQualityAudits[0].CMPL123Task_Key_Value__c);
    }
}