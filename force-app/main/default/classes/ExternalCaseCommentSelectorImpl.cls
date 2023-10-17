/*
* Created on Tues Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class ExternalCaseCommentSelectorImpl extends ExternalObjectSelector implements ExternalCaseCommentSelector {
    
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            CaseComment__x.Id,
            CaseComment__x.CommentBody__c,
            CaseComment__x.LastModifiedDate__c,
            CaseComment__x.ExternalId,
            CaseComment__x.CreatedDate__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return CaseComment__x.SObjectType;
    }

    public List<CaseComment__x> selectByDateModified(DateTime asOf) {
        
        setWhereClause(
            'LastModifiedDate__c >= :asOf '
        );

        fflib_SObjectSelector externalCaseSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        registerExternalRelationshipFields('ParentId__r', externalCaseSelector);

        fflib_SObjectSelector externalUserSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(User__x.SObjectType);
        registerExternalRelationshipFields('CreatedById__r', externalUserSelector);
        
        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'ParentId__r');
    }

    public List<CaseComment__x> selectByExternalId(Set<Id> externalIds) {

        setWhereClause(
            'ExternalId IN :externalIds '
        );

        fflib_SObjectSelector externalCaseSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Case__x.SObjectType);
        registerExternalRelationshipFields('ParentId__r', externalCaseSelector);

        fflib_SObjectSelector externalUserSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(User__x.SObjectType);
        registerExternalRelationshipFields('CreatedById__r', externalUserSelector);
        
        List<SObject> records = Database.query(getQuery());
        return filterCases(records, 'ParentId__r');
    }
}