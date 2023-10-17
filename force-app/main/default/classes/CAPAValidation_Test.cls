@isTest
public class CAPAValidation_Test {
    
    public Static testMethod void capaValidationTriggerTest(){ 
        
        CMPL123QMS__CAPA__c capaRec = new CMPL123QMS__CAPA__c();
        capaRec.CMPL123_WF_Status__c = 'Pending Approval - CAPA Action Plan';
        insert capaRec;
        update capaRec;
        
        CMPL123QMS__CAPA__c capaRec1 = new CMPL123QMS__CAPA__c();
        capaRec1.CMPL123_WF_Status__c = 'Completed - Done';
        insert capaRec1;
        update capaRec1;
        
        CMPL123QMS__CAPA__c capaRec2 = new CMPL123QMS__CAPA__c();
        capaRec1.CMPL123_WF_Status__c = 'In Planning - CAPA';
        insert capaRec2;
        update capaRec2;
        
    }

}