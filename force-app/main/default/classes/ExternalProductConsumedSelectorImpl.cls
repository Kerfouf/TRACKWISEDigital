/*
 * Created on Tue Nov 23, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

 public inherited sharing class ExternalProductConsumedSelectorImpl extends ExternalObjectSelector implements ExternalProductConsumedSelector {

    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            ProductConsumed__x.Id,
            ProductConsumed__x.LastModifiedDate__c,
            ProductConsumed__x.ExternalId,
            ProductConsumed__x.QuantityConsumed__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return ProductConsumed__x.SObjectType;
    }

    public List<ProductConsumed__x> selectByDateModified(DateTime asOf) {

        setReferenceFields(
            new List<String> { 
                'WorkOrderId__r.CaseId__r.ExternalId',
                'WorkOrderId__r.CaseId__r.TWComplaintNumber_c__c',
                'WorkOrderId__r.CaseId__r.CaseNumber_c__c',
                'WorkOrderId__r.CaseId__r.CaseNumber__c',
                'WorkOrderId__r.CaseId__r.Type__c',
                'PricebookEntryId__r.LocalProductName_c__c'
            }
        );
        
        setWhereClause(
            'LastModifiedDate__c >= :asOf '
        );

        fflib_SObjectSelector externalWorkOrderSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        registerExternalRelationshipFields('WorkOrderId__r', externalWorkOrderSelector);

        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'WorkOrderId__r.CaseId__r');
    }

    public List<ProductConsumed__x> selectByExternalIds(Set<Id> externalIds) {

        setReferenceFields(
            new List<String> { 
                'WorkOrderId__r.CaseId__r.ExternalId',
                'WorkOrderId__r.CaseId__r.TWComplaintNumber_c__c',
                'WorkOrderId__r.CaseId__r.CaseNumber_c__c',
                'WorkOrderId__r.CaseId__r.CaseNumber__c',
                'WorkOrderId__r.CaseId__r.Type__c',
                'PricebookEntryId__r.LocalProductName_c__c'
            }
        );
        
        setWhereClause(
            'ExternalId in :externalIds ' 
        );

        fflib_SObjectSelector externalWorkOrderSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        registerExternalRelationshipFields('WorkOrderId__r', externalWorkOrderSelector);

        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'WorkOrderId__r.CaseId__r');
    }
}