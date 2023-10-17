public with sharing class CAPAEffectivenessHandler {

     public static void CAPApreventSubmitforReview(Map<Id,CAPA_Effectiveness_Check__c> CAPAEffecheckNewMap, Map<Id,CAPA_Effectiveness_Check__c> CAPAEffecheckOldMap){
        
        Map<String,Integer> CAPAEffecheckWithChildCount = new Map<String,Integer>();
        for(CAPA_Effectiveness_Check__c CEC : [Select Id, Name, (Select Id From Tasks) From CAPA_Effectiveness_Check__c Where Id IN :CAPAEffecheckNewMap.keyset()])
            CAPAEffecheckWithChildCount.put(CEC.Id, CEC.Tasks.size());
        
        for(CAPA_Effectiveness_Check__c CEC: CAPAEffecheckNewMap.values())
            if(CEC.CMPL123_WF_Action__c == 'Submit for Review' && CEC.CMPL123_WF_Action__c != CAPAEffecheckOldMap.get(CEC.Id).CMPL123_WF_Action__c && CAPAEffecheckWithChildCount.get(CEC.Id) != null && CAPAEffecheckWithChildCount.get(CEC.Id) == 0)   
                CEC.addError(Label.CAPA_CANNOT_SUBMIT_EFFECTIVENESS_CHECK_NO_TASKS);

}
}