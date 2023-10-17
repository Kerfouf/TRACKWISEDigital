public with sharing class CAPA_AutomationForActionsCompletedHelper {

    

    private static final List<String> CLOSED_CANCELED = new List<String>{'Canceled','Closed'};

    public static String CAPA_TFUKV_EFFECTIVENESS_CHECK = 'MOVE_TO_EFFECTIVENESS_CHECK';

    /*This method is called from CAPA Trigger: in case if a CAPA arrives to the status and all QMS Task, Correction, CAPA Action are Closed/Canceled **/
    public static void onCAPAUpdateMoveToEffectivenessCheckIfNeeded(Map<Id, CMPL123QMS__CAPA__c> capas){  
        List<CMPL123QMS__CAPA__c> capaWithRelatedObjects = getCAPAPopulatedWithChildValues(capas.keySet());
        
        for(CMPL123QMS__CAPA__c capa : capaWithRelatedObjects){            
            Boolean needsToBeUpdated = allRelatedObjectAreClosedCanceled(capa);
            // Get the status from the parameter Map                        
            CMPL123QMS__CAPA__c currentTransactionCapa = capas.get(capa.Id);            
            needsToBeUpdated = needsToBeUpdated && currentTransactionCapa.CMPL123_WF_Status__c == Constants.CAPA_STATUS_ACTIONS_IMPLEMENTATION;
            if(needsToBeUpdated){
                currentTransactionCapa.CMPL123Task_Key_Value__c = CAPA_TFUKV_EFFECTIVENESS_CHECK;
            }
        }
    }

    public static void moveToEffectivenessCheckIfNeeded(List<SObject> relatedObjects){        
        List<Id> extractedCapaIds = new List<Id>();
        for(SObject loopObject : relatedObjects){
            // All fields are named Capa__c. In case the name of the object relationship to CAPA is NOT Capa__c, please modify
            Id capaId = (Id) loopObject.get('Capa__c');
            extractedCapaIds.add(capaId);
        }
        moveToEffectivenessCheckIfNeeded(extractedCapaIds);
    }

    


    private static void moveToEffectivenessCheckIfNeeded(List<Id> capaIds){
        List<CMPL123QMS__CAPA__c> capasWithRelatedObjects = getCAPAPopulatedWithChildValues_RestrictedToImplemStatus(capaIds);
        List<CMPL123QMS__CAPA__c> capasToMove = new List<CMPL123QMS__CAPA__c>();
        for(CMPL123QMS__CAPA__c capa : capasWithRelatedObjects){            
            if(allRelatedObjectAreClosedCanceled(capa)){
                capa.CMPL123Task_Key_Value__c = CAPA_TFUKV_EFFECTIVENESS_CHECK;
                capa.Effectiveness_Check_Start_Date__c = Date.today();
                capasToMove.add(capa);
            }
        }
        update capasToMove;        
    }

    private static Boolean allRelatedObjectAreClosedCanceled(CMPL123QMS__CAPA__c capa){
        Boolean moveTheCAPAToNextStep = Helper.isEmpty(capa.Corrections__r);
        moveTheCAPAToNextStep = moveTheCAPAToNextStep && Helper.isEmpty(capa.QMS_Tasks__r);
        moveTheCAPAToNextStep = moveTheCAPAToNextStep && Helper.isEmpty(capa.CAPA_Actions__r);
        return moveTheCAPAToNextStep;
    }
    

    private static List<CMPL123QMS__CAPA__c> getCAPAPopulatedWithChildValues_RestrictedToImplemStatus(List<Id> capaIds){
        return [
            SELECT
                Id,
                (SELECT Id FROM Corrections__r WHERE CMPL123_WF_Status__c NOT IN :CLOSED_CANCELED),
                (SELECT Id FROM QMS_Tasks__r WHERE CMPL123_WF_Status__c NOT IN :CLOSED_CANCELED AND Task_condition_for_the_parent__c = true),
                (SELECT Id FROM CAPA_Actions__r WHERE CMPL123_WF_Status__c NOT IN :CLOSED_CANCELED)
            FROM
                CMPL123QMS__CAPA__c
            WHERE
                Id IN : capaIds
                AND
                CMPL123_WF_Status__c = :Constants.CAPA_STATUS_ACTIONS_IMPLEMENTATION
        ];
    }

    private static List<CMPL123QMS__CAPA__c> getCAPAPopulatedWithChildValues(Set<Id> capaIds){
        return [
            SELECT
                Id,
                (SELECT Id FROM Corrections__r WHERE CMPL123_WF_Status__c NOT IN :CLOSED_CANCELED),
                (SELECT Id FROM QMS_Tasks__r WHERE CMPL123_WF_Status__c NOT IN :CLOSED_CANCELED AND Task_condition_for_the_parent__c = true),
                (SELECT Id FROM CAPA_Actions__r WHERE CMPL123_WF_Status__c NOT IN :CLOSED_CANCELED)
            FROM
                CMPL123QMS__CAPA__c
            WHERE
                Id IN : capaIds                
        ];
    }
}