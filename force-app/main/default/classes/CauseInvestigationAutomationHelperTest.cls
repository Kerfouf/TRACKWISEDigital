@isTest
public with sharing class CauseInvestigationAutomationHelperTest {
    private static final String CAUSE_INVESTIGATION_TITLE = 'CAUSE_INVESTIGATION_TITLE';


    private static final String RELATED_RECORD_TITLE = 'RELATED_RECORD_TITLE';

    @TestSetup
    static void makeData(){
        Cause_Investigation__c ci = new Cause_Investigation__c();        
        ci.Title__c = CAUSE_INVESTIGATION_TITLE;
        insert ci;

        // Link objects
        Correction__c correction = new Correction__c();
        correction.CMPL123_WF_Status__c = 'TEST';
        correction.Cause_Investigation__c = ci.Id;
        correction.Title__c = RELATED_RECORD_TITLE;
        insert correction;

  
        QMS_Task__c task = new QMS_Task__c();
        task.CMPL123_WF_Status__c = 'TEST';
        task.Cause_Investigation__c = ci.Id;
        task.Title__c = RELATED_RECORD_TITLE;
        insert task;
    }

    @isTest
    public static void OnRelatedObjectsMove_CIHasMoved(){
        Cause_Investigation__c ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        ci.CMPL123_WF_Status__c = Constants.CAUSE_INVESTIGATION_STATUS_PENDING_CLOSURE;
        update ci;

        ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        System.assertEquals(null, ci.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :RELATED_RECORD_TITLE];
        correction.CMPL123_WF_Status__c = 'Closed';
        update correction;

        // Verify again
        ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        System.assertEquals(null, ci.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :RELATED_RECORD_TITLE];
        qmsTask.CMPL123_WF_Status__c = 'Canceled';
        update qmsTask;

        // Final verification
        ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        System.assertEquals(QualityEventClosureAutomationHelper.TASK_VALUE, ci.CMPL123Task_Key_Value__c, 'At this step, the task value should be: ' + QualityEventClosureAutomationHelper.TASK_VALUE);
    }


    @isTest
    public static void OnCIMove_CIHasMoved(){
        Cause_Investigation__c ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];        
        System.assertEquals(null, ci.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :RELATED_RECORD_TITLE];
        correction.CMPL123_WF_Status__c = 'Closed';
        update correction;

        // Verify again
        ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        System.assertEquals(null, ci.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :RELATED_RECORD_TITLE];
        qmsTask.CMPL123_WF_Status__c = 'Canceled';
        update qmsTask;

        // At this step, the Quality Event have all child object as Closed/Canceled, but it is not in the good status itself
        ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        System.assertEquals(null, ci.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        // Now update the cause investigation, put it in the good status
        ci.CMPL123_WF_Status__c = Constants.CAUSE_INVESTIGATION_STATUS_PENDING_CLOSURE;
        update ci;

        ci = [SELECT Id, CMPL123Task_Key_Value__c FROM Cause_Investigation__c WHERE Title__c = :CAUSE_INVESTIGATION_TITLE];
        System.assertEquals(QualityEventClosureAutomationHelper.TASK_VALUE, ci.CMPL123Task_Key_Value__c, 'At this step, the task value should be: ' + QualityEventClosureAutomationHelper.TASK_VALUE);
    }
}