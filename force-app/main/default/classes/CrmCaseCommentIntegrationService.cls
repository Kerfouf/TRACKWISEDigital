/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface CrmCaseCommentIntegrationService {
    List<CaseComment__x> getExternalCaseCommentsByDateModified(DateTime asOf);
    List<CaseComment__x> getExternalCaseCommentsByExternalIds(Set<Id> externalIds);
    void upsertCaseComments(List<CaseComment__x> externalCaseComments);
}