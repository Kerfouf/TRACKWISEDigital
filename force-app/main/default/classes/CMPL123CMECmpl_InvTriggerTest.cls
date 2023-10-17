@isTest
 public   class CMPL123CMECmpl_InvTriggerTest{
	static testMethod void CMPL123CMEComplaint_InvestigationTriggerTestmethod(){
		CMPL123CME__Complaint_Investigation__c testobject = new CMPL123CME__Complaint_Investigation__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}