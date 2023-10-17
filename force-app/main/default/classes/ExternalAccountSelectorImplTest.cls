/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalAccountSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalAccountSelectorImpl selector = (ExternalAccountSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Account__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Account__x.Id));
        System.assert(returnList.contains(Account__x.ExternalId));
        System.assert(returnList.contains(Account__x.Global_Reporting_Hierarchy_Level_1_c__c));
        System.assert(returnList.contains(Account__x.Global_Reporting_Hierarchy_Level_2_c__c));
        System.assert(returnList.contains(Account__x.Global_Reporting_Hierarchy_Level_3_c__c));
        System.assert(returnList.contains(Account__x.Key_Account_Hierarchy_c__c));
        System.assert(returnList.contains(Account__x.Pricing_Hierarchy_c__c));
        System.assert(returnList.contains(Account__x.Pricing_Hierarchy_2_c__c));
        System.assert(returnList.contains(Account__x.RecordTypeId__c));
        System.assert(returnList.contains(Account__x.Reporting_Hierarchy_c__c));
        System.assert(returnList.size() > 10);
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalAccountSelectorImpl selector = (ExternalAccountSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Account__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Account__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<Account__x> records;

        Test.startTest();
        records = ((ExternalAccountSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Account__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(Account__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}