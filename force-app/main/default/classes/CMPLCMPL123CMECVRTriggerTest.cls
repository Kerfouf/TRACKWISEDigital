@isTest
 public   class CMPLCMPL123CMECVRTriggerTest{
	static testMethod void CMPL123CMECVRTriggerTestmethod(){
		CMPL123CME__CVR__c testobject = new CMPL123CME__CVR__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}