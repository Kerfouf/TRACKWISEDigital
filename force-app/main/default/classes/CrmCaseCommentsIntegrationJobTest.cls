/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmCaseCommentsIntegrationJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmCaseCommentIntegrationService mockService = (CrmCaseCommentIntegrationService)mocks.mock(CrmCaseCommentIntegrationService.class);
        
        // Given
        mocks.startStubbing();
        CRM_Integration_Settings__c config = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        CaseComment__x externalCaseComment = CrmComplaintIntegrationTestDataFactory.createExternalCaseComment(
            fflib_IDGenerator.generate(CaseComment__x.SObjectType), 
            'Test'
        );

        List<CaseComment__x> externalCaseComments = new List<CaseComment__x> { externalCaseComment };

        mocks.when(mockService.getExternalCaseCommentsByDateModified(fflib_Match.anyDatetime())).thenReturn(externalCaseComments);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmCaseCommentIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmCaseCommentsIntegrationJob(config).run();
        // jobId = CrmCaseCommentsIntegrationJob.run(config);
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}