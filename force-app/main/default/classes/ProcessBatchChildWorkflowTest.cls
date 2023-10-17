@IsTest
public class ProcessBatchChildWorkflowTest {
    @testSetup static void setup(){
        Id ccRecType = Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = TestSetup.createCC(true, ccRecType);
    }

    @IsTest static void processBatchChildWorkflows_processChildWorkflow(){
        CMPL123QMS__Change_Control__c cc = [select id, CMPL123_WF_Action__c, CMPL123_WF_Status__c from CMPL123QMS__Change_Control__c limit 1];
        cc.CMPL123_WF_Status__c = 'Open';
        update cc;
        TestSetup.createAIWithCC(true, cc.id);

        Map<Id,SObject> objectOldMap = new Map<Id,SObject>();
        objectOldMap.put(cc.id, cc);
        CMPL123QMS__Change_Control__c cc2 = cc.clone(true,true);
        cc2.CMPL123_WF_Status__c = 'Closed - Canceled';
        update cc2;
        Map<Id,SObject> objectMap = new Map<Id,SObject>();
        objectMap.put(cc2.id, cc);
        ProcessBatchChildWorkflow.processBatchChildWorkflows('CMPL123QMS__Change_Control__c', objectMap, objectOldMap);
    }

    @IsTest static void processBatchChildWorkflows_noWorkflowActionPerformed(){
        CMPL123QMS__Change_Control__c cc = [select id, CMPL123_WF_Action__c, CMPL123_WF_Status__c from CMPL123QMS__Change_Control__c limit 1];
        cc.CMPL123_WF_Status__c = 'Open';
        update cc;
        Map<Id,SObject> objectOldMap = new Map<Id,SObject>();
        objectOldMap.put(cc.id, cc);
        Map<Id,SObject> objectMap = new Map<Id,SObject>();
        objectMap.put(cc.id, cc);
        TestSetup.createAIWithCC(true, cc.id);
        ProcessBatchChildWorkflow.processBatchChildWorkflows('CMPL123QMS__Change_Control__c', objectMap, objectOldMap);
    }

    @IsTest static void hasWorkflowActionBeenPerformed_newRecord(){
        User u = TestSetup.createUser(true);
        System.RunAs(u){    
            CMPL123QMS__Change_Control__c cc = [select id, CMPL123_WF_Action__c, CMPL123_WF_Status__c from CMPL123QMS__Change_Control__c limit 1];
            Map<Id,SObject> objectOldMap = new Map<Id,SObject>();
            objectOldMap.put(cc.id, cc);
            Boolean hasWorkflowActionBeenPerformed = ProcessBatchChildWorkflow.hasWorkflowActionBeenPerformed(cc, objectOldMap);
            System.assertEquals(false, hasWorkflowActionBeenPerformed);
        }
    }

    @IsTest static void hasWorkflowActionBeenPerformed_fieldLevelUpdate(){
        User u = TestSetup.createUser(true);
        System.RunAs(u){
            CMPL123QMS__Change_Control__c cc = [select id, CMPL123_WF_Action__c, CMPL123_WF_Status__c from CMPL123QMS__Change_Control__c limit 1];
            cc.CMPL123_WF_Status__c = 'Open';
            Map<Id,SObject> objectOldMap = new Map<Id,SObject>();
            objectOldMap.put(cc.id, cc);
            Boolean hasWorkflowActionBeenPerformed = ProcessBatchChildWorkflow.hasWorkflowActionBeenPerformed(cc, objectOldMap);
            System.assertEquals(false, hasWorkflowActionBeenPerformed);
        }
    }

    @IsTest static void hasWorkflowActionBeenPerformed_workflowUpdate(){
        User u = TestSetup.createUser(true);
        System.RunAs(u){
            CMPL123QMS__Change_Control__c cc = [select id, CMPL123_WF_Action__c, CMPL123_WF_Status__c from CMPL123QMS__Change_Control__c limit 1];
            cc.CMPL123_WF_Status__c = 'Open';
            Map<Id,SObject> objectOldMap = new Map<Id,SObject>();
            objectOldMap.put(cc.id, cc);
            CMPL123QMS__Change_Control__c cc2 = cc.clone(true, true);
            cc2.CMPL123_WF_Status__c = 'Closed - Canceled';
            cc2.CMPL123_WF_Action__c = 'Cancel';
            update cc2;
            Boolean hasWorkflowActionBeenPerformed = ProcessBatchChildWorkflow.hasWorkflowActionBeenPerformed(cc2, objectOldMap);
            System.assertEquals(true, hasWorkflowActionBeenPerformed);
        }
    }
}