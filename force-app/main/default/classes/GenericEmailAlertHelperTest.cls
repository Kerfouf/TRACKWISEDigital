@isTest
public with sharing class GenericEmailAlertHelperTest {
    @isTest
    public static void test(){
        Correction__c correction = new Correction__c();
        insert correction;

        correction.CMPL123_WF_Action__c = 'Reject';
        update correction;

        correction.CMPL123_WF_Status__c = 'Approval';
        update correction;

        
    }
}