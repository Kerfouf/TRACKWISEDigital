/*
* Created on Wed Nov 24, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ExternalServiceAppointmentSelectorTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalServiceAppointmentSelectorImpl selector = (ExternalServiceAppointmentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(ServiceAppointment__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(ServiceAppointment__x.Id));
        System.assert(returnList.contains(ServiceAppointment__x.ExternalId));
        System.assert(returnList.contains(ServiceAppointment__x.Description__c));
        System.assert(returnList.contains(ServiceAppointment__x.Status__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalServiceAppointmentSelectorImpl selector = (ExternalServiceAppointmentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(ServiceAppointment__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(ServiceAppointment__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByDateModifiedTest() {

        List<ServiceAppointment__x> records;

        Test.startTest();
        records = ((ExternalServiceAppointmentSelector)CrmComplaintIntegrationApplication.selector.newInstance(ServiceAppointment__x.SObjectType)).selectByDateModified(
            Datetime.now()
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }

    @IsTest
    static void selectByExternalIdsTest() {

        Id externalId = fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType);
        List<ServiceAppointment__x> records;

        Test.startTest();
        records = ((ExternalServiceAppointmentSelector)CrmComplaintIntegrationApplication.selector.newInstance(ServiceAppointment__x.SObjectType)).selectByExternalIds(
            new Set<Id> { externalId }
        );
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}