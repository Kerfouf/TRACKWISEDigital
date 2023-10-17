public with sharing class AddendumHelper {
    //test sfdx deploy
    //test git diff
    private static List<String> LIST_OF_FIELDS_TO_CHECK = new List<String>{'Audit_Finding__c','BMX_Audits_Schedule__c','BMX_Quality_Audit__c','Change_Request__c','QMS_Task__c','Risk_File_Review__c','Correction__c','CAPA_Action__c','CAPA__c','Cause_Investigation__c','Quality_Event__c'};
    
    public static void checkOnlyOneParent(List<Addendum__c> newElements){
        Helper.checkOnlyOneParent(newElements, LIST_OF_FIELDS_TO_CHECK, Label.ADDENDUM_EVENT_ONLY_ONE_PARENT_AND_MANDATORY);
    }
}