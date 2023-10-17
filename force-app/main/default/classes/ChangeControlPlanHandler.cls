/*
File Name: ChangeControlPlanHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functioanlity on change control plan object.
*/
public with sharing class ChangeControlPlanHandler{

    /*
    Input: List<Task>, String
    Output: Void
    Description: public method, which is referenced in the change control plan audit trigger.
    Requirement: JIRA 264 - C, User should not be able to Send Action Plan for Approval without any Tasks
    */
    public static void preventSubmitActionPlan(Map<Id,Change_Control_Plan__c> changeControlPlanNewMap, Map<Id,Change_Control_Plan__c> changeControlPlanOldMap){
        
        Map<String,Integer> changeControlPlanWithChildCount = new Map<String,Integer>();
        for(Change_Control_Plan__c cp : [Select Id, Name, (Select Id From Tasks) From Change_Control_Plan__c Where Id IN :changeControlPlanNewMap.keyset()])
            changeControlPlanWithChildCount.put(cp.Id, cp.Tasks.size());
        
        for(Change_Control_Plan__c cp : changeControlPlanNewMap.values())
            if(cp.CMPL123_WF_Action__c == 'Submit for SME Review' && cp.CMPL123_WF_Action__c != changeControlPlanOldMap.get(cp.Id).CMPL123_WF_Action__c && changeControlPlanWithChildCount.get(cp.Id) != null && changeControlPlanWithChildCount.get(cp.Id) == 0)   
                cp.addError(Label.CC_CANNOT_SUBMIT_ACTION_PLAN_WITHOUT_TASKS);
    } 
    
    
    /*
    Input: List<Task>, String
    Output: Void
    Description: public method, which is referenced in the change control plan audit trigger.
    Requirement: JIRA 264 - B, No change control plans can be deleted after Complete Review Change Control
    */
   public static void preventChangeControlPlanDeletion(Map<Id,Change_Control_Plan__c> changeControlPlanOldMap){
        
        Set<String> changeControlIds = new Set<String>();
        for(Change_Control_Plan__c cp : changeControlPlanOldMap.values())
            changeControlIds.add(cp.Change_Control__c); 
        
        Set<String> changeControlReviewCompletedIds = new Set<String>();
        for(CMPL123QMS__Change_Control__c cc : [Select Id From CMPL123QMS__Change_Control__c Where Id IN :changeControlIds AND Change_Control_Review_Completed__c = true])   
            changeControlReviewCompletedIds.add(cc.Id);
            
        for(Change_Control_Plan__c cp : changeControlPlanOldMap.values())  
            if(changeControlReviewCompletedIds.contains(cp.id) != null)
                cp.addError(Label.CC_CANNOT_DELETE_CC_PLAN_AFTER_COMPLETE_REVIEW);
                
    }

}