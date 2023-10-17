public with sharing class QualityEventClosureAutomationHelper {

    private static List<String> QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE = new List<String>{'Closed', 'Canceled'};
    
    public static final String  TASK_VALUE = 'MOVETOCLOSED';

    public static void manageClosureAutomation(Map<Id, Quality_Event__c> oldQualityEvents , Map<Id, Quality_Event__c> newQualityEvents){
        Map<Id, Quality_Event__c> listOfQualityEventsToVerify = new Map<Id, Quality_Event__c>();
        
        // Only the ones in the good status will be proceeded
        for(Id loopNewId : newQualityEvents.keySet()){
            Quality_Event__c loopNewQualityEvent = newQualityEvents.get(loopNewId);
            Quality_Event__c loopOldQualityEvent = oldQualityEvents.get(loopNewId);

            Boolean statusAsChanged = loopOldQualityEvent.CMPL123_WF_Status__c != loopNewQualityEvent.CMPL123_WF_Status__c;
            Boolean newStatusToTakeIntoAccount = statusAsChanged && loopNewQualityEvent.CMPL123_WF_Status__c == Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE;

            if(newStatusToTakeIntoAccount){
                listOfQualityEventsToVerify.put(loopNewId, loopNewQualityEvent);
            }
        }

        // Get related objects to see their status
        List<Quality_Event__c> qualityEventsWithRelatedObjects = retrieveQualityEventsRelatedObjectsAnyStatus(listOfQualityEventsToVerify.keySet());
        for(Quality_Event__c loopQualityEvent : qualityEventsWithRelatedObjects){
            Boolean allRelatedObjectsAreInTheGoodStatus = Helper.isEmpty(loopQualityEvent.QMS_Tasks__r);
            allRelatedObjectsAreInTheGoodStatus = allRelatedObjectsAreInTheGoodStatus && Helper.isEmpty(loopQualityEvent.Corrections__r);
            
            // If all closed / cancelled
            if(allRelatedObjectsAreInTheGoodStatus){
                // Update the record from Trigger.New, not the one we have requested
                Quality_Event__c loopQualityEventToUpdate = listOfQualityEventsToVerify.get(loopQualityEvent.Id);
                updateQualityEventForClosure(loopQualityEventToUpdate);                
            }
        }

    }

    public static void manageClosureAutomation(List<SOBject> objects){
        // In all objects, the lookup field is Quality_Event__c. If it's not the case, the below code has to be modified
        List<Id> idsOfRelatedQualityEvents = new List<Id>();
        for(SOBject childRecord : objects){
            Id qualityEventId = (Id) childRecord.get('Quality_Event__c');
            idsOfRelatedQualityEvents.add(qualityEventId);
        }

        List<Quality_Event__c> qeWithRelatedObjects = retrieveQualityEvents(idsOfRelatedQualityEvents);
        List<Quality_Event__c> qualityEventsToUpdate = new List<Quality_Event__c>();
        
        // Now verify that the Quality Event has no Related object Not in the closed status
        for(Quality_Event__c loopQualityEvent : qeWithRelatedObjects){
            Boolean allRelatedObjectsAreInTheGoodStatus = Helper.isEmpty(loopQualityEvent.QMS_Tasks__r);
            allRelatedObjectsAreInTheGoodStatus = allRelatedObjectsAreInTheGoodStatus && Helper.isEmpty(loopQualityEvent.Corrections__r);
            if(allRelatedObjectsAreInTheGoodStatus){
                updateQualityEventForClosure(loopQualityEvent);                
                qualityEventsToUpdate.add(loopQualityEvent);
            }
        }
        update qualityEventsToUpdate;
    }

    private static List<Quality_Event__c> retrieveQualityEvents(List<Id> qualityEventIds){
        return [
            SELECT
                Id,
                Original_Date_Closed__c,
                (SELECT Id FROM QMS_Tasks__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE AND Task_condition_for_the_parent__c = true),
                (SELECT Id FROM Corrections__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE)
            FROM
                Quality_Event__c
            WHERE
                Id IN :qualityEventIds
                AND
                CMPL123_WF_Status__c = :Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE
        ];
    }


    private static List<Quality_Event__c> retrieveQualityEventsRelatedObjectsAnyStatus(Set<Id> qualityEventIds){
        return [
            SELECT
                Id,
                (SELECT Id FROM QMS_Tasks__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE AND Task_condition_for_the_parent__c = true),
                (SELECT Id FROM Corrections__r WHERE CMPL123_WF_Status__c NOT IN :QMS_TASK_AND_CORRECTION_STATUSES_FOR_QE_CLOSURE)
            FROM
                Quality_Event__c
            WHERE
                Id IN :qualityEventIds                
        ];
    }

    private static void updateQualityEventForClosure(Quality_Event__c qualityEventToUpdate){
        qualityEventToUpdate.CMPL123Task_Key_Value__c = TASK_VALUE;
        DateTime today = System.now();

        qualityEventToUpdate.Date_Closed__c = today;

        // is it the first time it's closed? If yes, put an Original Date Closed
        if(qualityEventToUpdate.Original_Date_Closed__c == null){
            qualityEventToUpdate.Original_Date_Closed__c = today.date();
        }
    }
}