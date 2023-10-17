@isTest
public class IntermediateControllerTest {
    @isTest
    public static void test_handle()
    {
        Test.startTest();
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='BMX TWD User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        CMPL123CME__Complaint__c complaint = new CMPL123CME__Complaint__c();
        insert complaint;
        CMPL123CME__Investigation__c masterInvestigation = new CMPL123CME__Investigation__c(
            CMPL123CME__Complaint__c=complaint.id
        );
        insert masterInvestigation;
        Intermediate_Answer__c answer = new Intermediate_Answer__c();
        answer.Related_Investigation__c = masterInvestigation.id;
        Insert answer;
        PageReference testPage = Page.Intermediate_AnswerWorkflowPanel; 
        Test.setCurrentPage(testPage);
        
        ApexPages.StandardController sc = new  ApexPages.StandardController(answer);     
        IntermediateController ext = new IntermediateController(sc);
		ext.saveInput();        
        Test.stopTest();
    }
}