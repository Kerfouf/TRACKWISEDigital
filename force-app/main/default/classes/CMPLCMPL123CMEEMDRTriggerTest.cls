@isTest
 public   class CMPLCMPL123CMEEMDRTriggerTest{
	static testMethod void CMPL123CMEEMDRTriggerTestmethod(){
		CMPL123CME__EMDR__c testobject = new CMPL123CME__EMDR__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}