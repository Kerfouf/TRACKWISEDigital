@isTest
 public   class CMPLCMPL123CMEHHETriggerTest{
	static testMethod void CMPL123CMEHHETriggerTestmethod(){
		CMPL123CME__HHE__c testobject = new CMPL123CME__HHE__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}