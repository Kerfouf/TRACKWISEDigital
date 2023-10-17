/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalUserSelectorImpl extends fflib_SobjectSelector implements ExternalUserSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList = new List<Schema.SObjectField> {
            User__x.Id,
            User__x.ExternalId,
            User__x.Name__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('User__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'User__x') {
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
        return User__x.SObjectType;
    }

    public List<User__x> selectById(Set<Id> recordIds) {
        return (List<User__x>) selectSObjectsById(recordIds);
    }
}