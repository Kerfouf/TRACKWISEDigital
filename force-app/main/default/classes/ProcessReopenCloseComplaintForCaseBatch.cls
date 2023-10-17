/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : ProcessReopenCloseComplaintForCaseBatch
* @Why   : Batch class for making the updates to the complaints while reopening/Closing of the Complaints
* @When  : 19-APR-2019
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        19-APR-2019        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

public class ProcessReopenCloseComplaintForCaseBatch implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

	// Declaring the lists and maps to keep all the complaints which needs update while reopening/Closing of the Complaints
    List<CMPL123CME__Complaint__c> cmpReopenList = new List<CMPL123CME__Complaint__c>();
    List<CMPL123CME__Complaint__c> cmpReopenUpdList = new List<CMPL123CME__Complaint__c>();
    List<CMPL123CME__Complaint__c> cmplntAutoCloseList = new List<CMPL123CME__Complaint__c>();
    Map<Id, CMPL123CME__Complaint__c> cmplntAutoCloseMap = new Map<Id, CMPL123CME__Complaint__c>();
    Map<Id, CMPL123CME__Complaint__c> cmpReopenMap = new Map<Id, CMPL123CME__Complaint__c>();
    Map<Id, CMPL123CME__Complaint__c> cmpReopenUpdMap = new Map<Id, CMPL123CME__Complaint__c>();
    List<CMPL123CME__Complaint__c> totCmpList = new List<CMPL123CME__Complaint__c>();
    Set<Id> totCmpIdSet = new Set<Id>();
    Datetime lastExecuted;

	// Initializing the lists and maps with the complaints 
    public ProcessReopenCloseComplaintForCaseBatch(List<CMPL123CME__Complaint__c> cmpReopenList, List<CMPL123CME__Complaint__c> cmpReopenUpdList , List<CMPL123CME__Complaint__c> cmplntAutoCloseList, Datetime lastExecuted) {
        
        system.debug('==cmpReopenList=='+cmpReopenList);
        system.debug('==cmpReopenUpdList=='+cmpReopenUpdList);
        system.debug('==cmplntAutoCloseList=='+cmplntAutoCloseList);
        
        this.cmpReopenList = cmpReopenList;
        this.cmpReopenUpdList = cmpReopenUpdList;
        this.cmplntAutoCloseList = cmplntAutoCloseList;
        this.lastExecuted = lastExecuted;
        cmpReopenMap.putAll(cmpReopenList);
        cmpReopenUpdMap.putAll(cmpReopenUpdList);
        cmplntAutoCloseMap.putAll(cmplntAutoCloseList);
        totCmpList.addAll(cmpReopenList);
        totCmpList.addAll(cmpReopenUpdList);
        totCmpList.addAll(cmplntAutoCloseList);
        
        

        for(CMPL123CME__Complaint__c cmp : totCmpList) {
            totCmpIdSet.add(cmp.Id);
        }
    }

	// Quering the Complaints
    public Database.QueryLocator start(Database.BatchableContext bc) { 
        return Database.getQueryLocator('SELECT Id FROM CMPL123CME__Complaint__c WHERE Id IN: totCmpIdSet');
    }

    public void execute(Database.BatchableContext bc, List<CMPL123CME__Complaint__c> compList) {

        List<CMPL123CME__Complaint__c> cmpUpdList = new List<CMPL123CME__Complaint__c>();
        List<Error_Log__c> errList = new List<Error_Log__c>();
        List<Database.SaveResult> srList = new List<Database.SaveResult>();

        if(compList.size() == 1 && compList[0].Id <> null) {
            Id cmpId = compList[0].Id;

			//Reopening the complaints
            if(cmpReopenMap.get(cmpId) <> null) {
                CMPL123CME__Complaint__c cmp = new CMPL123CME__Complaint__c();
                cmp = cmpReopenMap.get(cmpId);
                Database.SaveResult sr1 = Database.update(cmp, false);
                srList.add(sr1);
                cmpUpdList.add(cmp);
            }
            
			// Making the updates after reopening the complaints
            if(cmpReopenUpdMap.get(cmpId) <> null) {
                CMPL123CME__Complaint__c cmp = new CMPL123CME__Complaint__c();
                cmp = cmpReopenUpdMap.get(cmpId);
                cmp.CMPL123Task_Key_Value__c = '';
                system.debug('==cmp.CMPL123Task_Key_Value__c=='+cmp.CMPL123Task_Key_Value__c);
                cmp.CMPL123CME__CMPL123_WF_Status__c = 'Opened';
                Database.SaveResult sr2 = Database.update(cmp, false);
                system.debug('==cmp.CMPL123Task_Key_Value__c=='+cmp.CMPL123Task_Key_Value__c);
                srList.add(sr2);
                cmpUpdList.add(cmp);
            }
            
			// Autoclosing the complaints
            if(cmplntAutoCloseMap.get(cmpId) <> null) {
                CMPL123CME__Complaint__c cmp = new CMPL123CME__Complaint__c();
                cmp = cmplntAutoCloseMap.get(cmpId);
                cmp.CMPL123Task_Key_Value__c = 'Autoclose_Complaint';
                cmp.CMPL123CME__CMPL123_WF_Status__c = 'Closed';
                Database.SaveResult sr3 = Database.update(cmp, false);
                srList.add(sr3);
                cmpUpdList.add(cmp);
            }
            errList = Utils_CreateComplaintForCaseBatch.returnSaveFailureLogs(srList, cmpUpdList, 'processReopenCloseComplaintForCaseBatch','CMPL123CME__Complaint__c');
        }
        if(!errList.isEmpty()) {
            Database.Insert(errList, false);
        }
    }

    public void finish(Database.BatchableContext bc){
        Boolean chained = false;
        //if([SELECT COUNT() FROM CaseComment__x WHERE LastModifiedDate__c >: System.now().addHours(-24) AND ParentId__c != null] > 0){
        if(!Test.isRunningTest()){
		
			// Executing CreateCaseCommentForComplaintBatch batch class
            CreateCaseCommentForComplaintBatch createCaseComment = new CreateCaseCommentForComplaintBatch(!chained, lastExecuted);
            database.executebatch(createCaseComment, 50);
        }
        
    }  
}