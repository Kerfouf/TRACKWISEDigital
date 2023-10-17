/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmProductConsumedIntRetryJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmProductsConsumedIntegrationService mockService = (CrmProductsConsumedIntegrationService)mocks.mock(CrmProductsConsumedIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        ProductConsumed__x externalProductConsumed = CrmComplaintIntegrationTestDataFactory.createExternalProductConsumed(
            fflib_IDGenerator.generate(ProductConsumed__x.SObjectType),
            100
        );
        List<ProductConsumed__x> externalProductsConsumed = new List<ProductConsumed__x> { externalProductConsumed };
        Set<Id> externalIds = new Set<Id> { externalProductConsumed.ExternalId };
        CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        Error_Log__c log = CrmComplaintIntegrationTestDataFactory.createErrorLog(true, 'Product_Consumed__c', externalProductConsumed.ExternalId);

        mocks.when(mockService.getExternalProductsConsumedByExternalIds(externalIds)).thenReturn(externalProductsConsumed);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmProductsConsumedIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmProductConsumedIntegrationRetryJob(new List<Error_Log__c> { log }).run();
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}