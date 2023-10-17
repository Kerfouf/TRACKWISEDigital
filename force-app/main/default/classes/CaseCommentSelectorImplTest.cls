/*
 * Created on Wed Nov 24, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class CaseCommentSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        CaseCommentSelectorImpl selector = (CaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case_Comment__c.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Case_Comment__c.Id));
        System.assert(returnList.contains(Case_Comment__c.ExternalId__c));
        System.assert(returnList.contains(Case_Comment__c.CommentBody__c));
        System.assert(returnList.contains(Case_Comment__c.BMX_User__c));
        System.assert(returnList.contains(Case_Comment__c.Created_Date__c));
        System.assert(returnList.contains(Case_Comment__c.ComplaintId__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        CaseCommentSelectorImpl selector = (CaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case_Comment__c.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Case_Comment__c.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectCaseCommentByExternalId() {

        Case_Comment__c caseComment = CrmComplaintIntegrationTestDataFactory.createCaseComment(true);

        Map<Id, Case_Comment__c> returnedMap;

        Test.startTest();
        returnedMap = ((CaseCommentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Case_Comment__c.SObjectType)).selectCaseCommentByExternalId(new Set<Id> { caseComment.ExternalId__c });
        Test.stopTest();

        System.assertEquals(1, returnedMap.keySet().size());
    }
}