/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalProductSelectorImpl extends fflib_SobjectSelector implements ExternalProductSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList =  new List<Schema.SObjectField> {
            Product2__x.Id,
            Product2__x.ExternalId,
            Product2__x.Name__c,
            Product2__x.ProductCode__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Product2__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'Product2__x') {
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
        return Product2__x.SObjectType;
    }

    public List<Product2__x> selectById(Set<Id> recordIds) {
        return (List<Product2__x>) selectSObjectsById(recordIds);
    }
}