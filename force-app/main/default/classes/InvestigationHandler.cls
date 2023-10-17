/*
File Name: InvestigationHandler
Author: Sparta Systems
Description: public class which is used to handle all the custom functioanlity on investigation object. 
*/
public with sharing class InvestigationHandler{
    
    /*
    Input: List<CMPL123CME__Investigation__c>
    Output: Void
    Description: public method, which is referenced in the investigation audit trigger, 
                 used to prevent investigation deletion on closed complaints. 
  
    public static void preventInvestigationDelete(List<CMPL123CME__Investigation__c> existingInvestigations){
        Set<ID> compliantIdSet = New Set<ID>();
        for(CMPL123CME__Investigation__c investigation : existingInvestigations) 
           compliantIdSet.add(investigation.cmpl123cme__complaint__c);
        
        if(compliantIdSet.size() > 0){
            Map<Id, CMPL123CME__Complaint__c> complaintsMap = new Map<Id, CMPL123CME__Complaint__c>([Select Id From CMPL123CME__Complaint__c 
                                         Where CMPL123CME__CMPL123_WF_Status__c = 'Closed - Completed' and Id IN: compliantIdSet]);
            
            for(CMPL123CME__Investigation__c investigation : existingInvestigations) 
                if(investigation.CMPL123CME__Complaint__c != null && complaintsMap.get(investigation.CMPL123CME__Complaint__c) != null)
                    investigation.addError('You cannot delete an investigation.');
        }
    }  */
}