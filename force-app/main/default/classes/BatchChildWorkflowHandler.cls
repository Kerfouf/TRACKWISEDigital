/**
 * Created by Jon.Astemborski on 12/12/2019.
 * Batches child records of parent by type then assigns the respective Task Key Value in order to progess the child record's
 * workflow.
*/

global class BatchChildWorkflowHandler implements Database.Batchable<sObject> {

    Integer currentChildIndex;
    Integer childBatchSize;
    @TestVisible
    Id parentRecordId;
    List<Batch_Child_Workflow_Mapping__mdt> workflowMappingList;
    Batch_Child_Workflow_Mapping__mdt currentWorkflowMapping;

    global BatchChildWorkflowHandler(){}

    global BatchChildWorkflowHandler(List<Batch_Child_Workflow_Mapping__mdt> workflowMappingList, Integer childBatchSize, Id parentRecordId, Integer currentChildIndex) {
        this.workflowMappingList = workflowMappingList;
        this.childBatchSize = childBatchSize;
        this.parentRecordId = parentRecordId;
        this.currentChildIndex = currentChildIndex;
        this.currentWorkflowMapping = workflowMappingList.get(currentChildIndex);
    }

    @TestVisible
    private String createQuery(Batch_Child_Workflow_Mapping__mdt workflowMapping){
        String performedByAutomation = '';
        String wfKeyValue = '';
        if ( workflowMapping.Bypass_Validation_Rule__c)
        {
            performedByAutomation = ' Performed_By_Automation__c, ';
        }

        if (workflowMapping.Child_Workflow_Keyvalue__c != null) {
            wfKeyValue = 'AND CMPL123Rule_Key_Value__c = ' + '\'' + String.valueOf(workflowMapping.Child_Workflow_Keyvalue__c)  +'\'';
        }

        return 'SELECT ID, CMPL123Task_Key_Value__c, CMPL123_WF_Status__c, CMPL123Rule_Key_Value__c, ' + performedByAutomation + workflowMapping.Parent_Field_API_Name__c + 
        ' FROM ' + workflowMapping.Child_Object_API_Name__c + 
        ' WHERE CMPL123_WF_Status__c =\'' +  workflowMapping.Child_Workflow_Status__c + '\' AND ' + 
        workflowMapping.Parent_Field_API_Name__c + ' = \'' + parentRecordId + '\'' + wfKeyValue;
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        if ( !workflowMappingList.isEmpty()) {
            String query = createQuery(currentWorkflowMapping);
            System.debug('query ' + query);
            return Database.getQueryLocator(query);
        }
        return null;
    }

    global void execute(Database.BatchableContext BC, List<SObject> childObjectList) {
        for ( SObject childObject : childObjectList ) {
            String childWorkflowStatus = childObject.get('CMPL123_WF_Status__c').toString();
            String childWfKeyValue ='';
            String childKeyValueMapping = '';

            if (childObject.get('CMPL123Rule_Key_Value__c') != null) {
               childWfKeyValue = childObject.get('CMPL123Rule_Key_Value__c').toString();
            }
            if ( currentWorkflowMapping.Child_Workflow_Keyvalue__c != null ){
                childKeyValueMapping = currentWorkflowMapping.Child_Workflow_Keyvalue__c;
            }

            system.debug(' child key map; ' + childKeyValueMapping);
            system.debug(' child wf key; ' + childWfKeyValue);

            if(childWorkflowStatus.equals(currentWorkflowMapping.Child_Workflow_Status__c) && childKeyValueMapping.equals(childWfKeyValue)) {
                if ( currentWorkflowMapping.Bypass_Validation_Rule__c) {
                    childObject.put('Performed_By_Automation__c', currentWorkflowMapping.Bypass_Validation_Rule__c);
                }
                childObject.put('CMPL123Task_Key_Value__c', currentWorkflowMapping.X123_Task_Key_Value__c);
                System.debug('Updating ' + currentWorkflowMapping.Child_Object_API_Name__c + ': '+ childObject.id);
            }
        }
       update childObjectList;
    }

    global void finish(Database.BatchableContext BC) {
        if ( currentChildIndex++ != workflowMappingList.size() - 1){
            System.debug('current index: ' + currentChildIndex);
            BatchChildWorkflowHandler wfHandler = new BatchChildWorkflowHandler(workflowMappingList, childBatchSize, parentRecordId, currentChildIndex);
            Database.executeBatch(wfHandler, childBatchSize);
        }
   }
}