/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ExternalCaseCommentSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalCaseCommentSelectorImpl selector = (ExternalCaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CaseComment__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(CaseComment__x.Id));
        System.assert(returnList.contains(CaseComment__x.CommentBody__c));
        System.assert(returnList.contains(CaseComment__x.LastModifiedDate__c));
        System.assert(returnList.contains(CaseComment__x.ExternalId));
        System.assert(returnList.contains(CaseComment__x.CreatedDate__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalCaseCommentSelectorImpl selector = (ExternalCaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CaseComment__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(CaseComment__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByDateModifiedTest() {

        List<CaseComment__x> records;

        Test.startTest();
        records = ((ExternalCaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CaseComment__x.SObjectType))
            .selectByDateModified(
                Datetime.now()
            );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }

    @IsTest
    static void selectByExternalIdTest() {

        Id externalId = fflib_IDGenerator.generate(CaseComment__x.SObjectType);
        List<CaseComment__x> records;

        Test.startTest();
        records = ((ExternalCaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CaseComment__x.SObjectType))
            .selectByExternalId(
                new Set<Id> { externalId }
            );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}