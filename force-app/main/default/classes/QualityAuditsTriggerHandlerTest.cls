@isTest
public class QualityAuditsTriggerHandlerTest {
    @TestSetup
    static void makeData() {
        // Create record types for test data
        RecordType internalRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'BMX_Audits_Schedule__c' AND DeveloperName = 'Internal' LIMIT 1];
        RecordType externalRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'BMX_Audits_Schedule__c' AND DeveloperName = 'External' LIMIT 1];
        
        BMX_Audits_Schedule__c auditSchedule1 = new BMX_Audits_Schedule__c(
            RecordTypeId = internalRecordType.Id,
            Title__c = 'Test Internal',
            CMPL123_WF_Status__c = 'Initiated'
       );
        insert auditSchedule1;
               
        BMX_Audits_Schedule__c auditSchedule2 = new BMX_Audits_Schedule__c(
            RecordTypeId = externalRecordType.Id,
            Title__c = 'Test External',
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert auditSchedule2;
        auditSchedule2.CMPL123_WF_Status__c = Label.Status_Audit_Schedule_Implementation;
        update auditSchedule2;
               
        BMX_Quality_Audit__c qualityAudit1 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule1.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit1;
         qualityAudit1 .CMPL123_WF_Status__c = Label.Status_Closed_Done;

         update qualityAudit1;

        BMX_Quality_Audit__c qualityAudit2 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule2.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit2;
        qualityAudit2 .CMPL123_WF_Status__c = Label.Status_Closed_Cancelled;

         update qualityAudit2;
    
    BMX_Audits_Schedule__c auditSchedule3 = new BMX_Audits_Schedule__c(
            RecordTypeId = internalRecordType.Id,
            Title__c = 'Test Internal2',
            CMPL123_WF_Status__c = 'Initiated'
       );
        insert auditSchedule3;
    auditSchedule3.CMPL123_WF_Status__c = Label.Status_Audit_Schedule_Implementation;
        update auditSchedule3;
               
        BMX_Quality_Audit__c qualityAudit3 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule3.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit3;
         qualityAudit3.CMPL123_WF_Action__c = Label.Send_back_to_Initiation;

         update qualityAudit3;
        BMX_Audits_Schedule__c auditSchedule4 = new BMX_Audits_Schedule__c(
            RecordTypeId = internalRecordType.Id,
            Title__c = 'Test External2',
            CMPL123_WF_Status__c = 'Initiated'
       );
        insert auditSchedule4;
    auditSchedule3.CMPL123_WF_Status__c = Label.Status_Audit_Schedule_Implementation;
        update auditSchedule4;
               
        BMX_Quality_Audit__c qualityAudit4 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule4.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit4;
         qualityAudit4.CMPL123_WF_Action__c = Label.Send_back_to_Initiation;

         update qualityAudit4;
    }
     @isTest
    static void testAuditActionChange() {
        // Retrieve the created records
        List<BMX_Audits_Schedule__c> auditSchedules = [SELECT Id FROM BMX_Audits_Schedule__c];
        BMX_Quality_Audit__c qualityAudit1 = [SELECT Id, CMPL123_WF_Action__c FROM BMX_Quality_Audit__c WHERE Audit_Schedule__c = :auditSchedules[0].Id LIMIT 1];
        BMX_Quality_Audit__c qualityAudit2 = [SELECT Id, CMPL123_WF_Action__c FROM BMX_Quality_Audit__c WHERE Audit_Schedule__c = :auditSchedules[1].Id LIMIT 1];

        // Update audit actions
        qualityAudit1.CMPL123_WF_Action__c = Label.Send_back_to_Initiation;
        update qualityAudit1;
        
        qualityAudit2.CMPL123_WF_Action__c = 'Send to Audit Preparation';
        update qualityAudit2;

        // Call the method to be tested
        Test.startTest();
        QualityAuditsTriggerHandler.moveAuditSchedule(new Set<Id>{auditSchedules[0].Id});
        QualityAuditsTriggerHandler.moveAuditSchedule(new Set<Id>{auditSchedules[1].Id});
        Test.stopTest();
    }

    

}