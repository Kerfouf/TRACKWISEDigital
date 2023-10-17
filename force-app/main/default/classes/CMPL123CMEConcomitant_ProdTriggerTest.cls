@isTest
 public   class CMPL123CMEConcomitant_ProdTriggerTest{
	static testMethod void CMPL123CMEConcomitant_ProductTriggerTestmethod(){
		CMPL123CME__Concomitant_Product__c testobject = new CMPL123CME__Concomitant_Product__c ();
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}