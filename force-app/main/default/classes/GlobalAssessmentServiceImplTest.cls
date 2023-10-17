/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class GlobalAssessmentServiceImplTest {

    @IsTest
    static void getPREsByDateModifiedTest() {
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ComplaintSelector mockSelector = (ComplaintSelector)mocks.mock(ComplaintSelector.class);
        
        // Given
        mocks.startStubbing();

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        List<CMPL123CME__Complaint__c> complaints = new List<CMPL123CME__Complaint__c> { 
            complaint
        };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(CMPL123CME__Complaint__c.SObjectType);
        mocks.when(mockSelector.selectPREsByDateModified(asOf)).thenReturn(complaints);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        GlobalAssessmentServiceImpl service = (GlobalAssessmentServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(GlobalAssessmentService.class);
        List<CMPL123CME__Complaint__c> returnVal = service.getPREsByDateModified(asOf);

        // Then
        ((ComplaintSelector)mocks.verify(mockSelector, 1)).selectPREsByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void getPREsByExternalIdsTest() {
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ComplaintSelector mockSelector = (ComplaintSelector)mocks.mock(ComplaintSelector.class);
        
        // Given
        mocks.startStubbing();

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        List<CMPL123CME__Complaint__c> complaints = new List<CMPL123CME__Complaint__c> { 
            complaint
        };
        Set<Id> externalIds = new Set<Id> { complaint.BMX_Case_External__c };

        mocks.when(mockSelector.sObjectType()).thenReturn(CMPL123CME__Complaint__c.SObjectType);
        mocks.when(mockSelector.selectPREsByExternalIds(externalIds)).thenReturn(complaints);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        GlobalAssessmentServiceImpl service = (GlobalAssessmentServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(GlobalAssessmentService.class);
        List<CMPL123CME__Complaint__c> returnVal = service.getPREsByExternalIds(externalIds);

        // Then
        ((ComplaintSelector)mocks.verify(mockSelector, 1)).selectPREsByExternalIds(externalIds);

        System.assertEquals(1, returnVal.size());
    }
    
    @IsTest
    static void createMissingGlobalAssessmentsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ComplaintSelector mockSelector = (ComplaintSelector)mocks.mock(ComplaintSelector.class);
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        DateTime asOf = DateTime.now();
        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        List<CMPL123CME__Complaint__c> complaints = new List<CMPL123CME__Complaint__c> { complaint };

        mocks.when(mockSelector.sObjectType()).thenReturn(CMPL123CME__Complaint__c.SObjectType);
        mocks.when(mockSelector.selectPREsByDateModified(asOf)).thenReturn(complaints);
        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);
        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        GlobalAssessmentServiceImpl service = (GlobalAssessmentServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(GlobalAssessmentService.class);
        service.createMissingGlobalAssessments(complaints);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerNew(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest 
    static void callBackOnFailureTest() {
        
        DBSaveResultWithRecord failure = new DBSaveResultWithRecord();
        failure.obj = (CMPL123CME__Questionnaire__c) SmartFactory.createSObject('CMPL123CME__Questionnaire__c');
        failure.result = (Database.SaveResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', 
            Database.SaveResult.class
        );

        Test.startTest();
        new GlobalAssessmentServiceImpl().callBackOnFailure(new List<DBSaveResultWithRecord> { failure }); 
        Test.stopTest();

        System.assertEquals(1, [Select COUNT() From Error_Log__c Where Class_Name__c = 'GlobalAssessmentServiceImpl']);
    }
}