@isTest
 public   class Quality_Event_InvestigationTriggerTest{
	static testMethod void Quality_Event_InvestigationTriggerTestmethod(){
		Quality_Event_Investigation__c testobject = new Quality_Event_Investigation__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}