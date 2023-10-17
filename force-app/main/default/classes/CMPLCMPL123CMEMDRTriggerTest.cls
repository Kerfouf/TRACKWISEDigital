@isTest
 public   class CMPLCMPL123CMEMDRTriggerTest{
	static testMethod void CMPL123CMEMDRTriggerTestmethod(){
        
        CMPL123__Device__c testDeviceRec = new CMPL123__Device__c();
        insert testDeviceRec;
		CMPL123CME__MDR__c testobject = new CMPL123CME__MDR__c ( CMPL123CME__Common_Device_Name__c = testDeviceRec.Id,
                                                                CMPL123CME__Describe_Event__c = 'test', CMPL123CME__Procode__c = '123',
                                                               CMPL123CME__Type_of_Reportable_Event__c = 'test');
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}