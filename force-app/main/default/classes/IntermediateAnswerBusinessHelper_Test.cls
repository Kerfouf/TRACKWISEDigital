@isTest
public class IntermediateAnswerBusinessHelper_Test {

    @isTest
    public static void test_handle()
    {
        Id masterRecordTypeId = Schema.SObjectType.CMPL123CME__Investigation__c.getRecordTypeInfosByName().get('Master').getRecordTypeId();
		CMPL123CME__Complaint__c complaint = new CMPL123CME__Complaint__c();
        insert complaint;
     	CMPL123CME__Investigation__c masterInvestigation = new CMPL123CME__Investigation__c(
        	CMPL123CME__Complaint__c=complaint.id
        );
        insert masterInvestigation;
        
        CMPL123CME__Investigation__c childInvestigation = new CMPL123CME__Investigation__c(
                CMPL123CME__Complaint__c=complaint.id,
                Master_Investigation__c=masterInvestigation.id
            );
        insert childInvestigation;
        
        Test.startTest();
        Intermediate_Answer__c answer = new Intermediate_Answer__c(
        	Related_Investigation__c = masterInvestigation.id
        );
        Intermediate_Answer__c answer2 = new Intermediate_Answer__c(
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
            insert answer;
            insert answer2;
            answer.Intermediate_Answer__c = 'tesst';
            update answer;
            
            Intermediate_Answer__c lastAnswer = [Select id,Related_Investigation__c,Intermediate_Answer__c from Intermediate_Answer__c where Related_Investigation__c = :childInvestigation.id LIMIT 1];
			List<Intermediate_Answer__c> interMeList = new List<Intermediate_Answer__c>();
            interMeList.add(answer);
            Map<Id,Intermediate_Answer__c> interMeMap2 = new Map<Id,Intermediate_Answer__c>();
            interMeMap2.put(answer.Id, answer2);
            IntermediateAnswerBusinessHelper.afterUpdate(interMeList,interMeMap2);
            System.assertNotEquals(lastAnswer, null);
        }
        Test.stopTest();
    }
}