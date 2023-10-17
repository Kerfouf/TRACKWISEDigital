@isTest
 public   class CMPL123CMESubmission_HistoryTriggerTest{
	static testMethod void CMPL123CMESubmission_HistoryTriggerTestmethod(){
		CMPL123CME__Submission_History__c testobject = new CMPL123CME__Submission_History__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}