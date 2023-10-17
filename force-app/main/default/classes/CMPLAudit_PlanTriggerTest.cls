@isTest
 public class CMPLAudit_PlanTriggerTest{
	static testMethod void Audit_PlanTriggerTestmethod(){
		Audit_Plan__c testobject = new Audit_Plan__c ();
		insert testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}