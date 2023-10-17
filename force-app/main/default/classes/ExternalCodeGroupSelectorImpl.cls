/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalCodeGroupSelectorImpl extends fflib_SobjectSelector implements ExternalCodeGroupSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList = new List<Schema.SObjectField> {
            CodeGroup_c__x.Id,
            CodeGroup_c__x.ExternalId,
            CodeGroup_c__x.Name__c,
            CodeGroup_c__x.Code_c__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('CodeGroup_c__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'CodeGroup_c__x') {
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
        return CodeGroup_c__x.SObjectType;
    }

    public List<CodeGroup_c__x> selectById(Set<Id> recordIds) {
        return (List<CodeGroup_c__x>) selectSObjectsById(recordIds);
    }
}