/*
* Created on Tue Nov 16, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmComplaintIntegrationServiceImplTest {
    
    @IsTest
    static void getExternalCasesByDateModifiedTest() {
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalCaseSelector mockSelector = (ExternalCaseSelector)mocks.mock(ExternalCaseSelector.class);
        
        // Given
        mocks.startStubbing();

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();
        List<Case__x> externalCases = new List<Case__x> { externalCase };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(Case__x.SObjectType);
        mocks.when(mockSelector.selectByDateModified(asOf)).thenReturn(externalCases);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        List<Case__x> returnVal = service.getExternalCasesByDateModified(asOf);

        // Then
        ((ExternalCaseSelector)mocks.verify(mockSelector, 1)).selectByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void getExternalCasesByExternalIdTest() {
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalCaseSelector mockSelector = (ExternalCaseSelector)mocks.mock(ExternalCaseSelector.class);
        
        // Given
        mocks.startStubbing();

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();
        List<Case__x> externalCases = new List<Case__x> { externalCase };
        Set<Id> externalIds = new Set<Id> { externalCase.ExternalId };

        mocks.when(mockSelector.sObjectType()).thenReturn(Case__x.SObjectType);
        mocks.when(mockSelector.selectByExternalId(externalIds)).thenReturn(externalCases);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        List<Case__x> returnVal = service.getExternalCasesByExternalId(externalIds);

        // Then
        ((ExternalCaseSelector)mocks.verify(mockSelector, 1)).selectByExternalId(externalIds);

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void upsertComplaintsTest() {

        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        Id complaintId = fflib_IDGenerator.generate(CMPL123CME__Complaint__c.SObjectType);
        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();
        List<Case__x> cases = new List<Case__x> { externalCase };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmComplaintIntegrationService service = (CrmComplaintIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        service.upsertComplaints(cases);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerNew(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest 
    static void callBackOnFailureTest() {
        
        DBSaveResultWithRecord failure = new DBSaveResultWithRecord();
        failure.obj = (CMPL123CME__Complaint__c) SmartFactory.createSObject('CMPL123CME__Complaint__c');
        failure.result = (Database.SaveResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', 
            Database.SaveResult.class
        );

        Test.startTest();
        new CrmComplaintIntegrationServiceImpl().callBackOnFailure(new List<DBSaveResultWithRecord> { failure }); 
        Test.stopTest();

        System.assertEquals(1, [Select COUNT() From Error_Log__c Where Class_Name__c = 'CrmComplaintIntegrationServiceImpl']);
    }

    @IsTest(SeeAllData=true)
    static void updateClosedComplaintTest() {

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase('Closed');
        List<Case__x> cases = new List<Case__x> { externalCase };

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        complaint.BMX_Case_External__c = externalCase.ExternalId;
        complaint.CMPL123Task_Key_Value__c = 'Autoclose_Complaint';
        insert complaint;

        CMPL123CME__Complaint__c checkComplaint;
        
        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Complaint', checkComplaint.BMX_LongDescription__c);
        
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        service.upsertComplaints(cases);

        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Case', checkComplaint.BMX_LongDescription__c);
    }

    @IsTest(SeeAllData=true)
    static void reopenClosedComplaintTest() {

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase('Open');
        List<Case__x> cases = new List<Case__x> { externalCase };

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        complaint.BMX_Case_External__c = externalCase.ExternalId;
        complaint.CMPL123Task_Key_Value__c = 'Autoclose_Complaint';
        insert complaint;

        CMPL123CME__Complaint__c checkComplaint;
        
        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Complaint', checkComplaint.BMX_LongDescription__c);
        
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        service.upsertComplaints(cases);

        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertNotEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Case', checkComplaint.BMX_LongDescription__c);
    }

    @IsTest(SeeAllData=true)
    static void closeComplaintTest() {

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase('Closed');
        List<Case__x> cases = new List<Case__x> { externalCase };

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        complaint.BMX_Case_External__c = externalCase.ExternalId;
        complaint.CMPL123Task_Key_Value__c = 'Complaint';
        insert complaint;

        CMPL123CME__Complaint__c checkComplaint;
        
        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertNotEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Complaint', checkComplaint.BMX_LongDescription__c);
        
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        service.upsertComplaints(cases);

        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Case', checkComplaint.BMX_LongDescription__c);
    }

    @IsTest(SeeAllData=true)
    static void updateOpenComplaintTest() {

        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase('Open');
        List<Case__x> cases = new List<Case__x> { externalCase };

        CMPL123CME__Complaint__c complaint = CrmComplaintIntegrationTestDataFactory.createComplaint(false);
        complaint.BMX_Case_External__c = externalCase.ExternalId;
        complaint.CMPL123Task_Key_Value__c = 'Complaint';
        insert complaint;

        CMPL123CME__Complaint__c checkComplaint;
        
        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertNotEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Complaint', checkComplaint.BMX_LongDescription__c);
        
        CrmComplaintIntegrationServiceImpl service = (CrmComplaintIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmComplaintIntegrationService.class);
        service.upsertComplaints(cases);

        checkComplaint = [Select CMPL123CME__CMPL123_WF_Status__c, BMX_LongDescription__c From CMPL123CME__Complaint__c Where BMX_Case_External__c = :externalCase.ExternalId];
        System.assertNotEquals('Closed', checkComplaint.CMPL123CME__CMPL123_WF_Status__c);
        System.assertEquals('Test Case', checkComplaint.BMX_LongDescription__c);
    }
}