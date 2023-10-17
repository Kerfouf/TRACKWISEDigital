/*
* Created on Thurs Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public interface CrmComplaintIntegrationService {
    List<Case__x> getExternalCasesByDateModified(DateTime asOf);
    List<Case__x> getExternalCasesByExternalId(Set<Id> externalIds);
    void upsertComplaints(List<Case__x> cases);
}