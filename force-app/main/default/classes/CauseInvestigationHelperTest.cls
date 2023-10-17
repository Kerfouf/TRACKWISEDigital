@isTest
public with sharing class CauseInvestigationHelperTest {
    @isTest
    public static void nonpassing(){
        Cause_Investigation__c causeInvest = new Cause_Investigation__c();
        causeInvest.CMPL123_WF_Status__c = 'Not In Approval';
        insert causeInvest;

        Extension_Request__c linkedER = new Extension_Request__c();
        linkedER.CMPL123_WF_Status__c = 'NOT_CLOSED';
        linkedER.Cause_Investigation_Number__c = causeInvest.Id;
        insert linkedER;
        
        causeInvest.CMPL123_WF_Status__c = 'Approval';
        Boolean thrownAnException = false;
        try {
            update causeInvest;
        }catch(Exception e){
            thrownAnException = true;
        }
        System.assertEquals(true, thrownAnException ,'The move of the record should have been forbiden');
        
        
    }
}