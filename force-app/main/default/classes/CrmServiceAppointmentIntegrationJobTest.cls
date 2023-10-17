/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmServiceAppointmentIntegrationJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmServiceAppointmentIntegrationService mockService = (CrmServiceAppointmentIntegrationService)mocks.mock(CrmServiceAppointmentIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        CRM_Integration_Settings__c config = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        ServiceAppointment__x externalServiceAppointment = CrmComplaintIntegrationTestDataFactory.createExternalServiceAppointment(
            fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType),
            'Test'
        );

        List<ServiceAppointment__x> externalServiceAppointments = new List<ServiceAppointment__x> { externalServiceAppointment };

        mocks.when(mockService.getExternalServiceAppointmentsByDateModified(fflib_Match.anyDatetime())).thenReturn(externalServiceAppointments);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmServiceAppointmentIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmServiceAppointmentIntegrationJob(config).run();
        // jobId = CrmServiceAppointmentIntegrationJob.run(config);
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}