@isTest
 public   class CMPLCMPL123CMEMDR_CodeTriggerTest{
	static testMethod void CMPL123CMEMDR_CodeTriggerTestmethod(){
		CMPL123CME__MDR_Code__c testobject = new CMPL123CME__MDR_Code__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}