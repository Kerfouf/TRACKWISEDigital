@isTest
 public without sharing class CMPLImpacted_L034a9abd73a7c8cTriggerTest {
	@IsTest
	private static void testAutoGeneratedTrigger() {
		CMPL123.RecoveryUtil.enableFeatureSuppressPackageTriggersForTest();
		Quality_Event__c qe = new Quality_Event__c();
		insert qe;

		Impacted_Lot_SN__c impactedLot = new Impacted_Lot_SN__c();
		impactedLot.Related_Quality_Event__c = qe.Id;
		insert impactedLot;

		impactedLot.Catalog_Profile_Number__c = 'Test';
		update impactedLot;

		delete impactedLot;
		
		CMPL123.RecoveryUtil.disableFeatureSuppressPackageTriggersForTest();
	}
}