/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmProductConsumedIntegrationJobTest {
    
    @IsTest
    static void runTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        CrmProductsConsumedIntegrationService mockService = (CrmProductsConsumedIntegrationService)mocks.mock(CrmProductsConsumedIntegrationService.class);
        
        // Given
        mocks.startStubbing();

        CRM_Integration_Settings__c config = CrmComplaintIntegrationTestDataFactory.createCrmIntegrationSetting(true);
        ProductConsumed__x externalProductConsumed = CrmComplaintIntegrationTestDataFactory.createExternalProductConsumed(
            fflib_IDGenerator.generate(ProductConsumed__x.SObjectType),
            100
        );

        List<ProductConsumed__x> externalProductsConsumed = new List<ProductConsumed__x> { externalProductConsumed };

        mocks.when(mockService.getExternalProductsConsumedByDateModified(fflib_Match.anyDatetime())).thenReturn(externalProductsConsumed);

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.service.setMock(CrmProductsConsumedIntegrationService.class, mockService);

        // When
        String jobId;

        Test.startTest();
        jobId = new CrmProductConsumedIntegrationJob(config).run();
        // jobId = CrmProductConsumedIntegrationJob.run(config);
        Test.stopTest();
        
        // Then
        System.assertNotEquals(null, jobId);
    }
}