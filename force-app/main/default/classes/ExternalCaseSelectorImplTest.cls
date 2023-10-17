/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalCaseSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalCaseSelectorImpl selector = (ExternalCaseSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Case__x.Id));
        System.assert(returnList.contains(Case__x.ExternalId));
        System.assert(returnList.contains(Case__x.AccountId__c));
        System.assert(returnList.contains(Case__x.ActionCode_c__c));
        System.assert(returnList.contains(Case__x.ANALYZE_c__c));
        System.assert(returnList.contains(Case__x.AssetId__c));
        System.assert(returnList.contains(Case__x.CaseNumber_c__c));
        System.assert(returnList.contains(Case__x.ContactId__c));
        System.assert(returnList.contains(Case__x.CreatedById__c));
        System.assert(returnList.contains(Case__x.EntitlementId__c));
        System.assert(returnList.contains(Case__x.ErrorCode_c__c));
        System.assert(returnList.contains(Case__x.L1Owner_c__c));
        System.assert(returnList.contains(Case__x.L2Owner_c__c));
        System.assert(returnList.contains(Case__x.LastModifiedById__c));
        System.assert(returnList.contains(Case__x.NoInvestJustif_c__c));
        System.assert(returnList.contains(Case__x.OwnerId__c));
        System.assert(returnList.contains(Case__x.ProductId__c));
        System.assert(returnList.contains(Case__x.Product_c__c));
        System.assert(returnList.contains(Case__x.RESULT_c__c));
        System.assert(returnList.contains(Case__x.SAMPLE_c__c));
        System.assert(returnList.contains(Case__x.SatisfactionCode_c__c));
        System.assert(returnList.contains(Case__x.ShipToLocation_c__c));
        System.assert(returnList.contains(Case__x.SoftwareCode_c__c));
        System.assert(returnList.contains(Case__x.TWComplaintNumber_c__c));
        System.assert(returnList.size() > 24);
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalCaseSelectorImpl selector = (ExternalCaseSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Case__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByDateModifiedTest() {

        List<Case__x> records;

        Test.startTest();
        records = ((ExternalCaseSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType)).selectByDateModified(
            Datetime.now()
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }

    @IsTest
    static void selectByExternalIdTest() {

        Id externalId = fflib_IDGenerator.generate(Case__x.SObjectType);
        List<Case__x> records;

        Test.startTest();
        records = ((ExternalCaseSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType)).selectByExternalId(
            new Set<Id> { externalId }
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}