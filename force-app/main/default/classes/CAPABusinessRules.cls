public with sharing class CAPABusinessRules {
    private static List<String> CAPA_ACTION_STATUS_TO_ALLOW_CLOSE_CAPA = new List<String>{Constants.CAPA_ACTION_STATUS_CANCELED, Constants.CAPA_ACTION_STATUS_INITIATED};
    
    public static void verify_Related_Capa_Actions(Map<Id, CMPL123QMS__CAPA__c> oldCapas, Map<Id, CMPL123QMS__CAPA__c> newCapas){
        verify_SentForApproval(oldCapas,newCapas);
        verify_Canceled(oldCapas,newCapas);
    }

    private static void verify_Canceled(Map<Id, CMPL123QMS__CAPA__c> oldCapas, Map<Id, CMPL123QMS__CAPA__c> newCapas){
        // Verify the records that are cancelled
        Map<String, CMPL123QMS__CAPA__c> filteredRecordCancelled = new Map<String, CMPL123QMS__CAPA__c>();
        for(Id loopId : newCapas.keySet()){
            CMPL123QMS__CAPA__c loopNewCAPA = newCapas.get(loopId);
            CMPL123QMS__CAPA__c loopOldCAPA = oldCapas.get(loopId);
            
            if(isCancelled(loopOldCAPA, loopNewCAPA)){
                filteredRecordCancelled.put(loopId, loopNewCAPA);
            }
        }
        List<CMPL123QMS__CAPA__c> capaWithCapaActions = [
                                                            SELECT
                                                                Id,
                                                                (Select Id FROM CAPA_Actions__r WHERE CMPL123_WF_Status__c NOT IN :CAPA_ACTION_STATUS_TO_ALLOW_CLOSE_CAPA),
                                                                Name
                                                            FROM
                                                                CMPL123QMS__CAPA__c
                                                            WHERE
                                                                Id IN :filteredRecordCancelled.keySet()
        ];

        for(CMPL123QMS__CAPA__c loopCapa : capaWithCapaActions){
            if(!Helper.isEmpty(loopCapa.CAPA_Actions__r)){
                CMPL123QMS__CAPA__c recordToHandleError = newCapas.get(loopCapa.Id);
                recordToHandleError.addError(Label.CAPA_PREVENT_CANCELLATION_ONGOING_CHILDREN);
            }            
        }
    }

    private static void verify_SentForApproval(Map<Id, CMPL123QMS__CAPA__c> oldCapas, Map<Id, CMPL123QMS__CAPA__c> newCapas){        
        
        // Verify the records that are sent to approval
        Map<String, CMPL123QMS__CAPA__c> filteredRecordedSentToApproval = new Map<String, CMPL123QMS__CAPA__c>();
        for(Id loopId : newCapas.keySet()){
            CMPL123QMS__CAPA__c loopNewCAPA = newCapas.get(loopId);
            CMPL123QMS__CAPA__c loopOldCAPA = oldCapas.get(loopId);
            
            if(isSentToApproval(loopOldCAPA, loopNewCAPA)){
                filteredRecordedSentToApproval.put(loopId, loopNewCAPA);
            }
        }
        List<CMPL123QMS__CAPA__c> capaWithCapaActions = [
                                                            SELECT
                                                                Id,
                                                                (Select Id,Name, Assigned_To__r.IsActive, Assigned_To__r.Name, Due_Date__c FROM CAPA_Actions__r WHERE CMPL123_WF_Status__c != :Constants.CAPA_ACTION_STATUS_CANCELED),
                                                                Name
                                                            FROM
                                                                CMPL123QMS__CAPA__c
                                                            WHERE
                                                                Id IN :filteredRecordedSentToApproval.keySet()
                                                        ];
        // Now Verify all the CAPA have a CAPA Action
        for(CMPL123QMS__CAPA__c loopCapa : capaWithCapaActions){
            CMPL123QMS__CAPA__c recordToHandleError = newCapas.get(loopCapa.Id);

            if(loopCapa.CAPA_Actions__r == null || loopCapa.CAPA_Actions__r.isEmpty()){                                
                String label = Label.CAPA_NO_ACTION;
                recordToHandleError.addError(label);
                continue;
            }
            for(CAPA_Action__c loopCapaAction : loopCapa.CAPA_Actions__r){
                if(loopCapaAction.Assigned_To__c == null){

                    List<String> parameters = new List<String>{loopCapaAction.Name};
                    String label = Label.CAPA_ACTION_NO_ASSIGNEE;
                    String errorMessage = String.format(label, parameters);

                    recordToHandleError.addError(errorMessage);
                    continue;
                }
                if(!loopCapaAction.Assigned_To__r.IsActive){

                    List<String> parameters = new List<String>{loopCapaAction.Name, loopCapaAction.Assigned_To__r.Name};
                    String label = Label.CAPA_ACTION_INACTIVE_ASSIGNEE;
                    String errorMessage = String.format(label, parameters);

                    recordToHandleError.addError(errorMessage);                    
                    continue;
                }
                if(loopCapaAction.Due_Date__c == null){
                    List<String> parameters = new List<String>{loopCapaAction.Name};
                    String label = Label.CAPA_ACTION_NO_DUE_DATE;
                    String errorMessage = String.format(label, parameters);
                    recordToHandleError.addError(errorMessage);
                }
            }
        }
    }



    private static Boolean isSentToApproval(CMPL123QMS__CAPA__c oldCapa, CMPL123QMS__CAPA__c newCapa){
        if(oldCapa.CMPL123_WF_Status__c == newCapa.CMPL123_WF_Status__c){
            // Did not move status, reject
            return false;
        }
        return Constants.CAPA_APPROVAL_STATUSES_LIST.contains(newCapa.CMPL123_WF_Status__c);
    }


    private static Boolean isCancelled(CMPL123QMS__CAPA__c oldCapa, CMPL123QMS__CAPA__c newCapa){
        if(oldCapa.CMPL123_WF_Action__c == newCapa.CMPL123_WF_Action__c){
            // It's not a Cancell action
            return false;
        }
        return Constants.CAPA_WF_ACTION_CANCEL == newCapa.CMPL123_WF_Action__c;
    }
}