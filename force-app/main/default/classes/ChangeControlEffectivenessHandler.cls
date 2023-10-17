public with sharing class ChangeControlEffectivenessHandler {

     public static void preventSubmitforReview(Map<Id,Change_Control_Effectiveness_Check__c> changeControlEffecheckNewMap, Map<Id,Change_Control_Effectiveness_Check__c> changeControlEffecheckOldMap){
        
        Map<String,Integer> changeControlEffecheckWithChildCount = new Map<String,Integer>();
        for(Change_Control_Effectiveness_Check__c EC : [Select Id, Name, (Select Id From Tasks) From Change_Control_Effectiveness_Check__c Where Id IN :changeControlEffecheckNewMap.keyset()])
            changeControlEffecheckWithChildCount.put(EC.Id, EC.Tasks.size());
        
        for(Change_Control_Effectiveness_Check__c EC: changeControlEffecheckNewMap.values())
            if(EC.CMPL123_WF_Action__c == 'Submit for Review' && EC.CMPL123_WF_Action__c != changeControlEffecheckOldMap.get(EC.Id).CMPL123_WF_Action__c && changeControlEffecheckWithChildCount.get(EC.Id) != null && changeControlEffecheckWithChildCount.get(EC.Id) == 0)   
                EC.addError(Label.CC_CANNOT_SUBMIT_EFFECTIVENESS_CHECK_WITHOUT_TASKS);

}
}