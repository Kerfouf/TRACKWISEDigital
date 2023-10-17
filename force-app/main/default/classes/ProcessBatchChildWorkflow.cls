/**
 * Created by Jon.Astemborski on 12/12/2019.
 * Handler for batch workflow processing of Child records.
*/

public without Sharing class ProcessBatchChildWorkflow {
    private static final String WF_ACTION_API_NAME = 'CMPL123_WF_Action__c';
    private static final String WF_STATUS_API_NAME = 'CMPL123_WF_Status__c';
    private static final String ID_NAME = 'Id';
    private static final Integer firstChildIndex = 0;

    public ProcessBatchChildWorkflow() {}

    public static void processBatchChildWorkflows(String parentApiName, Map<Id,SObject> objectMap, Map<Id,SObject> objectOldMap){
        SObject currentObject;
        /** This batch process was only scoped for a single Parent record*/
        for ( Id objID : objectMap.keySet()) {
            currentObject = objectMap.get(objId);
        }

        if (!hasWorkflowActionBeenPerformed(currentObject, objectOldMap)) {
            return;
        }

        Integer childBatchSize = 10; // default batch size
        List<Workflow_Batch_Size__mdt> childBatchSizeList = [SELECT Batch_Size__c FROM Workflow_Batch_Size__mdt where MasterLabel =: parentApiName];
        if (!childBatchSizeList.isEmpty()){
            childBatchSize = childBatchSizeList.get(0).Batch_Size__c.intValue();
        }

        String parentWorkflowStatus = currentObject.get(WF_STATUS_API_NAME).toString();
        List<Batch_Child_Workflow_Mapping__mdt> workflowMappingList = [SELECT X123_Task_Key_Value__c, Parent_Field_API_Name__c, Child_Workflow_Status__c,
                                Parent_Object_API_Name__c, Parent_Workflow_Status__c, Child_Object_API_Name__c, Bypass_Validation_Rule__c, Child_Workflow_Keyvalue__c 
                                FROM Batch_Child_Workflow_Mapping__mdt
                                WHERE Parent_Object_API_Name__c =: parentApiName AND Parent_Workflow_Status__c =: parentWorkflowStatus];
        if ( !workflowMappingList.isEmpty()) {
            Id recordId = (Id)currentObject.get(ID_NAME);
            BatchChildWorkflowHandler wfHandler = new BatchChildWorkflowHandler(workflowMappingList, childBatchSize, recordId, firstChildIndex);
            Database.executeBatch(wfHandler, childBatchSize);
        }
    }

    @TestVisible
    private static Boolean hasWorkflowActionBeenPerformed(SObject currentObject ,Map<Id,SObject> objectOldMap){
        Boolean hasWorkflowActionBeenPerformed = true;
        // The record is newly created
        if (objectOldMap.get(currentObject.id).get(WF_ACTION_API_NAME) == null ) {
            if ( currentObject.get(WF_ACTION_API_NAME) == null) {
                hasWorkflowActionBeenPerformed = false;
            }
        }
        // The record was updated by did not progress states
        else if (objectOldMap.get(currentObject.id).get(WF_ACTION_API_NAME).toString() == currentObject.get(WF_ACTION_API_NAME).toString()) {
            hasWorkflowActionBeenPerformed = false;
        }
        return hasWorkflowActionBeenPerformed;
    }
}