public with sharing class QualityEventHelper {
    public static void verifyImpactedList(Map<Id, Quality_Event__c> qualityEvents){

        List<Id> listOfQaGoingToEvalComplete = new List<Id>();
        for(Id loopQEId : qualityEvents.keySet()){
            Quality_Event__c loopQualityEvent = qualityEvents.get(loopQEId);
            if(loopQualityEvent.CMPL123_WF_Action__c == 'Evaluation Complete'){
                listOfQaGoingToEvalComplete.add(loopQEId);
            }
        }

        List<Quality_Event__c> qualityEventsWithImpactedLots = [
            SELECT
                ID,
                (SELECT NAME FROM Related_Impacted_Lots__r WHERE (Quantity_Inspected_Tested__c = null OR Quantity_Failed__c = null OR Dispositions__c = null))
            FROM
                Quality_Event__c
            WHERE
                ID IN :listOfQaGoingToEvalComplete
        ];
        for(Quality_Event__c loopQualityEvent : qualityEventsWithImpactedLots){
            if(!Helper.isEmpty(loopQualityEvent.Related_Impacted_Lots__r)){
                Quality_Event__c transactionRecord = qualityEvents.get(loopQualityEvent.Id);
                transactionRecord.addError(Label.IMPACTED_LOT_MANDATORY_FIELDS_EVAL_COMPLETE);
            }
        }
    }
}