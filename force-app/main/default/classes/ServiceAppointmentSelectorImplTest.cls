/*
* Created on Mon Nov 29, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ServiceAppointmentSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ServiceAppointmentSelectorImpl selector = (ServiceAppointmentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Service_Appointment__c.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Service_Appointment__c.Id));
        System.assert(returnList.contains(Service_Appointment__c.ExternalId__c));
        System.assert(returnList.contains(Service_Appointment__c.SA_Description__c));
        System.assert(returnList.contains(Service_Appointment__c.SA_Parent_record__c));
        System.assert(returnList.contains(Service_Appointment__c.SA_Status__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ServiceAppointmentSelectorImpl selector = (ServiceAppointmentSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Service_Appointment__c.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Service_Appointment__c.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectServiceAppointmentsByExternalIdTest() {

        Service_Appointment__c serviceAppointment = CrmComplaintIntegrationTestDataFactory.createServiceAppointment(true);
        Map<Id, Service_Appointment__c> recordMap;

        Test.startTest();
        recordMap = ((ServiceAppointmentSelector)CrmComplaintIntegrationApplication.selector.newInstance(Service_Appointment__c.SObjectType)).selectServiceAppointmentsByExternalId(
            new Set<Id> { serviceAppointment.ExternalId__c }
        );
        Test.stopTest();

        System.assertEquals(1, recordMap.keySet().size());
    }
}