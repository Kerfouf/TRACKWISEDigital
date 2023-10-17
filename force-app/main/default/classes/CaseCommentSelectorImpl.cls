/*
* Created on Fri Nov 19, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class CaseCommentSelectorImpl extends fflib_SObjectSelector implements CaseCommentSelector {
    
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Case_Comment__c.Id,
            Case_Comment__c.ExternalId__c,
            Case_Comment__c.CommentBody__c,
            Case_Comment__c.BMX_User__c,
            Case_Comment__c.Created_Date__c,
            Case_Comment__c.ComplaintId__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return Case_Comment__c.SObjectType;
    }

    public Map<Id, Case_Comment__c> selectCaseCommentByExternalId(Set<Id> externalCaseCommentExternalIds) {
        
        Map<Id, Case_Comment__c> returnMap = new Map<Id, Case_Comment__c>();
        String queryCondition = 'ExternalId__c IN :externalCaseCommentExternalIds';

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(queryCondition)
            .selectFields(getSObjectFieldList());

        fflib_SObjectSelector complaintSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType);
        complaintSelector.configureQueryFactoryFields(queryFactory, 'ComplaintId__r');

        for (Case_Comment__c caseComment : Database.query(queryFactory.toSOQL())) {
            returnMap.put(caseComment.ExternalId__c, caseComment);
        }

        return returnMap;
    }
}