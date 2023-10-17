/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ComplaintConfigSelectorImpl extends fflib_SobjectSelector implements ComplaintConfigSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            CRM_TWD_Complaint_Creation__mdt.CRM_Field_API_Name__c,
            CRM_TWD_Complaint_Creation__mdt.Object_API_Name__c,
            CRM_TWD_Complaint_Creation__mdt.TWD_Field_API_Name__c,
            CRM_TWD_Complaint_Creation__mdt.Relationship_Name__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return CRM_TWD_Complaint_Creation__mdt.SObjectType;
    }

    public List<CRM_TWD_Complaint_Creation__mdt> selectAll() {
        fflib_QueryFactory queryFactory = newQueryFactory().selectFields(getSObjectFieldList());
        return Database.query(queryFactory.toSOQL());
    }
}