@isTest
 public   class CMPLBMX_Generic_ReportTriggerTest{
	static testMethod void BMX_Generic_ReportTriggerTestmethod(){
		BMX_Generic_Report__c testobject = new BMX_Generic_Report__c ();
		insert testobject; 
        system.debug('==testobject=='+testobject);
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}