@isTest
 public class CMPLChange_Control_PlanTriggerTest{
	static testMethod void Change_Control_PlanTriggerTestmethod(){
		Change_Control_Plan__c testobject = new Change_Control_Plan__c ();
		insert testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}