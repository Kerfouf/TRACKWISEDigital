/*
* Created on Thurs Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public with sharing class ExternalReferenceInfo {

    private List<Case__x> externalCases;

    private Map<Id, Contact__x> contactExMap = new Map<Id, Contact__x>();
    private Map<Id, Asset__x> assetExMap = new Map<Id, Asset__x>();
    private Map<Id, CodeGroup_c__x> codeGroupExMap = new Map<Id, CodeGroup_c__x>();
    private Map<Id, User__x> userExMap = new Map<Id, User__x>();
    private Map<Id, Entitlement__x> entitlementExMap = new Map<Id, Entitlement__x>();
    private Map<Id, Account__x> accountExMap = new Map<Id, Account__x>();
    private Map<Id, RecordType__x> recordTypeExMap = new Map<Id, RecordType__x>();
    private Map<Id, Product2__x> productExMap = new Map<Id, Product2__x>();
    private Map<Id, Location__x> locationExMap = new Map<Id, Location__x>();
    private Map<Id, Address__x> addressExMap = new Map<Id, Address__x>();

    public ExternalReferenceInfo(List<Case__x> externalCases) {
        this.externalCases = externalCases;
        initialize();
    }

    private void initialize() {
        initializeMapsKeys();
        initializeMapsValues();
    }

    private void initializeMapsKeys() {
        for (Case__x cs : this.externalCases) {
            // populating the sets with the parent Ids of the Case Object
            addKeyToMap(contactExMap, cs.ContactId__c);
            addKeyToMap(assetExMap, cs.AssetId__c);
            addKeyToMap(assetExMap, cs.FunctionalLocation_c__c);
            addKeyToMap(codeGroupExMap, cs.RESULT_c__c);
            addKeyToMap(codeGroupExMap, cs.SAMPLE_c__c);
            addKeyToMap(codeGroupExMap, cs.SatisfactionCode_c__c);
            addKeyToMap(codeGroupExMap, cs.SoftwareCode_c__c);
            addKeyToMap(codeGroupExMap, cs.ActionCode_c__c);
            addKeyToMap(codeGroupExMap, cs.ANALYZE_c__c);
            addKeyToMap(codeGroupExMap, cs.ErrorCode_c__c);
            addKeyToMap(codeGroupExMap, cs.NoInvestJustif_c__c);
            addKeyToMap(userExMap, cs.CreatedById__c);
            addKeyToMap(userExMap, cs.OwnerId__c);
            addKeyToMap(userExMap, cs.L1Owner_c__c);
            addKeyToMap(userExMap, cs.L2Owner_c__c);
            addKeyToMap(userExMap, cs.LastModifiedById__c);
            addKeyToMap(userExMap, cs.Justificationdecision_make_c__c);
            addKeyToMap(entitlementExMap, cs.EntitlementId__c);
            addKeyToMap(accountExMap, cs.AccountId__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Key_Account_Hierarchy_c__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Pricing_Hierarchy_2_c__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Pricing_Hierarchy_c__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Reporting_Hierarchy_c__c);
            addKeyToMap(accountExMap, cs.AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c);
            addKeyToMap(recordTypeExMap, cs.AccountId__r.RecordTypeId__c);
            addKeyToMap(productExMap, cs.ProductId__c);
            addKeyToMap(productExMap, cs.Product_c__c);
            addKeyToMap(locationExMap, cs.ShipToLocation_c__c);
            addKeyToMap(addressExMap, cs.ShipToLocation_c__r.VisitorAddressId__c);
        }
    }

    private void addKeyToMap(Map<Id, SObject> objMap, Id externalId) {
        if (externalId != null && objMap.get(externalId) == null) {
            objMap.put(externalId, null);
        }
    }

    private void initializeMapsValues() {
        initializeMapValues(contactExMap);
        initializeMapValues(assetExMap);
        initializeMapValues(codeGroupExMap);
        initializeMapValues(userExMap);
        initializeMapValues(entitlementExMap);
        initializeMapValues(accountExMap);
        initializeMapValues(recordTypeExMap);
        initializeMapValues(productExMap);
        initializeMapValues(locationExMap);
        initializeMapValues(addressExMap);
    }

    private void initializeMapValues(Map<Id, SObject> relatedRecordsMap) {
        fflib_SObjectSelector selector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(
            relatedRecordsMap.getSObjectType()
        );
        
        for (SObject obj : selector.selectSObjectsById(relatedRecordsMap.keySet())) {
            relatedRecordsMap.put((Id)obj.get('ExternalId'), obj);
        }
    }

    public Contact__x getExternalContactData(Id externalId) {
        return contactExMap.get(externalId);
    }

    public Asset__x getExternalAssetData(Id externalId) {
        return assetExMap.get(externalId);
    }

    public CodeGroup_c__x getExternalCodeGroupData(Id externalId) {
        return codeGroupExMap.get(externalId);
    }

    public User__x getExternalUserData(Id externalId) {
        return userExMap.get(externalId);
    }

    public Entitlement__x getExternalEntitlementData(Id externalId) {
        return entitlementExMap.get(externalId);
    }

    public Account__x getExternalAccountData(Id externalId) {
        return accountExMap.get(externalId);
    }

    public RecordType__x getExternalRecordTypeData(Id externalId) {
        return recordTypeExMap.get(externalId);
    }

    public Product2__x getExternalProductData(Id externalId) {
        return productExMap.get(externalId);
    }

    public Location__x getExternalLocationData(Id externalId) {
        return locationExMap.get(externalId);
    }

    public Address__x getExternalAddressData(Id externalId) {
        return addressExMap.get(externalId);
    }
}