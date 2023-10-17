/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalCodeGroupSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalCodeGroupSelectorImpl selector = (ExternalCodeGroupSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CodeGroup_c__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(CodeGroup_c__x.Id));
        System.assert(returnList.contains(CodeGroup_c__x.ExternalId));
        System.assert(returnList.contains(CodeGroup_c__x.Name__c));
        System.assert(returnList.contains(CodeGroup_c__x.Code_c__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalCodeGroupSelectorImpl selector = (ExternalCodeGroupSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CodeGroup_c__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(CodeGroup_c__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<CodeGroup_c__x> records;

        Test.startTest();
        records = ((ExternalCodeGroupSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CodeGroup_c__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(CodeGroup_c__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}