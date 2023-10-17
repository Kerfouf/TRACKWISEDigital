/**
#############################################################################
#  File Name     : InvestigationBusinessHelper_Test
#  Author        : Ikhadallem Lotfi 
#  Description: public class which is used to test the method of InvestigationBusinessHelper class. 


#############################################################################
*/

@isTest
public class InvestigationBusinessHelper_Test {
    
    @testSetup static void setup()
    {
        CMPL123CME__Complaint__c complaint = new CMPL123CME__Complaint__c();
        insert complaint;
        
     	CMPL123CME__Investigation__c investigation = new CMPL123CME__Investigation__c(
        	CMPL123CME__Complaint__c=complaint.id
        );
        insert investigation;

        List<User> users = new List<User>();
        User approver = new User(Username='test@approver.dev',
                                 LastName='approver',
                                 Email='approver@test.com',
                                 Alias='tapprove',
                                 TimeZoneSidKey='Europe/Paris',
                                 LocaleSidKey='fr_FR_EURO',
                                 EmailEncodingKey='ISO-8859-1',
                                 ProfileId='00e0N000000N8fHQAS',
                                 LanguageLocaleKey='en_US',
                                 TWD_Role__c= Label.INVEST_APPROVE_ROLE + ';Change coordinator'
                                );
        users.add(approver);
        
        User nonApprover = new User(Username='test@nonapprover.dev',
                                 LastName='nonapprover',
                                 Email='nonapprover@test.com',
                                 Alias='napprove',
                                 TimeZoneSidKey='Europe/Paris',
                                 LocaleSidKey='fr_FR_EURO',
                                 EmailEncodingKey='ISO-8859-1',
                                 ProfileId='00e0N000000N8fHQAS',
                                 LanguageLocaleKey='en_US',
                                 TWD_Role__c='Change coordinator'
                                );
        users.add(nonApprover);
        insert users;
    }
    
    @isTest
    public static void test_handle(){
        String error = Label.ERROR_APPROVER;
        String investRole = Label.INVEST_APPROVE_ROLE;
        User approver = [Select id from User where username = 'test@approver.dev'];
        User nonapprover = [Select id from User where username = 'test@nonapprover.dev'];
        
        CMPL123CME__Investigation__c investigation = [Select id, 
                                                      BMX_Investigation_Approver__c,
                                                      BMX_Approver_1__c,
                                                      BMX_Approver_2__c,
                                                      BMX_Approver_3__c,
                                                      BMX_Approver_4__c,
                                                      BMX_Expert_Investigator__c,
                                                      OwnerId from CMPL123CME__Investigation__c];

        Test.startTest();

        List<CMPL123CME__Investigation__c> investigations = new List<CMPL123CME__Investigation__c>();
        investigation.BMX_Investigation_Approver__c = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Investigation Approver', investRole})));
        }
        investigations.clear();
        
        investigation.BMX_Approver_1__c = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 1', investRole})));
        }
        investigations.clear();
        
        investigation.BMX_Approver_2__c = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 2', investRole})));
        }
        investigations.clear();
        
        investigation.BMX_Approver_3__c = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 3', investRole})));
        }
        investigations.clear();
        
        investigation.BMX_Approver_4__c = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 4', investRole})));
        }
        investigations.clear();
        
        investigation.BMX_Expert_Investigator__c = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Expert Investigator', investRole})));
        }
        investigations.clear();
        
        investigation.OwnerId = nonApprover.id;
      	investigations.add(investigation);
        try {
			update investigations;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            System.assertEquals(true, e.getMessage().contains(String.format(Label.ERROR_APPROVER, new List<String>{'Owner', investRole})));
        }
        investigations.clear();
        
        investigation = [Select id, 
                         BMX_Investigation_Approver__c,
                         BMX_Approver_1__c,
                         BMX_Approver_2__c,
                         BMX_Approver_3__c,
                         BMX_Approver_4__c,
                         BMX_Expert_Investigator__c,
                         OwnerId from CMPL123CME__Investigation__c];

        investigation.BMX_Investigation_Approver__c = approver.id;
      	investigations.add(investigation);
        update investigations;
        System.assertEquals(investigation.BMX_Investigation_Approver__c, approver.id);

        Test.stopTest();
    }
    
    public class testInvestigationException extends Exception {}
    
    
    @isTest
    public static void test_handleAfterInsertOrUpdateMasterRef()
    {
        Id masterRecordTypeId = Schema.SObjectType.CMPL123CME__Investigation__c.getRecordTypeInfosByName().get('Master').getRecordTypeId();
		CMPL123CME__Complaint__c complaint = new CMPL123CME__Complaint__c();
        insert complaint;
     	CMPL123CME__Investigation__c masterInvestigation = new CMPL123CME__Investigation__c(
        	CMPL123CME__Complaint__c=complaint.id
        );
        insert masterInvestigation;
        CMPL123CME__Investigation__c investigation = [Select id, 
                                                      BMX_Investigation_Approver__c,
                                                      BMX_Approver_1__c,
                                                      BMX_Approver_2__c,
                                                      BMX_Approver_3__c,
                                                      BMX_Approver_4__c,
                                                      BMX_Expert_Investigator__c,
                                                      CMPL123_WF_Status__c,
                                                      OwnerId from CMPL123CME__Investigation__c LIMIT 1];
        
        
        
        Test.startTest();
        Intermediate_Answer__c answer = new Intermediate_Answer__c(
        	Related_Investigation__c = masterInvestigation.id
        );
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='BMX TWD User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
            LocaleSidKey='en_US', ProfileId = p.Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName=uniqueUserName);

        System.runAs(u) {
            investigation.CMPL123_WF_Status__c = 'Pending Approval';
            update investigation;
           
            insert answer;
            CMPL123CME__Investigation__c childInvestigation = new CMPL123CME__Investigation__c(
                CMPL123CME__Complaint__c=complaint.id,
                Master_Investigation__c=masterInvestigation.id
            );
            insert childInvestigation;

            Intermediate_Answer__c lastAnswer = [Select id,Related_Investigation__c from Intermediate_Answer__c where Related_Investigation__c = :childInvestigation.id];

            System.assertNotEquals(lastAnswer, null);
        }
        Test.stopTest();
    }
}