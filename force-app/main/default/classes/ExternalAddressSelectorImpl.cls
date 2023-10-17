/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalAddressSelectorImpl extends fflib_SobjectSelector implements ExternalAddressSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList = new List<Schema.SObjectField> {
            Address__x.Id,
            Address__x.ExternalId
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Address__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'Address__x') {
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
        return Address__x.SObjectType;
    }

    public List<Address__x> selectById(Set<Id> recordIds) {
        return (List<Address__x>) selectSObjectsById(recordIds);
    }
}