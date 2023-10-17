/*
 * Created on Mon Nov 8, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ComplaintSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ComplaintSelectorImpl selector = (ComplaintSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(CMPL123CME__Complaint__c.Id));
        System.assert(returnList.contains(CMPL123CME__Complaint__c.CMPL123CME__CMPL123_WF_Status__c));
        System.assert(returnList.size() > 2);
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ComplaintSelectorImpl selector = (ComplaintSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(CMPL123CME__Complaint__c.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectPREsByDateModifiedTest() {

        DateTime asOf = System.now();
        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(true);
        List<CMPL123CME__Complaint__c> complaints;

        Test.startTest();
        complaints = ((ComplaintSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType))
            .selectPREsByDateModified(asOf);
        Test.stopTest();

        System.assertEquals(1, complaints.size());
    }

    @IsTest
    static void selectByExternalCaseIdTest() {

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(true);
        List<CMPL123CME__Complaint__c> complaints;

        Test.startTest();
        complaints = ((ComplaintSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType))
            .selectByExternalCaseId(new Set<Id> { complaint.BMX_Case_External__c });
        Test.stopTest();

        System.assertEquals(1, complaints.size());
    }

    @IsTest
    static void selectPREsByExternalIdsTest() {

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(true);
        List<CMPL123CME__Complaint__c> complaints;

        Test.startTest();
        complaints = ((ComplaintSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType))
            .selectPREsByExternalIds(new Set<Id> { complaint.BMX_Case_External__c });
        Test.stopTest();

        System.assertEquals(1, complaints.size());
    }
}