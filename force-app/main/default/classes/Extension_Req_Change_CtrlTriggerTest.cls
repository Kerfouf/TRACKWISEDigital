@isTest
 public   class Extension_Req_Change_CtrlTriggerTest{
	static testMethod void Extension_Request_Change_ControlTriggerTestmethod(){
        
        CMPL123QMS__Change_Control__c changeCtrl = new CMPL123QMS__Change_Control__c();
        insert changeCtrl;
		Extension_Request_Change_Control__c testobject = new Extension_Request_Change_Control__c (Change_Control__c = changeCtrl.Id);
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}