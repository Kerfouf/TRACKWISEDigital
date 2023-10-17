@isTest
 public without sharing class CMPLCause_Catef769031b8b6730aTriggerTest {
	@IsTest
	private static void testAutoGeneratedTrigger() {
		CMPL123.RecoveryUtil.enableFeatureSuppressPackageTriggersForTest();
		Cause_Investigation__c ci = new Cause_Investigation__c();
		insert ci;

		Cause_Category__c cc = new Cause_Category__c();
		cc.Cause_Investigation__c = ci.Id;
		insert cc;

		cc.Comments__c = 'Tests';
		update cc;

		delete cc;
		CMPL123.RecoveryUtil.disableFeatureSuppressPackageTriggersForTest();
	}
}