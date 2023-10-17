@isTest
 public without sharing class CMPLIntermedia84a257431435de9TriggerTest {
     
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
     
	@IsTest
	private static void testAutoGeneratedTrigger() {
		/*
		CMPL123.RecoveryUtil.enableFeatureSuppressPackageTriggersForTest();
		CMPL123.AutoGeneratedTriggerTest.DBOPResultsHolder resultsHolder = CMPL123.AutoGeneratedTriggerTest.executeAutoGeneratedTriggerTest('Intermediate_Answer__c',null);

		System.assertNotEquals(null, resultsHolder.getReturnedInsertResult());
		System.assertNotEquals(null, resultsHolder.getReturnedUpdateResult());
		System.assertNotEquals(null, resultsHolder.getReturnedDeleteResult());

		CMPL123.RecoveryUtil.disableFeatureSuppressPackageTriggersForTest();
		*/
        CMPL123CME__Investigation__c inv = [SELECT Id FROM CMPL123CME__Investigation__c LIMIT 1];
        Intermediate_Answer__c intermediateAns = new Intermediate_Answer__c();
        intermediateAns.Related_Investigation__c = inv.Id;
        intermediateAns.Intermediate_Answer__c = 'test';
        Insert intermediateAns;
        
        Test.startTest();
        intermediateAns.Intermediate_Answer__c = 'test1';
        update intermediateAns;
        
        delete intermediateAns;
        Test.stopTest();
        
	}
}