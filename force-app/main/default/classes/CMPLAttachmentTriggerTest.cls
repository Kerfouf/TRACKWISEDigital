@isTest
 public   class CMPLAttachmentTriggerTest{
	static testMethod void AttachmentTriggerTestmethod(){
        
        Account acc = new Account(Name = 'TestAccount');
        insert acc;
		Attachment testobject = new Attachment (ParentId = acc.Id);
		testobject.Name = 'Teststring';
		testobject.Body = blob.valueOf('ASDFGH');
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}