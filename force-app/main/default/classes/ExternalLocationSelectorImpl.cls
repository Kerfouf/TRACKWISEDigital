/*
* Created on Wed Oct 27, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public with sharing class ExternalLocationSelectorImpl extends fflib_SobjectSelector implements ExternalLocationSelector {

    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList =  new List<Schema.SObjectField> {
            Location__x.Id,
            Location__x.ExternalId,
            Location__x.Name__c,
            Location__x.VisitorAddressId__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Location__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'Location__x') {
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
        return Location__x.SObjectType;
    }

    public List<Location__x> selectById(Set<Id> recordIds) {
        return (List<Location__x>) selectSObjectsById(recordIds);
    }
}