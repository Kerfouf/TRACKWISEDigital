/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class CrmWorkOrderIntegrationServiceImplTest {
    
    @IsTest
    static void getExternalWorkOrdersByDateModifiedTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalWorkOrderSelector mockSelector = (ExternalWorkOrderSelector)mocks.mock(ExternalWorkOrderSelector.class);
        
        // Given
        mocks.startStubbing();

        WorkOrder__x externalWorkOrder = CrmComplaintIntegrationTestDataFactory.createExternalWorkOrder(
            fflib_IDGenerator.generate(WorkOrder__x.SObjectType), 
            'Test'
        );
        List<WorkOrder__x> externalWorkOrders = new List<WorkOrder__x> { externalWorkOrder };
        DateTime asOf = DateTime.now();

        mocks.when(mockSelector.sObjectType()).thenReturn(WorkOrder__x.SObjectType);
        mocks.when(mockSelector.selectByDateModified(asOf)).thenReturn(externalWorkOrders);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmWorkOrderIntegrationServiceImpl service = (CrmWorkOrderIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmWorkOrderIntegrationService.class);
        List<WorkOrder__x> returnVal = service.getExternalWorkOrdersByDateModified(asOf);

        // Then
        ((ExternalWorkOrderSelector)mocks.verify(mockSelector, 1)).selectByDateModified(fflib_Match.anyDatetime());

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void getExternalWorkOrdersByExternalIdsTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        ExternalWorkOrderSelector mockSelector = (ExternalWorkOrderSelector)mocks.mock(ExternalWorkOrderSelector.class);
        
        // Given
        mocks.startStubbing();

        WorkOrder__x externalWorkOrder = CrmComplaintIntegrationTestDataFactory.createExternalWorkOrder(
            fflib_IDGenerator.generate(WorkOrder__x.SObjectType), 
            'Test'
        );
        List<WorkOrder__x> externalWorkOrders = new List<WorkOrder__x> { externalWorkOrder };
        Set<Id> externalIds = new Set<Id> { externalWorkOrder.ExternalId };

        mocks.when(mockSelector.sObjectType()).thenReturn(WorkOrder__x.SObjectType);
        mocks.when(mockSelector.selectByExternalIds(externalIds)).thenReturn(externalWorkOrders);
        mocks.stopStubbing();
   
        CrmComplaintIntegrationApplication.selector.setMock(mockSelector);

        // When
        CrmWorkOrderIntegrationServiceImpl service = (CrmWorkOrderIntegrationServiceImpl) CrmComplaintIntegrationApplication.service.newInstance(CrmWorkOrderIntegrationService.class);
        List<WorkOrder__x> returnVal = service.getExternalWorkOrdersByExternalIds(externalIds);

        // Then
        ((ExternalWorkOrderSelector)mocks.verify(mockSelector, 1)).selectByExternalIds(externalIds);

        System.assertEquals(1, returnVal.size());
    }

    @IsTest
    static void insertWorkOrdersTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        WorkOrder__x externalWorkOrder = CrmComplaintIntegrationTestDataFactory.createExternalWorkOrder(
            (Id) fflib_IDGenerator.generate(WorkOrder.SObjectType), 
            'Test'
        );

        List<WorkOrder__x> externalWorkOrders = new List<WorkOrder__x> { externalWorkOrder };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmWorkOrderIntegrationService service = (CrmWorkOrderIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmWorkOrderIntegrationService.class);
        service.upsertWorkOrders(externalWorkOrders);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerNew(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest
    static void updateWorkOrdersTest(){
        
        // Create mocks
        fflib_ApexMocks mocks = new fflib_ApexMocks();
        fflib_ISObjectUnitOfWork uowMock = new fflib_SObjectMocks.SObjectUnitOfWork(mocks);
        
        // Given
        mocks.startStubbing();

        Work_Order__c existingWorkOrder = CrmComplaintIntegrationTestDataFactory.createWorkOrder(true);
        WorkOrder__x externalWorkOrder = CrmComplaintIntegrationTestDataFactory.createExternalWorkOrder(
            (Id) existingWorkOrder.ExternalId__c, 
            'Test'
        );

        List<WorkOrder__x> externalWorkOrders = new List<WorkOrder__x> { externalWorkOrder };

        mocks.stopStubbing();

        CrmComplaintIntegrationApplication.unitOfWork.setMock(uowMock);

        // When
        CrmWorkOrderIntegrationService service = (CrmWorkOrderIntegrationService) CrmComplaintIntegrationApplication.service.newInstance(CrmWorkOrderIntegrationService.class);
        service.upsertWorkOrders(externalWorkOrders);

        // Then
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).registerDirty(fflib_Match.anySObject());
        ((fflib_ISObjectUnitOfWork)mocks.verify(uowMock, 1)).commitWork();
    }

    @IsTest 
    static void callBackOnFailureTest() {
        
        DBSaveResultWithRecord failure = new DBSaveResultWithRecord();
        failure.obj = CrmComplaintIntegrationTestDataFactory.createWorkOrder(false);
        failure.result = (Database.SaveResult)JSON.deserialize(
            '{"success":false,"errors":[{"message":"You cannot do this...","statusCode":"FIELD_CUSTOM_VALIDATION_EXCEPTION"}]}', 
            Database.SaveResult.class
        );

        Test.startTest();
        new CrmWorkOrderIntegrationServiceImpl().callBackOnFailure(new List<DBSaveResultWithRecord> { failure }); 
        Test.stopTest();

        System.assertEquals(1, [Select COUNT() From Error_Log__c Where Class_Name__c = 'CrmWorkOrderIntegrationServiceImpl']);
    }
}