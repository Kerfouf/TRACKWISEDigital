public with sharing class ExtensionRequestHelper {
    
    private static List<String> LIST_OF_FIELDS_TO_CHECK = new List<String>{'CAPA_Number__c', 'CAPA_Action_Number__c', 'Cause_Investigation_Number__c','Audit_Finding__c', 'Correction_Number__c', 'QMS_Task_Number__c' ,'Quality_Event_Number__c'};
    
    public static void checkOnlyOneParent(List<Extension_Request__c> newElements){
        Helper.checkOnlyOneParent(newElements, LIST_OF_FIELDS_TO_CHECK, Label.QUALITY_EVENT_ONLY_ONE_PARENT_AND_MANDATORY);        
    }
}