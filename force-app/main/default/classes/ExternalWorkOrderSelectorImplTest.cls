/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ExternalWorkOrderSelectorImplTest {
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalWorkOrderSelectorImpl selector = (ExternalWorkOrderSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(WorkOrder__x.Id));
        System.assert(returnList.contains(WorkOrder__x.LastModifiedDate__c));
        System.assert(returnList.contains(WorkOrder__x.StartDate__c));
        System.assert(returnList.contains(WorkOrder__x.ClosedDate_c__c));
        System.assert(returnList.contains(WorkOrder__x.ExternalId));
        System.assert(returnList.contains(WorkOrder__x.Status__c));
        System.assert(returnList.contains(WorkOrder__x.Categories_c__c));
        System.assert(returnList.contains(WorkOrder__x.SubCategory_c__c));
        System.assert(returnList.contains(WorkOrder__x.SAP_ServiceOrderType_c__c));
        System.assert(returnList.contains(WorkOrder__x.Subject__c));
        System.assert(returnList.contains(WorkOrder__x.WorkOrderNumber__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalWorkOrderSelectorImpl selector = (ExternalWorkOrderSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(WorkOrder__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByDateModifiedTest() {

        List<WorkOrder__x> records;

        Test.startTest();
        records = ((ExternalWorkOrderSelector)CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType)).selectByDateModified(
            Datetime.now()
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }

    @IsTest
    static void selectByExternalIdsTest() {

        Id externalId = fflib_IDGenerator.generate(WorkOrder__x.SObjectType);
        List<WorkOrder__x> records;

        Test.startTest();
        records = ((ExternalWorkOrderSelector)CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType)).selectByExternalIds(
            new Set<Id> { externalId }
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}