/*
 * Created on Tue Nov 23, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

public inherited sharing class ExternalServiceAppointmentSelectorImpl extends ExternalObjectSelector implements ExternalServiceAppointmentSelector {

    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ServiceAppointment__x.Id,
            ServiceAppointment__x.ExternalId,
            ServiceAppointment__x.Description__c,
            ServiceAppointment__x.Status__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return ServiceAppointment__x.SObjectType;
    }

    public List<ServiceAppointment__x> selectByDateModified(DateTime asOf) {

        setReferenceFields(
            new List<String> { 
                'WorkOrder_c__r.CaseId__r.ExternalId',
                'WorkOrder_c__r.CaseId__r.TWComplaintNumber_c__c',
                'WorkOrder_c__r.CaseId__r.CaseNumber_c__c',
                'WorkOrder_c__r.CaseId__r.CaseNumber__c',
                'WorkOrder_c__r.CaseId__r.Type__c'
            }
        );

        setWhereClause(
            'LastModifiedDate__c >= :asOf '
        );

        fflib_SObjectSelector externalWorkOrderSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        registerExternalRelationshipFields('WorkOrder_c__r', externalWorkOrderSelector);

        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'WorkOrder_c__r.CaseId__r');
    }

    public List<ServiceAppointment__x> selectByExternalIds(Set<Id> externalIds) {

        setReferenceFields(
            new List<String> { 
                'WorkOrder_c__r.CaseId__r.ExternalId',
                'WorkOrder_c__r.CaseId__r.TWComplaintNumber_c__c',
                'WorkOrder_c__r.CaseId__r.CaseNumber_c__c',
                'WorkOrder_c__r.CaseId__r.CaseNumber__c',
                'WorkOrder_c__r.CaseId__r.Type__c'
            }
        );

        setWhereClause(
            'ExternalId in :externalIds '
        );

        fflib_SObjectSelector externalWorkOrderSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        registerExternalRelationshipFields('WorkOrder_c__r', externalWorkOrderSelector);

        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'WorkOrder_c__r.CaseId__r');
    }
}