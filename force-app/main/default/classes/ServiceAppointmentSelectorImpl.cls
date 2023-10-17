/*
* Created on Tue Nov 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ServiceAppointmentSelectorImpl extends fflib_SObjectSelector implements ServiceAppointmentSelector {
    
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Service_Appointment__c.Id,
            Service_Appointment__c.ExternalId__c,
            Service_Appointment__c.SA_Description__c,
            Service_Appointment__c.SA_Parent_record__c,
            Service_Appointment__c.SA_Status__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return Service_Appointment__c.SObjectType;
    }

    public Map<Id, Service_Appointment__c> selectServiceAppointmentsByExternalId(Set<Id> externalIds) {
        
        Map<Id, Service_Appointment__c> returnMap = new Map<Id, Service_Appointment__c>();

        String queryCondition = 'ExternalId__c in :externalIds';

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(queryCondition)
            .selectFields(getSObjectFieldList());

        fflib_SObjectSelector workOrderSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Work_Order__c.SObjectType);
        workOrderSelector.configureQueryFactoryFields(queryFactory, 'workOrderId__r');
        
        for (Service_Appointment__c serviceAppointment : Database.query(queryFactory.toSOQL())) {
            returnMap.put(serviceAppointment.ExternalId__c, serviceAppointment);
        }

        return returnMap;
    }
}