/*
File Name: AssessmentHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functioanlity on Assessment object.
*/
public with sharing class AssessmentHandler {

    /*
    Input: List<CMPL123CME__Questionnaire__c>
    Output: Void
    Description: public method, which is referenced in the assessment audit trigger, 
                 used to prevent assessment deletion on closed complaints. 
    */
    public static void preventAssessmentDelete(List<CMPL123CME__Questionnaire__c> existingAssessments){
        Set<ID> compliantIdSet = New Set<ID>();
        for(CMPL123CME__Questionnaire__c questionnaire: existingAssessments) 
            compliantIdSet.add(questionnaire.cmpl123cme__complaint__c);
       
        if(compliantIdSet.size() > 0){
            Map<Id, CMPL123CME__Complaint__c> complaintsMap = new Map<Id, CMPL123CME__Complaint__c>([Select Id From CMPL123CME__Complaint__c 
                                                                                                     Where CMPL123CME__CMPL123_WF_Status__c = 'Closed - Completed' and Id IN: compliantIdSet]);
            
            for(CMPL123CME__Questionnaire__c questionnaire : existingAssessments) 
                if(questionnaire.cmpl123cme__complaint__c != null && complaintsMap.get(questionnaire.cmpl123cme__complaint__c) != null)
                questionnaire.addError(System.Label.ASSESSMENTS_DELETE_ERROR_MESSAGE);
        }
    }
    

}