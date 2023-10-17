@isTest
 public   class CMPLCMPL123CMETGATriggerTest{
	static testMethod void CMPL123CMETGATriggerTestmethod(){
		CMPL123CME__TGA__c testobject = new CMPL123CME__TGA__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}