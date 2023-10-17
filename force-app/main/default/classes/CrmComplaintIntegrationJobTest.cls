/*
* Created on Tue Nov 16, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmComplaintIntegrationJobTest {
    
    @IsTest
    static void runTest() {
         
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmComplaintIntegrationService mockService = (CrmComplaintIntegrationService)mocks.mock(CrmComplaintIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        CRM_Integration_Settings__c config = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();
        List<Case__x> externalCases = new List<Case__x> { externalCase };

        mocks.when(mockService.getExternalCasesByDateModified(fflib_Match.anyDatetime())).thenReturn(externalCases);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmComplaintIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = Database.executeBatch(new CrmComplaintIntegrationJob(config));
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
        System.assertNotEquals(CRM_Integration_Settings__c.getOrgDefaults().Complaints_As_Of__c, config.Complaints_As_Of__c);
        ((CrmComplaintIntegrationService)mocks.verify(mockService, 1)).getExternalCasesByDateModified(fflib_Match.anyDatetime());
    }
}