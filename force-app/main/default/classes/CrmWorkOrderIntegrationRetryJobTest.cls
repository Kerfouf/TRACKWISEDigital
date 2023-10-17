/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmWorkOrderIntegrationRetryJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmWorkOrderIntegrationService mockService = (CrmWorkOrderIntegrationService)mocks.mock(CrmWorkOrderIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        WorkOrder__x externalWorkOrder = CrmComplaintIntegrationTestDataFactory.createExternalWorkOrder(
            fflib_IDGenerator.generate(WorkOrder__x.SObjectType), 
            'Test'
        );
        List<WorkOrder__x> externalWorkOrders = new List<WorkOrder__x> { externalWorkOrder };
        Set<Id> externalIds = new Set<Id> { externalWorkOrder.ExternalId };
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        Error_Log__c log = CrmComplaintIntegrationTestDataFactory.createErrorLog(true, 'Work_Order__c', externalWorkOrder.ExternalId);

        mocks.when(mockService.getExternalWorkOrdersByExternalIds(externalIds)).thenReturn(externalWorkOrders);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmWorkOrderIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmWorkOrderIntegrationRetryJob(new List<Error_Log__c> { log }).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}