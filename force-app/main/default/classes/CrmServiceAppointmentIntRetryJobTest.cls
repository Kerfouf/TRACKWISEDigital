/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmServiceAppointmentIntRetryJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmServiceAppointmentIntegrationService mockService = (CrmServiceAppointmentIntegrationService)mocks.mock(CrmServiceAppointmentIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        ServiceAppointment__x externalServiceAppointment = CrmComplaintIntegrationTestDataFactory.createExternalServiceAppointment(
            fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType),
            'Test'
        );
        List<ServiceAppointment__x> externalServiceAppointments = new List<ServiceAppointment__x> { externalServiceAppointment };
        Set<Id> externalIds = new Set<Id> { externalServiceAppointment.ExternalId };
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        Error_Log__c log = CrmComplaintIntegrationTestDataFactory.createErrorLog(true, 'Service_Appointment__c', externalServiceAppointment.ExternalId);

        mocks.when(mockService.getExternalServiceAppointmentsByExternalIds(externalIds)).thenReturn(externalServiceAppointments);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmServiceAppointmentIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmServiceAppointmentIntegrationRetryJob(new List<Error_Log__c> { log }).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}