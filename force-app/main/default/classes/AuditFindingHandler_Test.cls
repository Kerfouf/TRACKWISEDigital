/*
File Name  : AuditFindingHandler_Test
Author     : Sparta Systems
Description: public method, which is referenced in the audit finding audit trigger, 
used to prevent deletion on closed complaints.
Requirement: JIRA 303-A, Audit findings cannot be added or removed or edited after audit has been approved
*/

@IsTest public class AuditFindingHandler_Test {
    @IsTest public static void testAuditFindingHandler() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest21@email.com');
        insert u; 
        
        //Account Object
        Account acc = new Account();
        acc.Name = 'Aayur';
        insert acc;
        
        
        //Audit Object
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CMPL123QMS__Internal_Audit__c; 
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo
            = cfrSchema.getRecordTypeInfosByName(); 
        //Now to get the recordTypeId we will have to use a method getRecordTypeId. 
        
        Id rtId = RecordTypeInfo.get('Internal').getRecordTypeId();
        
        CMPL123QMS__Internal_Audit__c auditObj = new CMPL123QMS__Internal_Audit__c();
        
        auditObj.recordtypeid = rtId;
        auditObj.Audit_Title__c = 'abc';
        auditObj.Audit_Type__c ='GMP';
        auditObj.CMPL123QMS__Manager_of_Area_to_be_Audited__c = acc.id;
        insert auditObj;
        
        //AuditFinding Object
        Audit_Finding__c auditFindingObj = new Audit_Finding__c();
        auditFindingObj.Audit__c = auditObj.id;
        auditFindingObj.Due_Date__c = Date.today() +1;
        insert auditFindingObj;
        delete auditFindingObj;
    }
    @IsTest public static void testAuditFindingHandler2() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest76@email.com');
        insert u; 
        
        //Account Object
        Account acc = new Account();
        acc.Name = 'Aayur';
        insert acc;
        
        
        //Audit Object
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CMPL123QMS__Internal_Audit__c; 
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo
            = cfrSchema.getRecordTypeInfosByName(); 
        //Now to get the recordTypeId we will have to use a method getRecordTypeId. 
        
        Id rtId = RecordTypeInfo.get('Internal').getRecordTypeId();
        //Now we can insert Contact Record like 
        CMPL123QMS__Internal_Audit__c auditObj = new CMPL123QMS__Internal_Audit__c();
        
        auditObj.recordtypeid = rtId;
        auditObj.Audit_Title__c = 'abc';
        auditObj.Audit_Type__c ='GMP';
        auditObj.CMPL123QMS__Manager_of_Area_to_be_Audited__c = acc.id;
        insert auditObj;
        
        //AuditFinding Object
        Audit_Finding__c auditFindingObj = new Audit_Finding__c();
        auditFindingObj.Audit__c = auditObj.id;
        auditFindingObj.Due_Date__c = Date.today() +1;
        
        insert auditFindingObj;
        
        auditFindingObj.CMPL123_WF_Status__c = 'Pending Submission';
        
        update auditFindingObj;
        delete auditFindingObj;
        
    }
    @IsTest public static void testAuditFindingHandler3() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest89@email.com');
        insert u; 
        
        //Account Object
        Account acc = new Account();
        acc.Name = 'Aayur';
        insert acc;
        
        
        //Audit Object
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CMPL123QMS__Internal_Audit__c; 
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo
            = cfrSchema.getRecordTypeInfosByName(); 
        //Now to get the recordTypeId we will have to use a method getRecordTypeId. 
        
        Id rtId = RecordTypeInfo.get('Internal').getRecordTypeId();
        //Now we can insert Contact Record like 
        CMPL123QMS__Internal_Audit__c auditObj = new CMPL123QMS__Internal_Audit__c();
        
        auditObj.recordtypeid = rtId;
        auditObj.Audit_Title__c = 'abc';
        auditObj.Audit_Type__c ='GMP';
        auditObj.CMPL123QMS__Manager_of_Area_to_be_Audited__c = acc.id;
        insert auditObj;
        
        //AuditFinding Object
        Audit_Finding__c auditFindingObj = new Audit_Finding__c();
        auditFindingObj.Audit__c = auditObj.id;
        auditFindingObj.Due_Date__c = Date.today() +1;
        
        insert auditFindingObj;
        
        auditFindingObj.CMPL123_WF_Status__c = 'Submit for Quality Review';
        
        update auditFindingObj;
        delete auditFindingObj;
        
    }
    
    @IsTest public static void testAuditFindingHandler4() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest12@email.com');
        insert u; 
        
        //Account Object
        Account acc = new Account();
        acc.Name = 'Aayur';
        insert acc;
        
        
        //Audit Object
        
        
        Schema.DescribeSObjectResult cfrSchema = Schema.SObjectType.CMPL123QMS__Internal_Audit__c; 
        Map<String,Schema.RecordTypeInfo> RecordTypeInfo
            = cfrSchema.getRecordTypeInfosByName(); 
        //Now to get the recordTypeId we will have to use a method getRecordTypeId. 
        
        Id rtId = RecordTypeInfo.get('Internal').getRecordTypeId();
        //Now we can insert Contact Record like 
        CMPL123QMS__Internal_Audit__c auditObj = new CMPL123QMS__Internal_Audit__c();
        
        auditObj.recordtypeid = rtId;
        auditObj.Audit_Title__c = 'abc';
        auditObj.Audit_Type__c ='GMP';
        auditObj.CMPL123QMS__Manager_of_Area_to_be_Audited__c = acc.id;
        insert auditObj;
        
        //AuditFinding Object
        List <Audit_Finding__c> lstAuditFinding = new List<Audit_Finding__c>();
        for(Integer i = 0; i<2 ;i++)
        {
            Audit_Finding__c auditFindingObj = new Audit_Finding__c();
            auditFindingObj.Audit__c = auditObj.id;
            auditFindingObj.Due_Date__c = Date.today() +1;
            insert auditFindingObj;
            auditFindingObj.CMPL123_WF_Status__c = 'Approve';
            update auditFindingObj;
            
            lstAuditFinding.add(auditFindingObj);
            //delete auditFindingObj;
        }
        
        delete lstAuditFinding;
    }
    
    
    
}