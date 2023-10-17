/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmProductsConsumedIntServiceImplTest {
    
    @IsTest
    static void getExternalProductsConsumedByDateModifiedTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalProductConsumedSelector mockSelector = (ExternalProductConsumedSelector)mocks.mock(ExternalProductConsumedSelector.class);
        
        // Given
        mocks.startStubbing();

        ProductConsumed__x externalProductConsumed = CrmComplaintIntegrationTestDataFactory.createExternalProductConsumed(
            fflib_IDGenerator.generate(ProductConsumed__x.SObjectType),
            100
        );
        List<ProductConsumed__x> externalProductsConsumed = new List<ProductConsumed__x> { externalProductConsumed };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(ProductConsumed__x.SObjectType);
        mocks.when(mockSelector.selectByDateModified(asOf)).thenReturn(externalProductsConsumed);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmProductsConsumedIntegrationService service = (CrmProductsConsumedIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmProductsConsumedIntegrationService.class);
        List<ProductConsumed__x> returnVal = service.getExternalProductsConsumedByDateModified(asOf);

        // Then
        ((ExternalProductConsumedSelector)mocks.verify(mockSelector, 1)).selectByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void getExternalProductsConsumedByExternalIdsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalProductConsumedSelector mockSelector = (ExternalProductConsumedSelector)mocks.mock(ExternalProductConsumedSelector.class);
        
        // Given
        mocks.startStubbing();

        ProductConsumed__x externalProductConsumed = CrmComplaintIntegrationTestDataFactory.createExternalProductConsumed(
            fflib_IDGenerator.generate(ProductConsumed__x.SObjectType),
            100
        );
        List<ProductConsumed__x> externalProductsConsumed = new List<ProductConsumed__x> { externalProductConsumed };
        Set<Id> externalIds = new Set<Id> { externalProductConsumed.ExternalId };

        mocks.when(mockSelector.sObjectType()).thenReturn(ProductConsumed__x.SObjectType);
        mocks.when(mockSelector.selectByExternalIds(externalIds)).thenReturn(externalProductsConsumed);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmProductsConsumedIntegrationService service = (CrmProductsConsumedIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmProductsConsumedIntegrationService.class);
        List<ProductConsumed__x> returnVal = service.getExternalProductsConsumedByExternalIds(externalIds);

        // Then
        ((ExternalProductConsumedSelector)mocks.verify(mockSelector, 1)).selectByExternalIds(externalIds);

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void insertProductsConsumedTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        ProductConsumed__x externalProductConsumed = CrmComplaintIntegrationTestDataFactory.createExternalProductConsumed(
            (Id) fflib_IDGenerator.generate(ProductConsumed__x.SObjectType),
            100
        );

        List<ProductConsumed__x> externalProductsConsumed = new List<ProductConsumed__x> { externalProductConsumed };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmProductsConsumedIntegrationService service = (CrmProductsConsumedIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmProductsConsumedIntegrationService.class);
        service.upsertProductsConsumed(externalProductsConsumed);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerNew(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest
    static void updateProductsConsumedTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        Product_Consumed__c existingProductConsumed = CrmComplaintIntegrationTestDataFactory.createProductConsumed(true);
        ProductConsumed__x externalProductConsumed = CrmComplaintIntegrationTestDataFactory.createExternalProductConsumed(
            (Id) existingProductConsumed.ExternalId__c,
            100
        );
        List<ProductConsumed__x> externalProductsConsumed = new List<ProductConsumed__x> { externalProductConsumed };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmProductsConsumedIntegrationService service = (CrmProductsConsumedIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmProductsConsumedIntegrationService.class);
        service.upsertProductsConsumed(externalProductsConsumed);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerDirty(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest 
    static void callBackOnFailureTest() {
        
        DBSaveResultWithRecord failure = new DBSaveResultWithRecord();
        failure.obj = CrmComplaintIntegrationTestDataFactory.createProductConsumed(false);
        failure.result = (Database.SaveResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', 
            Database.SaveResult.class
        );

        Test.startTest();
        new CrmProductsConsumedIntServiceImpl().callBackOnFailure(new List<DBSaveResultWithRecord> { failure }); 
        Test.stopTest();

        System.assertEquals(1, [Select COUNT() From Error_Log__c Where Class_Name__c = 'CrmProductsConsumedIntServiceImpl']);
    }
}