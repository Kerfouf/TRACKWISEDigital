/*
* Created on Mon Dec 6, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CreateGlobalAssessmentsJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        GlobalAssessmentService mockService = (GlobalAssessmentService)mocks.mock(GlobalAssessmentService.class);
        
        // Given
        mocks.startStubbing();

        CRM_Integration_Settings__c config = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);

        List<CMPL123CME__Complaint__c> complaints = new List<CMPL123CME__Complaint__c> { complaint };

        mocks.when(mockService.getPREsByDateModified(fflib_Match.anyDatetime())).thenReturn(complaints);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(GlobalAssessmentService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CreateGlobalAssessmentsJob(config).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}