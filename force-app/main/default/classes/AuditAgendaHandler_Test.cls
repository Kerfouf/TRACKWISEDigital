@isTest
public class AuditAgendaHandler_Test {
    @isTest
    public static void testAuditAgendaHandler() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest21@email.com',TWD_Role__c='Audit Participant');
        insert u; 
        
        
        Id InternalASched = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id ExterneASched = Schema.SObjectType.BMX_Audits_Schedule__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();       
        Id InternalQAudit = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get('Internal').getRecordTypeId();
        Id ExternalQAudit = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get('External').getRecordTypeId();

       List<BMX_Audits_Schedule__c> listSchedule = new List<BMX_Audits_Schedule__c>();
       List<BMX_Quality_Audit__c> listQAudit = new List<BMX_Quality_Audit__c>();
       List<Audit_Finding__c> listFindings = new List<Audit_Finding__c>();
       List<Audit_Agenda_Item__c> listAgenda = new List<Audit_Agenda_Item__c>();
       List<Audit_Team_Member__c> listAuditTM = new List <Audit_Team_Member__c>();
        
       BMX_Audits_Schedule__c Audits_Schedule = new BMX_Audits_Schedule__c();     
       Audits_Schedule.RecordTypeId = internalASched;
       Audits_Schedule.Title__c = 'TEST';
       Audits_Schedule.CMPL123_WF_Status__c = 'Audit Schedule Definition';
       listSchedule.add(Audits_Schedule);
       insert listSchedule;
        
       BMX_Quality_Audit__c qualityAudit = new BMX_Quality_Audit__c(
        RecordTypeId = InternalQAudit,
        Audit_Schedule__c = listSchedule[0].Id,
        Lead_Auditor__c = u.Id,
        CMPL123_WF_Status__c = 'Initiated'
        );
       listQAudit.add(qualityAudit);
       insert listQAudit;
        
       Audit_Agenda_Item__c auditAgenda = new Audit_Agenda_Item__c(
       Audit__c = qualityAudit.Id,
       StartTime__c = System.Today(),
       EndTime__c  = System.Today().addDays(10),
       Name = 'Meet' 
       );
       listAgenda.add(auditAgenda); 
       insert listAgenda;
        
       Audit_Team_Member__c auditMember = new Audit_Team_Member__c(
       Audit__c = qualityAudit.Id,
       Role__c = 'Auditor',
       Member__c = userinfo.getuserid()
       );
       listAuditTM.add(auditMember);
	   insert listAuditTM;       
    }     

}