/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalWorkOrderSelectorImpl extends ExternalObjectSelector implements ExternalWorkOrderSelector {

    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            WorkOrder__x.Id,
            WorkOrder__x.LastModifiedDate__c,
            WorkOrder__x.StartDate__c,
            WorkOrder__x.ClosedDate_c__c,
            WorkOrder__x.ExternalId,
            WorkOrder__x.Status__c,
            WorkOrder__x.Categories_c__c,
            WorkOrder__x.SubCategory_c__c,
            WorkOrder__x.SAP_ServiceOrderType_c__c,
            WorkOrder__x.Subject__c,
            WorkOrder__x.WorkOrderNumber__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return WorkOrder__x.SObjectType;
    }

    public List<WorkOrder__x> selectByDateModified(DateTime asOf) {

        setWhereClause(
            'LastModifiedDate__c >= :asOf '
        );

        fflib_SObjectSelector externalCaseSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        registerExternalRelationshipFields('CaseId__r', externalCaseSelector);

        String queryString = getQuery();
        System.debug(queryString);
        List<SObject> records = Database.query(queryString);
        return filterCases(records, 'CaseId__r');
    }

    public List<WorkOrder__x> selectByExternalIds(Set<Id> externalIds) {

        setWhereClause(
            'ExternalId in :externalIds '
        );

        fflib_SObjectSelector externalCaseSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        registerExternalRelationshipFields('CaseId__r', externalCaseSelector);

        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'CaseId__r');
    }
}