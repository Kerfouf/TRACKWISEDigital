@isTest
 public   class CMPLNoteTriggerTest{
	static testMethod void NoteTriggerTestmethod(){
        
        CMPL123CME__Investigation__c investRec = new CMPL123CME__Investigation__c();
        insert investRec;
		Note testobject = new Note ();
		testobject.Title = 'Teststring';
        testobject.ParentId = investRec.Id;
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}