/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public with sharing class CrmCaseComments {

    private List<CaseComment__x> externalCaseComments; 
    private Map<Id, Case_Comment__c> caseCommentsByExternalId;

    public CrmCaseComments(List<CaseComment__x> externalCaseComments, Map<Id, Case_Comment__c> caseCommentsByExternalId) {
        this.externalCaseComments = externalCaseComments;
        this.caseCommentsByExternalId = caseCommentsByExternalId;
    }

    public List<Case_Comment__c> toCaseCommentsUpsertList() {
        
        List<Case_Comment__c> returnList = new List<Case_Comment__c>();
        
        for (CaseComment__x externalCaseComment : externalCaseComments) {
            Case_Comment__c existingCaseComment = caseCommentsByExternalId.get(externalCaseComment.ExternalId);

            if (existingCaseComment == null) {
                returnList.add(
                    new Case_Comment__c(
                        ComplaintId__r = new CMPL123CME__Complaint__c(BMX_Case_External_Id__c = externalCaseComment.ParentId__r.ExternalId),
                        CommentBody__c = externalCaseComment.CommentBody__c,
                        ExternalId__c = externalCaseComment.ExternalId,
                        BMX_User__c = externalCaseComment.CreatedById__c,
                        Created_Date__c = externalCaseComment.CreatedDate__c
                    )
                );
            }
            else {
                if (requiresUpdate(externalCaseComment, existingCaseComment)) {
                    // update existing
                    existingCaseComment.CommentBody__c = externalCaseComment.CommentBody__c;
                    existingCaseComment.BMX_User__c = externalCaseComment.CreatedById__c;
                    existingCaseComment.Created_Date__c = externalCaseComment.CreatedDate__c;
                    
                    // add to list
                    returnList.add(existingCaseComment);
                }
            }
        }

        return returnList;
    }

    private Boolean requiresUpdate(CaseComment__x externalCaseComment, Case_Comment__c existingCaseComment) {

        String externalCaseCommentBody = externalCaseComment.CommentBody__c == null ? '' : externalCaseComment.CommentBody__c;
        String existingCaseCommentBody = existingCaseComment.CommentBody__c == null ? '' : existingCaseComment.CommentBody__c;

        Boolean commentBodyChanged = externalCaseCommentBody.normalizeSpace() != existingCaseCommentBody.normalizeSpace();
        Boolean userChanged = externalCaseComment.CreatedById__c != existingCaseComment.BMX_User__c; // Shouldn't ever really happen
        Boolean dateChanged = externalCaseComment.CreatedDate__c != existingCaseComment.Created_Date__c; // Shouldn't ever really happen

        return commentBodyChanged || userChanged || dateChanged;
    }
}