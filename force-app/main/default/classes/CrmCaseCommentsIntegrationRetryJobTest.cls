/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmCaseCommentsIntegrationRetryJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmCaseCommentIntegrationService mockService = (CrmCaseCommentIntegrationService)mocks.mock(CrmCaseCommentIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        CaseComment__x externalCaseComment = CrmComplaintIntegrationTestDataFactory.createExternalCaseComment(
            fflib_IDGenerator.generate(CaseComment__x.SObjectType), 
            'Test'
        );
        List<CaseComment__x> caseComments = new List<CaseComment__x> { externalCaseComment };
        Set<Id> externalIds = new Set<Id> { externalCaseComment.ExternalId };
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        Error_Log__c log = CrmComplaintIntegrationTestDataFactory.createErrorLog(true, 'Case_Comment__c', externalCaseComment.ExternalId);

        mocks.when(mockService.getExternalCaseCommentsByExternalIds(externalIds)).thenReturn(caseComments);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmCaseCommentIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmCaseCommentsIntegrationRetryJob(new List<Error_Log__c> { log }).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}