@isTest
public class QualityAuditsHelperTest {
        
    // Create record types for test data
        RecordType internalRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'BMX_Audits_Schedule__c' AND DeveloperName = 'Internal' LIMIT 1];
        RecordType externalRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'BMX_Audits_Schedule__c' AND DeveloperName = 'External' LIMIT 1];
          
    @isTest
    static void testAuditStatusChange() {
        // Create test data
         RecordType internalRecordType = [SELECT Id FROM RecordType WHERE SObjectType = 'BMX_Audits_Schedule__c' AND DeveloperName = 'Internal' LIMIT 1];
         BMX_Audits_Schedule__c auditSchedule1 = new BMX_Audits_Schedule__c(
            RecordTypeId = internalRecordType.Id,
            Title__c = 'Test Internal',
            CMPL123_WF_Status__c = 'Audit Schedule Executed'
       );
        insert auditSchedule1;
        
        auditSchedule1.CMPL123_WF_Status__c = Label.Status_Audit_Schedule_Implementation;
        update auditSchedule1;
        
       BMX_Quality_Audit__c qualityAudit1 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule1.Id,
            CMPL123_WF_Status__c = Label.Status_Closed_Cancelled
        );
        insert qualityAudit1;
        BMX_Quality_Audit__c qualityAudit2 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule1.Id,
            CMPL123_WF_Status__c = 'Initiated'
        );
        insert qualityAudit2;

        Test.startTest();
        qualityAudit2.CMPL123_WF_Status__c = Label.Status_Closed_Cancelled;
        update qualityAudit2;
        QualityAuditsMoveAuditsScheduleHelper.moveAuditSchedule(new Set<Id>{qualityAudit2.Audit_Schedule__c});
        Test.stopTest();

	   
    }
    
	 @isTest
    static void testCheckFindings() {
         
        Profile admin = [select id from profile where name='System Administrator'];
        
        User usr = new User(alias = 'utest', emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = admin.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', email='utest@email.com',
                          username='utest21@email.com',TWD_Role__c='Audit Coordinator'); 
        insert usr; 
        
        System.runAs(usr){
        Id externalIdRecordType = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get(Label.External_Record_Type).getRecordTypeId();
        Id internalIdRecordType = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get(Label.Internal_Record_Type).getRecordTypeId();
        RecordType internalRecordTypeAS = [SELECT Id FROM RecordType WHERE SObjectType = 'BMX_Audits_Schedule__c' AND DeveloperName = 'Internal' LIMIT 1];
        RecordType internalRecordTypeAF = [SELECT Id FROM RecordType WHERE SObjectType = 'Audit_Finding__c' AND DeveloperName = 'Internal' LIMIT 1];
        
       List<BMX_Audits_Schedule__c> listSchedule = new List<BMX_Audits_Schedule__c>();
       List<BMX_Quality_Audit__c> listQAudit = new List<BMX_Quality_Audit__c>();
       List<Audit_Finding__c> listFindings = new List<Audit_Finding__c>();
       Set<Id> setAuditId = new Set<Id>();
         
          BMX_Audits_Schedule__c auditSchedule = new BMX_Audits_Schedule__c(
            RecordTypeId = internalRecordTypeAS.Id,
            Title__c = 'Test Internal Check',
            CMPL123_WF_Status__c = 'Initiated'
        );
        listSchedule.add(auditSchedule);
        insert listSchedule;
               
       BMX_Quality_Audit__c qualityAuditCheck = new BMX_Quality_Audit__c(
            RecordTypeId = internalIdRecordType,
            Audit_Schedule__c = listSchedule[0].Id,
            Lead_Auditor__c = usr.Id,
            CMPL123_WF_Status__c = 'Initiated',
            CMPL123_WF_Action__c = 'Notification Approval'
        );
       listQAudit.add(qualityAuditCheck);
       insert listQAudit;
       qualityAuditCheck.CMPL123_WF_Status__c = 'Audit Report Preparation';
       qualityAuditCheck.CMPL123_WF_Action__c = Label.WF_Action_Report_Ready_Approval;
	   update listQAudit;  
        
       Audit_Finding__c auditFinding = new Audit_Finding__c();
       auditFinding.RecordTypeId = internalRecordTypeAF.Id;
       auditFinding.Parent_Audit__c = listQAudit[0].id;
       auditFinding.Title__c = 'Test Finding Check';
       auditFinding.Finding_Type__c = 'Non-Conformity';
       auditFinding.Nonconformity_Grading__c = '1';  
       auditFinding.Nonconformity_Type__c = 'Major';
       auditFinding.Assigned_To__c = usr.Id; 
       listFindings.add(auditFinding);
      insert listFindings;
      
      For(BMX_Quality_Audit__c qaud : listQAudit){
           setAuditId.add(qaud.Id);
         }     
            
     QualityAuditCheckFindings.checkFindings(setAuditId, listQAudit);
            
        }       
        
    }
}