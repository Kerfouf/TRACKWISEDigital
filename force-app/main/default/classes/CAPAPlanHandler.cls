/*
File Name: CAPAPlanHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functioanlity on CAPA plan object.
*/
public with sharing class CAPAPlanHandler{

    /*
    Input: List<Task>, String
    Output: Void
    Description: public method, which is referenced in the CAPA plan audit trigger.
    Requirement: JIRA 819 , User should not be able to Send Action Plan for Approval without any Tasks
    */
    public static void preventSubmitforReviewCAPAActionPlan(Map<Id,CAPA_Plan__c> CAPAPlanNewMap, Map<Id,CAPA_Plan__c> CAPAPlanOldMap){
        
        Map<String,Integer> CAPAPlanWithChildCount = new Map<String,Integer>();
        for(CAPA_Plan__c cap : [Select Id, Name, (Select Id From Tasks) From CAPA_Plan__c Where Id IN :CAPAPlanNewMap.keyset()])
            CAPAPlanWithChildCount.put(cap.Id, cap.Tasks.size());
        
        for(CAPA_Plan__c cap : CAPAPlanNewMap.values())
            if(cap.CMPL123_WF_Action__c == 'Submit for Review - CAPA Action Plan' && cap.CMPL123_WF_Action__c != CAPAPlanOldMap.get(cap.Id).CMPL123_WF_Action__c && CAPAPlanWithChildCount.get(cap.Id) != null && CAPAPlanWithChildCount.get(cap.Id) == 0)   
                cap.addError(Label.CAPA_CANNOT_SUBMIT_FOR_REVIEW_NO_TASKS_ACTION_PLAN);
                }
    }