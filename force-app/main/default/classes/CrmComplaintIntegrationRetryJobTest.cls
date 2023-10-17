/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmComplaintIntegrationRetryJobTest {
    
    @IsTest
    static void runTest(){
        
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmComplaintIntegrationService mockService = (CrmComplaintIntegrationService)mocks.mock(CrmComplaintIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();
        List<Case__x> externalCases = new List<Case__x> { externalCase };
        Set<Id> externalIds = new Set<Id> { externalCase.ExternalId };
        Error_Log__c log = CrmComplaintIntegrationTestDataFactory.createErrorLog(true, 'CMPL123CME__Complaint__c', externalCase.ExternalId);

        mocks.when(mockService.getExternalCasesByExternalId(externalIds)).thenReturn(externalCases);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmComplaintIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmComplaintIntegrationRetryJob(new List<Error_Log__c> { log }).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}