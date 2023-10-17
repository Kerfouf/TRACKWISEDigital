/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmServiceAppointmentIntServiceImplTest {
    
    @IsTest
    static void getExternalServiceAppointmentsByDateModifiedTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalServiceAppointmentSelector mockSelector = (ExternalServiceAppointmentSelector)mocks.mock(ExternalServiceAppointmentSelector.class);
        
        // Given
        mocks.startStubbing();

        ServiceAppointment__x externalServiceAppointment = CrmComplaintIntegrationTestDataFactory.createExternalServiceAppointment(
            fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType),
            'Test'
        );
        List<ServiceAppointment__x> externalServiceAppointments = new List<ServiceAppointment__x> { externalServiceAppointment };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(ServiceAppointment__x.SObjectType);
        mocks.when(mockSelector.selectByDateModified(asOf)).thenReturn(externalServiceAppointments);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmServiceAppointmentIntegrationService service = (CrmServiceAppointmentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmServiceAppointmentIntegrationService.class);
        List<ServiceAppointment__x> returnVal = service.getExternalServiceAppointmentsByDateModified(asOf);

        // Then
        ((ExternalServiceAppointmentSelector)mocks.verify(mockSelector, 1)).selectByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void getExternalServiceAppointmentsByExternalIdsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalServiceAppointmentSelector mockSelector = (ExternalServiceAppointmentSelector)mocks.mock(ExternalServiceAppointmentSelector.class);
        
        // Given
        mocks.startStubbing();

        ServiceAppointment__x externalServiceAppointment = CrmComplaintIntegrationTestDataFactory.createExternalServiceAppointment(
            fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType),
            'Test'
        );
        List<ServiceAppointment__x> externalServiceAppointments = new List<ServiceAppointment__x> { externalServiceAppointment };
        Set<Id> externalIds = new Set<Id> { externalServiceAppointment.ExternalId };

        mocks.when(mockSelector.sObjectType()).thenReturn(ServiceAppointment__x.SObjectType);
        mocks.when(mockSelector.selectByExternalIds(externalIds)).thenReturn(externalServiceAppointments);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmServiceAppointmentIntegrationService service = (CrmServiceAppointmentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmServiceAppointmentIntegrationService.class);
        List<ServiceAppointment__x> returnVal = service.getExternalServiceAppointmentsByExternalIds(externalIds);

        // Then
        ((ExternalServiceAppointmentSelector)mocks.verify(mockSelector, 1)).selectByExternalIds(externalIds);

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void insertServiceAppointmentsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        ServiceAppointment__x externalServiceAppointment = CrmComplaintIntegrationTestDataFactory.createExternalServiceAppointment(
            (Id) fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType),
            'Test'
        );

        List<ServiceAppointment__x> externalServiceAppointments = new List<ServiceAppointment__x> { externalServiceAppointment };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmServiceAppointmentIntegrationService service = (CrmServiceAppointmentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmServiceAppointmentIntegrationService.class);
        service.upsertServiceAppointments(externalServiceAppointments);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerNew(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest
    static void updateServiceAppointmentsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        Service_Appointment__c existingServiceAppointment = CrmComplaintIntegrationTestDataFactory.createServiceAppointment(true);
        ServiceAppointment__x externalServiceAppointment = CrmComplaintIntegrationTestDataFactory.createExternalServiceAppointment(
            (Id) existingServiceAppointment.ExternalId__c,
            'Test'
        );
        List<ServiceAppointment__x> externalServiceAppointments = new List<ServiceAppointment__x> { externalServiceAppointment };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmServiceAppointmentIntegrationService service = (CrmServiceAppointmentIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmServiceAppointmentIntegrationService.class);
        service.upsertServiceAppointments(externalServiceAppointments);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerDirty(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest 
    static void callBackOnFailureTest() {
        
        DBSaveResultWithRecord failure = new DBSaveResultWithRecord();
        failure.obj = CrmComplaintIntegrationTestDataFactory.createServiceAppointment(false);
        failure.result = (Database.SaveResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', 
            Database.SaveResult.class
        );

        Test.startTest();
        new CrmServiceAppointmentIntServiceImpl().callBackOnFailure(new List<DBSaveResultWithRecord> { failure }); 
        Test.stopTest();

        System.assertEquals(1, [Select COUNT() From Error_Log__c Where Class_Name__c = 'CrmServiceAppointmentIntServiceImpl']);
    }
}