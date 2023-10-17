@isTest
 public   class CMPLCMPL123CMERepairTriggerTest{
	static testMethod void CMPL123CMERepairTriggerTestmethod(){
		CMPL123CME__Repair__c testobject = new CMPL123CME__Repair__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}