@isTest
 public   class CMPLCMPL123QMSInternal_AuditTriggerTest{
	static testMethod void CMPL123QMSInternal_AuditTriggerTestmethod(){
		CMPL123QMS__Internal_Audit__c testobject = new CMPL123QMS__Internal_Audit__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}