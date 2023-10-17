@isTest
public with sharing class QualityEventClosureAutomationHelperTest {
    
    private static final String QUALITY_EVENT_TITLE = 'QUALITY_EVENT_TITLE';


    private static final String RELATED_RECORD_TITLE = 'RELATED_RECORD_TITLE';

    @TestSetup
    static void makeData(){
        Quality_Event__c qe = new Quality_Event__c();        
        qe.Title__c = QUALITY_EVENT_TITLE;
        insert qe;

        // Link objects
        Correction__c correction = new Correction__c();
        correction.CMPL123_WF_Status__c = 'TEST';
        correction.Quality_Event__c = qe.Id;
        correction.Title__c = RELATED_RECORD_TITLE;
        insert correction;

  
        QMS_Task__c task = new QMS_Task__c();
        task.CMPL123_WF_Status__c = 'TEST';
        task.Quality_Event__c = qe.Id;
        task.Title__c = RELATED_RECORD_TITLE;
        insert task;
    }

    @isTest
    public static void OnRelatedObjectsMove_QEHasMoved(){
        Quality_Event__c qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        qe.CMPL123_WF_Status__c = Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE;
        update qe;

        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :RELATED_RECORD_TITLE];
        correction.CMPL123_WF_Status__c = 'Closed';
        update correction;

        // Verify again
        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :RELATED_RECORD_TITLE];
        qmsTask.CMPL123_WF_Status__c = 'Canceled';
        update qmsTask;

        // Final verification
        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(QualityEventClosureAutomationHelper.TASK_VALUE, qe.CMPL123Task_Key_Value__c, 'At this step, the task value should be: ' + QualityEventClosureAutomationHelper.TASK_VALUE);
    }


    @isTest
    public static void OnQEMove_QEHasMoved(){
        Quality_Event__c qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];        
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :RELATED_RECORD_TITLE];
        correction.CMPL123_WF_Status__c = 'Closed';
        update correction;

        // Verify again
        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :RELATED_RECORD_TITLE];
        qmsTask.CMPL123_WF_Status__c = 'Canceled';
        update qmsTask;

        // At this step, the Quality Event have all child object as Closed/Canceled, but it is not in the good status itself
        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        // Now update the quality event, put it in the good status
        qe.CMPL123_WF_Status__c = Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE;
        update qe;

        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(QualityEventClosureAutomationHelper.TASK_VALUE, qe.CMPL123Task_Key_Value__c, 'At this step, the task value should be: ' + QualityEventClosureAutomationHelper.TASK_VALUE);
    }

    @isTest
    public static void QMS_Task_Task_Condition_Parent(){
        Quality_Event__c qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');

        qe.CMPL123_WF_Status__c = Constants.QUALITY_EVENT_STATUS_PENDING_CLOSURE;
        update qe;

        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :RELATED_RECORD_TITLE];
        correction.CMPL123_WF_Status__c = 'Closed';
        update correction;


        // Verify
        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(null, qe.CMPL123Task_Key_Value__c, 'At this step, no task valu should have been added');


        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :RELATED_RECORD_TITLE];
        qmsTask.Task_condition_for_the_parent__c = false;
        update qmsTask;

        qe = [SELECT Id, CMPL123Task_Key_Value__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        System.assertEquals(QualityEventClosureAutomationHelper.TASK_VALUE, qe.CMPL123Task_Key_Value__c, 'At this step, the task value should be: ' + QualityEventClosureAutomationHelper.TASK_VALUE);

    }

}