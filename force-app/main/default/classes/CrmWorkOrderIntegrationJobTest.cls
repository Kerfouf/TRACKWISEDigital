/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmWorkOrderIntegrationJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmWorkOrderIntegrationService mockService = (CrmWorkOrderIntegrationService)mocks.mock(CrmWorkOrderIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        CRM_Integration_Settings__c config = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        WorkOrder__x externalWorkOrder = CrmComplaintIntegrationTestDataFactory.createExternalWorkOrder(
            fflib_IDGenerator.generate(WorkOrder__x.SObjectType), 
            'Test'
        );
        List<WorkOrder__x> externalWorkOrders = new List<WorkOrder__x> { externalWorkOrder };

        mocks.when(mockService.getExternalWorkOrdersByDateModified(fflib_Match.anyDatetime())).thenReturn(externalWorkOrders);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmWorkOrderIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmWorkOrderIntegrationJob(config).run();
        // jobId = CrmWorkOrderIntegrationJob.run(config);
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}