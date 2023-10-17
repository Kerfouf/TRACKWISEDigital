/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ComplaintSelectorImpl extends fflib_SobjectSelector implements ComplaintSelector {
    
    /*Required by fflib*/
    // Dynamically build field list from custom metadata type
    public List<Schema.SObjectField> getSObjectFieldList() {
        
        List<Schema.SObjectField> fieldList = new List<Schema.SObjectField> { 
            CMPL123CME__Complaint__c.Id,
            CMPL123CME__Complaint__c.BMX_Case_External__c,
            CMPL123CME__Complaint__c.CMPL123CME__CMPL123_WF_Status__c
        };

        Map<String, Schema.SObjectField> fieldMap = Schema.getGlobalDescribe().get('CMPL123CME__Complaint__c').getDescribe().fields.getMap();

        for (CRM_TWD_Complaint_Creation__mdt config : CRM_TWD_Complaint_Creation__mdt.getAll().values()) {
            Schema.SObjectField field = fieldMap.get(config.TWD_Field_API_Name__c);
            if (field != null) {
                fieldList.add(fieldMap.get(config.TWD_Field_API_Name__c));
            }
        }

        return fieldList;
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return CMPL123CME__Complaint__c.SObjectType;
    }

    public List<CMPL123CME__Complaint__c> selectByExternalCaseId(Set<Id> externalCaseIds) {
        fflib_QueryFactory queryFactory = newQueryFactory().setCondition(
            'BMX_Case_External__c IN :externalCaseIds'
        );
        queryFactory.selectFields(getSObjectFieldList());
        return Database.query(queryFactory.toSOQL());
    }

    /* 
    * Select Potentially Reportable Events by Date Last Modified 
    */
    public List<CMPL123CME__Complaint__c> selectPREsByDateModified(DateTime asOf) {
        
        Id globalAssessmentRecordTypeId = Schema.SObjectType.CMPL123CME__Questionnaire__c.getRecordTypeInfosByName().get('Global Assessment').getRecordTypeId();

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(
                'LastModifiedDate >= :asOf ' + 
                'AND BMX_PRE__c = \'Yes\''
            )
            .selectField(CMPL123CME__Complaint__c.Id);

            fflib_QueryFactory globalAssessmentQueryFactory = queryFactory.subselectQuery('CMPL123CME__Questionnaires__r')
                .selectField(CMPL123CME__Questionnaire__c.Name)
                .selectField(CMPL123CME__Questionnaire__c.BMX_Case_External__c)
                .setCondition('RecordTypeId = :globalAssessmentRecordTypeId')
                .setLimit(1);
        
            return Database.query(queryFactory.toSOQL());
    }

    /* 
    * Select Potentially Reportable Events by External Ids 
    */
    public List<CMPL123CME__Complaint__c> selectPREsByExternalIds(Set<Id> externalIds) {
        
        Id globalAssessmentRecordTypeId = Schema.SObjectType.CMPL123CME__Questionnaire__c.getRecordTypeInfosByName().get('Global Assessment').getRecordTypeId();

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(
                'BMX_PRE__c = \'Yes\'' + 
                'AND BMX_Case_External__c IN :externalIds'
            )
            .selectField(CMPL123CME__Complaint__c.Id);

            fflib_QueryFactory globalAssessmentQueryFactory = queryFactory.subselectQuery('CMPL123CME__Questionnaires__r')
                .selectField(CMPL123CME__Questionnaire__c.Name)
                .selectField(CMPL123CME__Questionnaire__c.BMX_Case_External__c)
                .setCondition('RecordTypeId = :globalAssessmentRecordTypeId')
                .setLimit(1);
        
            return Database.query(queryFactory.toSOQL());
    }
}