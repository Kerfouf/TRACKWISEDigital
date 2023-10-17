/*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : BMX_CreateGlobalAssessmentFrCMPLBatch
* @Why   : Batch class to create Global Assessment records to Complaints which are PRE = Yes
* @When  : 23-May-2019

*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                         23-MAy-2019          Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/
global class BMX_CreateGlobalAssessmentFrCMPLBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    
    public static Boolean auditTriggerCheck = true;
    
    List<CMPL123CME__Complaint__c> cmplRecordsList = new List<CMPL123CME__Complaint__c>();
    
    global BMX_CreateGlobalAssessmentFrCMPLBatch (List<CMPL123CME__Complaint__c> cmplList) {
        this.cmplRecordsList = cmplList;
    }
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        
        Set<Id> cmplIdSet = new Set<Id>();
        for(CMPL123CME__Complaint__c cmpl : cmplRecordsList){
            System.debug('----Inside First for loop----');
            if(cmpl.BMX_PRE__c  == 'Yes' && cmpl.BMX_Assessment_Created__c == False ){
                cmplIdSet.add(cmpl.Id);
            }             
        }
        
        return Database.getQueryLocator('SELECT Id,BMX_PRE__c,BMX_Assessment_Created__c FROM CMPL123CME__Complaint__c WHERE Id In : cmplIdSet ');
    }
    
    global void execute(Database.BatchableContext bc,List<CMPL123CME__Complaint__c> cmplRecordList) {
        
        CMPL123CME__Complaint__c parentCMPLRecord = cmplRecordList.get(0);
        
        CMPL123CME__Questionnaire__c globalAssessment = new CMPL123CME__Questionnaire__c();
        globalAssessment.CMPL123CME__Complaint__c = parentCMPLRecord.Id;
        globalAssessment.CMPL123CME__Key_value__c = 'Assessment';
        
        Id globalRecordTypeId = Schema.SObjectType.CMPL123CME__Questionnaire__c.getRecordTypeInfosByName().get('Global Assessment').getRecordTypeId();
        globalAssessment.RecordTypeId = globalRecordTypeId;
        
        Group rqcQueue = [select Id from Group where Type = 'Queue' AND DeveloperNAME = 'BMX_RQC' Limit 1];
        globalAssessment.OwnerId = rqcQueue.Id;
        
        Database.INSERT(globalAssessment,false);
        
        parentCMPLRecord.BMX_Assessment_Created__c  = True;
        Database.UPDATE(parentCMPLRecord, false);
        System.debug('=====Insert globalAssessment====='+JSON.serialize(globalAssessment));
        System.debug('=====updated cmpl====='+parentCMPLRecord);
    }
    
    global void finish(Database.BatchableContext bc) {
    }
    
}