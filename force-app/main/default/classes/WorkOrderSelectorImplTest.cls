/*
* Created on Mon Nov 29, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class WorkOrderSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        WorkOrderSelectorImpl selector = (WorkOrderSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Work_Order__c.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Work_Order__c.Id));
        System.assert(returnList.contains(Work_Order__c.ExternalId__c));
        System.assert(returnList.contains(Work_Order__c.WO_Category__c));
        System.assert(returnList.contains(Work_Order__c.WO_Status__c));
        System.assert(returnList.contains(Work_Order__c.WO_Sub_Category__c));
        System.assert(returnList.contains(Work_Order__c.WO_Subject__c));
        System.assert(returnList.contains(Work_Order__c.WO_Type__c));
        System.assert(returnList.contains(Work_Order__c.StartDate__c));
        System.assert(returnList.contains(Work_Order__c.ClosedDate_c__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        WorkOrderSelectorImpl selector = (WorkOrderSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Work_Order__c.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Work_Order__c.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectWorkOrdersByExternalIdTest() {

        Work_Order__c workOrder = CrmComplaintIntegrationTestDataFactory.createWorkOrder(true);
        Map<Id, Work_Order__c> recordMap;

        Test.startTest();
        recordMap = ((WorkOrderSelector)CrmComplaintIntegrationApplication.selector.newInstance(Work_Order__c.SObjectType)).selectWorkOrdersByExternalId(
            new Set<Id> { workOrder.ExternalId__c }
        );
        Test.stopTest();

        System.assertEquals(1, recordMap.keySet().size());
    }
}