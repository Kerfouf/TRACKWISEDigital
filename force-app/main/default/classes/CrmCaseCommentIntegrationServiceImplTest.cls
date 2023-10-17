/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmCaseCommentIntegrationServiceImplTest {
    
    @IsTest
    static void getExternalCaseCommentsByDateModifiedTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalCaseCommentSelector mockSelector = (ExternalCaseCommentSelector)mocks.mock(ExternalCaseCommentSelector.class);
        
        // Given
        mocks.startStubbing();

        CaseComment__x externalCaseComment = CrmComplaintIntegrationTestDataFactory.createExternalCaseComment(
            fflib_IDGenerator.generate(CaseComment__x.SObjectType), 
            'Test'
        );
        List<CaseComment__x> externalCaseComments = new List<CaseComment__x> { externalCaseComment };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(CaseComment__x.SObjectType);
        mocks.when(mockSelector.selectByDateModified(asOf)).thenReturn(externalCaseComments);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmCaseCommentIntegrationServiceImpl service = (CrmCaseCommentIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmCaseCommentIntegrationService.class);
        List<CaseComment__x> returnVal = service.getExternalCaseCommentsByDateModified(asOf);

        // Then
        ((ExternalCaseCommentSelector)mocks.verify(mockSelector, 1)).selectByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void getExternalCaseCommentsByExternalIdsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalCaseCommentSelector mockSelector = (ExternalCaseCommentSelector)mocks.mock(ExternalCaseCommentSelector.class);
        
        // Given
        mocks.startStubbing();

        CaseComment__x externalCaseComment = CrmComplaintIntegrationTestDataFactory.createExternalCaseComment(
            fflib_IDGenerator.generate(CaseComment__x.SObjectType), 
            'Test'
        );
        List<CaseComment__x> caseComments = new List<CaseComment__x> { externalCaseComment };
        Set<Id> externalIds = new Set<Id> { externalCaseComment.ExternalId };

        mocks.when(mockSelector.sObjectType()).thenReturn(CaseComment__x.SObjectType);
        mocks.when(mockSelector.selectByExternalId(externalIds)).thenReturn(caseComments);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmCaseCommentIntegrationServiceImpl service = (CrmCaseCommentIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmCaseCommentIntegrationService.class);
        List<CaseComment__x> returnVal = service.getExternalCaseCommentsByExternalIds(externalIds);

        // Then
        ((ExternalCaseCommentSelector)mocks.verify(mockSelector, 1)).selectByExternalId(externalIds);

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void insertCaseCommentsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        CaseComment__x externalCaseComment = CrmComplaintIntegrationTestDataFactory.createExternalCaseComment(
            (Id) fflib_IDGenerator.generate(CaseComment.SObjectType), 
            'Test Body'
        );

        List<CaseComment__x> externalCaseComments = new List<CaseComment__x> { externalCaseComment };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmCaseCommentIntegrationService service = (CrmCaseCommentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmCaseCommentIntegrationService.class);
        service.upsertCaseComments(externalCaseComments);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerNew(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest
    static void updateCaseCommentsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        Case_Comment__c existingCaseComment = CrmComplaintIntegrationTestDataFactory.createCaseComment(true);
        CaseComment__x externalCaseComment = CrmComplaintIntegrationTestDataFactory.createExternalCaseComment(
            (Id) existingCaseComment.ExternalId__c, 
            'Test Body'
        );

        List<CaseComment__x> externalCaseComments = new List<CaseComment__x> { externalCaseComment };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmCaseCommentIntegrationService service = (CrmCaseCommentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmCaseCommentIntegrationService.class);
        service.upsertCaseComments(externalCaseComments);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerDirty(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest 
    static void callBackOnFailureTest() {
        
        DBSaveResultWithRecord failure = new DBSaveResultWithRecord();
        failure.obj = CrmComplaintIntegrationTestDataFactory.createCaseComment(false);
        failure.result = (Database.SaveResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', 
            Database.SaveResult.class
        );

        Test.startTest();
        new CrmCaseCommentIntegrationServiceImpl().callBackOnFailure(new List<DBSaveResultWithRecord> { failure }); 
        Test.stopTest();

        System.assertEquals(1, [Select COUNT() From Error_Log__c Where Class_Name__c = 'CrmCaseCommentIntegrationServiceImpl']);
    }
}