/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalEntitlementSelectorImpl extends fflib_SobjectSelector implements ExternalEntitlementSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList =  new List<Schema.SObjectField> {
            Entitlement__x.Id,
            Entitlement__x.ExternalId,
            Entitlement__x.Name__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Entitlement__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'Entitlement__x') {
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
        return Entitlement__x.SObjectType;
    }

    public List<Entitlement__x> selectById(Set<Id> recordIds) {
        return (List<Entitlement__x>) selectSObjectsById(recordIds);
    }
}