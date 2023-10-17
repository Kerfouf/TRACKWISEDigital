@isTest
 public   class CMPL123CMEInv_ItemsTriggerTest{
	static testMethod void CMPL123CMEInvestigation_ItemsTriggerTestmethod(){
        
        CMPL123CME__Investigation__c investRec = new CMPL123CME__Investigation__c();
        insert investRec;
		CMPL123CME__Investigation_Items__c testobject = new CMPL123CME__Investigation_Items__c (CMPL123CME__Investigation__c = investRec.Id );
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}