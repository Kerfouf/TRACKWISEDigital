/*
File Name: TaskPreventionHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functioanlity on SFDC standard task object.
*/
public with sharing class TaskPreventionHandler{
    
    /*
    Input: List<Task>, String
    Output: Void
    Description: public method, which is referenced in the assessment audit trigger.
    Requirement: JIRA 264 - D, User should not be able to add or delete any Tasks after Action Plan is approved
  */
    public static void preventTaskAddAndDelete(List<Task> tasks, String operationType){
        //To get the key prefix of the issue object
        String keyPrefix = Change_Control_Plan__c.sObjectType.getDescribe().getKeyPrefix();
        Set<String> changeControlIds = new Set<String>();
        
        for(Task t : tasks)
            if(t.WhatId != null && String.valueOf(t.WhatId).substring(0,3) == keyPrefix)
                changeControlIds.add(t.WhatId);
        
        Set<String> changeControlPlanApprovedIds = new Set<String>();
        for(Change_Control_Plan__c cp : [Select Id From Change_Control_Plan__c Where Id IN:changeControlIds AND Change_Control_Plan_Approved__c = true])
            changeControlPlanApprovedIds.add(cp.Id);
            
        for(Task t : tasks){
            if(changeControlPlanApprovedIds.contains(t.WhatId)){
                if(operationType == 'insert')
                    t.addError('No task(s) can be added after action plan approval');
                else if(operationType == 'delete')
                    t.addError('No task(s) can be deleted after action plan approval');
            }
        }
    }  
}