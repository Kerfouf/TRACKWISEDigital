/*
* Created on Tues Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalCaseSelectorImpl extends ExternalObjectSelector implements ExternalCaseSelector {
    
    /*Required by fflib*/
    // Dynamically build field list from custom metadata type
    public List<Schema.SObjectField> getSObjectFieldList() {
        
        List<Schema.SObjectField> fieldList = new List<Schema.SObjectField> { 
            Case__x.Id,
            Case__x.ExternalId,
            Case__x.AccountId__c,
            Case__x.ActionCode_c__c,
            Case__x.ANALYZE_c__c,
            Case__x.AssetId__c,
            Case__x.CaseNumber_c__c,
            Case__x.ContactId__c,
            Case__x.CreatedById__c,
            Case__x.EntitlementId__c,
            Case__x.ErrorCode_c__c,
            Case__x.L1Owner_c__c,
            Case__x.L2Owner_c__c,
            Case__x.LastModifiedById__c,
            Case__x.NoInvestJustif_c__c,
            Case__x.OwnerId__c,
            Case__x.ProductId__c,
            Case__x.Product_c__c,
            Case__x.RESULT_c__c,
            Case__x.SAMPLE_c__c,
            Case__x.SatisfactionCode_c__c,
            Case__x.ShipToLocation_c__c,
            Case__x.SoftwareCode_c__c,
            Case__x.TWComplaintNumber_c__c,
            Case__x.Type__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Case__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'Case__x') {
                Schema.SObjectField field = fieldMap.get(config.CRM_Field_API_Name__c);
                if (field != null && !fieldList.contains(fieldMap.get(config.CRM_Field_API_Name__c))) {
                    fieldList.add(fieldMap.get(config.CRM_Field_API_Name__c));
                }
            }
        }

        return fieldList;
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return Case__x.SObjectType;
    }

    public List<Case__x> selectByDateModified(DateTime asOf) {
        
        fflib_SObjectSelector extAcctSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Account__x.SObjectType);
        registerExternalRelationshipFields('AccountId__r', extAcctSelector);

        fflib_SObjectSelector extLocSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Location__x.SObjectType);
        registerExternalRelationshipFields('ShipToLocation_c__r', extLocSelector);

        setWhereClause(
            'LastModifiedDate__c >= :asOf ' 
        );

        return filterCases(Database.query(getQuery()));
    }

    public List<Case__x> selectByExternalId(Set<Id> externalIds) {

        setWhereClause(
            'ExternalId IN :externalIds '
        );

        fflib_SObjectSelector extAcctSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Account__x.SObjectType);
        registerExternalRelationshipFields('AccountId__r', extAcctSelector);

        fflib_SObjectSelector extLocSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(Location__x.SObjectType);
        registerExternalRelationshipFields('ShipToLocation_c__r', extLocSelector);
        
        List<SObject> records = Database.query(getQuery());
        return filterCases(records);
    }
}