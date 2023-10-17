@isTest
public class Audit_ScheduleTriggerHandlerTest {
    @TestSetup
    static void makeData(){
         Profile p = [select id from profile where name='BMX TWD User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest21@email.com',TWD_Role__c='Audit Coordinator');
       insert u;
        
        Id internalRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id externeRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();
        
        Id qualityAuditInternalRecordTypeId = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id qualityAuditexterneRecordTypeId = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();

        BMX_Audits_Schedule__c Audits_Schedule = new BMX_Audits_Schedule__c();     
        Audits_Schedule.RecordTypeId = internalRecordTypeId;
        Audits_Schedule.Title__c = 'TEst';
        //Audits_Schedule.Origination__c = 'TEst';
        Audits_Schedule.Year__c = '2022';
        //Audits_Schedule.Scope__c = 'TEst';
        Audits_Schedule.CMPL123_WF_Status__c = 'Initiated';
        Audits_Schedule.Scope__c = 'Local';
        insert Audits_Schedule;
       
        /*
        BMX_Audits_Schedule__c Audits_Schedule2 = new BMX_Audits_Schedule__c();     
        Audits_Schedule2.RecordTypeId = externeRecordTypeId;
        Audits_Schedule2.Title__c = 'TEst';
        //Audits_Schedule2.Origination__c = 'TEst';
        Audits_Schedule2.Year__c = '2022';
        //Audits_Schedule2.Scope__c = 'TEst';
        Audits_Schedule.CMPL123_WF_Status__c = 'test';
        Audits_Schedule.Scope__c = 'Distributor';
        Insert Audits_Schedule2;
		*/
         BMX_Audits_Schedule__c auditSchedule3 = new BMX_Audits_Schedule__c(
            RecordTypeId = externeRecordTypeId,
            Title__c = 'Test External',
            Scope__c = 'Distributor',
            CMPL123_WF_Status__c = 'Audit Schedule Definition'
             
       );
        insert auditSchedule3;
        
        
		BMX_Quality_Audit__c qualityAudit = new BMX_Quality_Audit__c();
        qualityAudit.RecordTypeId = qualityAuditInternalRecordTypeId;
        qualityAudit.Title__c = 'test';
        qualityAudit.Year__c = '2022';
        qualityAudit.Already_Audited__c = 'No';
        qualityAudit.Audit_Schedule__c = Audits_Schedule.Id;
        insert qualityAudit;
        
        BMX_Quality_Audit__c qualityAudit2 = new BMX_Quality_Audit__c();
        qualityAudit2.RecordTypeId = qualityAuditexterneRecordTypeId;
        qualityAudit2.Title__c = 'test';
        qualityAudit2.Year__c = '2022';
        qualityAudit2.Already_Audited__c = 'No';
        qualityAudit2.Audit_Schedule__c = Audits_Schedule.Id;
        insert qualityAudit2;
        
         BMX_Quality_Audit__c qualityAudit3 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule3.Id,
            RecordTypeId = qualityAuditexterneRecordTypeId,
            CMPL123_WF_Status__c = 'Initiated',
            Lead_Auditor__c = u.Id,
            Reason_for_Audit__c = 'Other',
            Audit_Objectives__c = 'Audit'
            
        );
        insert qualityAudit3;   
        
        Revision_History__c revHis = new Revision_History__c();
        revHis.Audit_Schedule_Number__c =  auditSchedule3.Id;
        revHis.Revision__c = null;
        revHis.Schedule_Change_Reason__c = 'Creation of the schedule';
        Insert revHis;
        
        
  		/*
        QMS_Task__c task = new QMS_Task__c();
        task.CMPL123_WF_Status__c = 'TEST';
        task.Cause_Investigation__c = Audit_Finding.Id;
        task.Title__c = '';
        insert task;
		*/
    }
    @isTest
    public static void handleAfterUpdate(){
        Map<Id,BMX_Audits_Schedule__c> Audits_ScheduleMap = new Map<Id,BMX_Audits_Schedule__c>([SELECT Id,CMPL123_WF_Status__c,RecordType.DeveloperName FROM BMX_Audits_Schedule__c LIMIT 1]);
        BMX_Audits_Schedule__c audit = Audits_ScheduleMap.values()[0];
        audit.CMPL123_WF_Status__c = 'Audit Schedule Implementation';
        update audit;
        Map<Id,BMX_Audits_Schedule__c> newAuditScheMap = new Map<Id,BMX_Audits_Schedule__c>();
        newAuditScheMap.put(audit.Id, audit);
        Audit_ScheduleTriggerHandler.handleAfterUpdate(Audits_ScheduleMap,newAuditScheMap);
    }
    @isTest
    public static void testhandleBeforeUpdate(){
        Map<Id,BMX_Audits_Schedule__c> Audits_ScheduleMap = new Map<Id,BMX_Audits_Schedule__c>([SELECT Id,CMPL123_WF_Status__c,RecordType.DeveloperName,CMPL123_WF_Action__c,Scope__c FROM BMX_Audits_Schedule__c WHERE CMPL123_WF_Status__c = 'Audit Schedule Definition']);
        BMX_Audits_Schedule__c audit = Audits_ScheduleMap.values()[0];
        System.debug('audit ' + audit);
        audit.CMPL123_WF_Action__c = 'Send for Approval';
        
        Test.StartTest();      
        update audit; 
        Test.StopTest();
        
        //BMX_Audits_Schedule__c audit2 = Audits_ScheduleMap.values()[1];
        //audit2.CMPL123_WF_Action__c = 'Send for Approval';
        //audit2.Scope__c = 'Distributor';
        //update audit2;
		
        Map<Id,BMX_Audits_Schedule__c> newAuditScheMap = new Map<Id,BMX_Audits_Schedule__c>();
        newAuditScheMap.put(audit.Id, audit);
        //newAuditScheMap.put(audit2.Id,audit2);
        Audit_ScheduleTriggerHandler.handleBeforeUpdate(Audits_ScheduleMap,newAuditScheMap);
    }
        @isTest
    public static void auditsScheduleT(){
        Id internalRecordTypeId = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        BMX_Audits_Schedule__c auditSchedule1 = new BMX_Audits_Schedule__c() ;
        auditSchedule1.CMPL123_WF_Status__c = 'Initiated';
        insert auditSchedule1;
       
 			BMX_Quality_Audit__c qualityAudit = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule1.Id,
            CMPL123_WF_Status__c = Label.Status_Report_Approved      
        );
        insert qualityAudit;
        BMX_Audits_Schedule__c auditSchedule2 = new BMX_Audits_Schedule__c() ;
        auditSchedule1.CMPL123_WF_Status__c = 'Initiated';
        insert auditSchedule2;
       
 			BMX_Quality_Audit__c qualityAudit2 = new BMX_Quality_Audit__c(
            Audit_Schedule__c = auditSchedule2.Id,
            CMPL123_WF_Status__c = Label.Status_Closed_Done
            
                
        );
        insert qualityAudit2;
        Test.StartTest();  
        auditSchedule1.CMPL123_WF_Status__c = System.Label.Status_Audit_Schedule_Implementation;
        update auditSchedule1; 
        auditSchedule2.CMPL123_WF_Status__c = System.Label.Status_Audit_Schedule_Executed;
        update auditSchedule2; 
        Test.StopTest();
    
}
    
}