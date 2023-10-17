/*
* Created on Thurs Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalAccountSelectorImpl extends fflib_SobjectSelector implements ExternalAccountSelector {
    
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        List<Schema.SObjectField> fieldList = new List<Schema.SObjectField> {
            Account__x.Id,
            Account__x.ExternalId,
            Account__x.Global_Reporting_Hierarchy_Level_1_c__c,
            Account__x.Global_Reporting_Hierarchy_Level_2_c__c,
            Account__x.Global_Reporting_Hierarchy_Level_3_c__c,
            Account__x.Key_Account_Hierarchy_c__c,
            Account__x.Pricing_Hierarchy_c__c,
            Account__x.Pricing_Hierarchy_2_c__c,
            Account__x.RecordTypeId__c,
            Account__x.Reporting_Hierarchy_c__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('Account__x').getDescribe().fields.getMap();
        
        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            if (config.Object_API_Name__c == 'Account__x') {
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
        return Account__x.SObjectType;
    }

    public List<Account__x> selectById(Set<Id> recordIds) {
        return (List<Account__x>) selectSObjectsById(recordIds);
    }
}