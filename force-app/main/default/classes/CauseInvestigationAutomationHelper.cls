public with sharing class CauseInvestigationAutomationHelper {
    private static List<String> QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE = new List<String>{'Closed', 'Canceled'};
    
    public static final String  TASK_VALUE = 'MOVETOCLOSED';

    public static void manageClosureAutomation(Map<Id, Cause_Investigation__c> oldCauseInvestigations, Map<Id, Cause_Investigation__c> newCauseInvestigations){
        Map<Id, Cause_Investigation__c> listOfCauseInvestigationsToVerify = new Map<Id, Cause_Investigation__c>();
        
        // Only the ones in the good status will be proceeded
        for(Id loopNewId : newCauseInvestigations.keySet()){
            Cause_Investigation__c loopNewCauseInvestigation = newCauseInvestigations.get(loopNewId);
            Cause_Investigation__c loopOldCauseInvestigation = oldCauseInvestigations.get(loopNewId);

            Boolean statusAsChanged = loopOldCauseInvestigation.CMPL123_WF_Status__c != loopNewCauseInvestigation.CMPL123_WF_Status__c;
            Boolean newStatusToTakeIntoAccount = statusAsChanged && loopNewCauseInvestigation.CMPL123_WF_Status__c == Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE;

            if(newStatusToTakeIntoAccount){
                listOfCauseInvestigationsToVerify.put(loopNewId, loopNewCauseInvestigation);
            }
        }

        // Get related objects to see their status
        List<Cause_Investigation__c> CauseInvestigationsWithRelatedObjects = retrieveCauseInvestigationsRelatedObjectsAnyStatus(listOfCauseInvestigationsToVerify.keySet());
        for(Cause_Investigation__c loopCauseInvestigation : CauseInvestigationsWithRelatedObjects){
            Boolean allRelatedObjectsAreInTheGoodStatus = Helper.isEmpty(loopCauseInvestigation.QMS_Tasks__r);
            allRelatedObjectsAreInTheGoodStatus = allRelatedObjectsAreInTheGoodStatus && Helper.isEmpty(loopCauseInvestigation.Corrections__r);
            
            // If all closed / cancelled
            if(allRelatedObjectsAreInTheGoodStatus){
                // Update the record from Trigger.New, not the one we have requested
                Cause_Investigation__c loopCauseInvestigationToUpdate = listOfCauseInvestigationsToVerify.get(loopCauseInvestigation.Id);
                updateCauseInvestigationForClosure(loopCauseInvestigationToUpdate);                
            }
        }

    }

    public static void manageClosureAutomation(List<SOBject> objects){
        // In all objects, the lookup field is Cause_Investigation__c. If it's not the case, the below code has to be modified
        List<Id> idsOfRelatedCauseInvestigations = new List<Id>();
        for(SOBject childRecord : objects){
            Id CauseInvestigationId = (Id) childRecord.get('Cause_Investigation__c');
            idsOfRelatedCauseInvestigations.add(CauseInvestigationId);
        }

        List<Cause_Investigation__c> qeWithRelatedObjects = retrieveCauseInvestigations(idsOfRelatedCauseInvestigations);
        List<Cause_Investigation__c> CauseInvestigationsToUpdate = new List<Cause_Investigation__c>();
        
        // Now verify that the CI has no Related object Not in the closed status
        for(Cause_Investigation__c loopCauseInvestigation : qeWithRelatedObjects){
            Boolean allRelatedObjectsAreInTheGoodStatus = Helper.isEmpty(loopCauseInvestigation.QMS_Tasks__r);
            allRelatedObjectsAreInTheGoodStatus = allRelatedObjectsAreInTheGoodStatus && Helper.isEmpty(loopCauseInvestigation.Corrections__r);
            if(allRelatedObjectsAreInTheGoodStatus){
                updateCauseInvestigationForClosure(loopCauseInvestigation);                
                CauseInvestigationsToUpdate.add(loopCauseInvestigation);
            }
        }
        update CauseInvestigationsToUpdate;
    }

    private static List<Cause_Investigation__c> retrieveCauseInvestigations(List<Id> CauseInvestigationIds){
        return [
            SELECT
                Id,
                Original_Date_Closed__c,
                (SELECT Id FROM QMS_Tasks__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE AND Task_condition_for_the_parent__c = true),
                (SELECT Id FROM Corrections__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE),
                (SELECT Id FROM Extension_Requests__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE)
            FROM
                Cause_Investigation__c
            WHERE
                Id IN :CauseInvestigationIds
                AND
                CMPL123_WF_Status__c = :Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE
        ];
    }


    private static List<Cause_Investigation__c> retrieveCauseInvestigationsRelatedObjectsAnyStatus(Set<Id> CauseInvestigationIds){
        return [
            SELECT
                Id,
                (SELECT Id FROM QMS_Tasks__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE AND Task_condition_for_the_parent__c = true),
                (SELECT Id FROM Corrections__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE)
            FROM
                Cause_Investigation__c
            WHERE
                Id IN :CauseInvestigationIds                
        ];
    }

    private static void updateCauseInvestigationForClosure(Cause_Investigation__c causeInvestigationToUpdate){
        causeInvestigationToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE;
        Date today = System.now().date();

        causeInvestigationToUpdate.Date_Closed__c = today;

        // is it the first time it's closed? If yes, put an Original Date Closed
        if(causeInvestigationToUpdate.Original_Date_Closed__c == null){
            causeInvestigationToUpdate.Original_Date_Closed__c = today;
        }
    }
}