/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CreateGlobalAssessmentsRetryJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        GlobalAssessmentService mockService = (GlobalAssessmentService)mocks.mock(GlobalAssessmentService.class);
        
        // Given
        mocks.startStubbing();

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        List<CMPL123CME__Complaint__c> complaints = new List<CMPL123CME__Complaint__c> { complaint };
        Set<Id> externalIds = new Set<Id> { complaint.BMX_Case_External__c };
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        Error_Log__c log = CrmComplaintIntegrationTestDataFactory.createErrorLog(true, 'CMPL123CME__Questionnaire__c', complaint.BMX_Case_External__c);

        mocks.when(mockService.getPREsByExternalIds(externalIds)).thenReturn(complaints);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(GlobalAssessmentService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CreateGlobalAssessmentsRetryJob(new List<Error_Log__c> { log }).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}