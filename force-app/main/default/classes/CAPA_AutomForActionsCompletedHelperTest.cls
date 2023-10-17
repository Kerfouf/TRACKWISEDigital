@isTest
public with sharing class CAPA_AutomForActionsCompletedHelperTest {
    private static final String CAPA_TITLE = 'CAPA_TITLE';

    private static final String CAPA_TO_MOVE_TITLE = 'CAPA_TO_MOVE_TITLE';
    
    private static final String CORRECTION_TITLE = 'CORRECTION_TITLE';
    private static final String CAPA_ACTION_TITLE = 'CAPA_ACTION_TITLE';
    private static final String QMS_TASK_TITLE = 'QMS_TASK_TITLE';    
    
    @TestSetup
    static void makeData(){
        
        // CAPA
        CMPL123QMS__CAPA__c capaToWorkOn = new CMPL123QMS__CAPA__c();
        capaToWorkOn.Title__c = CAPA_TITLE;
        capaToWorkOn.CMPL123_WF_Status__c = 'Actions Implementation';
        insert capaToWorkOn;
       

        // Correction
        Correction__c correction = new Correction__c();        
        correction.Capa__c = capaToWorkOn.Id;
        correction.Title__c = CORRECTION_TITLE;
        insert correction;

        

        // CAPA Action
        CAPA_Action__c capaAction = new CAPA_Action__c();        
        capaAction.Capa__c = capaToWorkOn.Id;
        capaAction.Title__c = CAPA_ACTION_TITLE;
        insert capaAction;


        // QMS_Task__c
        QMS_Task__c qmsTask1 = new QMS_Task__c();        
        qmsTask1.Capa__c = capaToWorkOn.Id;
        qmsTask1.Title__c = QMS_TASK_TITLE;
        insert qmsTask1;

        // >>>>>>> BELOW IN CASE IT IS THE CAPA THAT IS GOING FORWARD

        // CAPA
        CMPL123QMS__CAPA__c capaToMoveInTest = new CMPL123QMS__CAPA__c();
        capaToMoveInTest.Title__c = CAPA_TO_MOVE_TITLE;        
        insert capaToMoveInTest;


        // CAPA Action
        CAPA_Action__c capaActionWithGoodStatus = new CAPA_Action__c();        
        capaActionWithGoodStatus.Capa__c = capaToMoveInTest.Id;
        capaActionWithGoodStatus.Title__c = 'TITLE_FOR_DA_GOOD_CAPA_ACTION';
        capaActionWithGoodStatus.CMPL123_WF_Status__c = 'Closed';
        insert capaActionWithGoodStatus;

    }


    @isTest
    public static void verifyTaskValueIsAdded_CORRECTIONS(){
        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :CORRECTION_TITLE];        
        CAPA_Action__c capaAction = [SELECT Id FROM CAPA_Action__c WHERE Title__c = :CAPA_ACTION_TITLE];
        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :QMS_TASK_TITLE];

        // Move all to Closed
        correction.CMPL123_WF_Status__c = 'Closed';
        capaAction.CMPL123_WF_Status__c = 'Closed';
        qmsTask.CMPL123_WF_Status__c = 'Closed';

        // Correction trigger will be tested since it is the last to be updated
        update capaAction;
        update qmsTask;
        update correction;
        
        CMPL123QMS__CAPA__c capa = [SELECT Id, CMPL123Task_Key_Value__c FROM CMPL123QMS__CAPA__c WHERE Title__c = :CAPA_TITLE];        
        System.assertEquals(CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK, capa.CMPL123Task_Key_Value__c, 'The Key should be: ' + CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK);        
    }


    @isTest
    public static void verifyTaskValueIsAdded_QMSTask(){
        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :CORRECTION_TITLE];        
        CAPA_Action__c capaAction = [SELECT Id FROM CAPA_Action__c WHERE Title__c = :CAPA_ACTION_TITLE];
        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :QMS_TASK_TITLE];

        // Move all to Closed
        correction.CMPL123_WF_Status__c = 'Closed';
        capaAction.CMPL123_WF_Status__c = 'Closed';
        qmsTask.CMPL123_WF_Status__c = 'Closed';

        // QMS Task trigger will be tested since it is the last to be updated
        update capaAction;        
        update correction;
        update qmsTask;
        
        CMPL123QMS__CAPA__c capa = [SELECT Id, CMPL123Task_Key_Value__c FROM CMPL123QMS__CAPA__c WHERE Title__c = :CAPA_TITLE];        
        System.assertEquals(CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK, capa.CMPL123Task_Key_Value__c, 'The Key should be: ' + CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK);        
    }


    @isTest
    public static void verifyTaskValueIsAdded_CAPAAction(){
        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :CORRECTION_TITLE];        
        CAPA_Action__c capaAction = [SELECT Id FROM CAPA_Action__c WHERE Title__c = :CAPA_ACTION_TITLE];
        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :QMS_TASK_TITLE];

        // Move all to Closed
        correction.CMPL123_WF_Status__c = 'Closed';
        capaAction.CMPL123_WF_Status__c = 'Closed';
        qmsTask.CMPL123_WF_Status__c = 'Closed';

        // CAPA Action trigger will be tested since it is the last to be updated
               
        update correction;
        update qmsTask;
        update capaAction; 
        
        CMPL123QMS__CAPA__c capa = [SELECT Id, CMPL123Task_Key_Value__c FROM CMPL123QMS__CAPA__c WHERE Title__c = :CAPA_TITLE];        
        System.assertEquals(CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK, capa.CMPL123Task_Key_Value__c, 'The Key should be: ' + CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK);        
    }



    @isTest
    public static void verifyTaskValueIsNOTAdded(){
        Correction__c correction = [SELECT Id FROM Correction__c WHERE Title__c = :CORRECTION_TITLE];        
        CAPA_Action__c capaAction = [SELECT Id FROM CAPA_Action__c WHERE Title__c = :CAPA_ACTION_TITLE];
        QMS_Task__c qmsTask = [SELECT Id FROM QMS_Task__c WHERE Title__c = :QMS_TASK_TITLE];

        // Move all to Closed
        correction.CMPL123_WF_Status__c = 'Open';
        capaAction.CMPL123_WF_Status__c = 'Closed';
        qmsTask.CMPL123_WF_Status__c = 'Closed';

        // CAPA Action trigger will be tested since it is the last to be updated
               
        update correction;
        update qmsTask;
        update capaAction; 
        
        CMPL123QMS__CAPA__c capa = [SELECT Id, CMPL123Task_Key_Value__c FROM CMPL123QMS__CAPA__c WHERE Title__c = :CAPA_TITLE];        
        System.assertEquals(null, capa.CMPL123Task_Key_Value__c, 'The Key should be null');
    }

    @isTest
    public static void testCAPAMove(){
        CMPL123QMS__CAPA__c capa = [SELECT Id, CMPL123Task_Key_Value__c FROM CMPL123QMS__CAPA__c WHERE Title__c = :CAPA_TO_MOVE_TITLE];
        System.assertEquals(null, capa.CMPL123Task_Key_Value__c, 'At this step, CAPA should not contain the key');
        
        // Update the Capa
        capa.CMPL123_WF_Status__c = Constants.CAPA_STATUS_ACTIONS_IMPLEMENTATION;
        update capa;

        //retrieve CAPA
        capa = [SELECT Id, CMPL123Task_Key_Value__c FROM CMPL123QMS__CAPA__c WHERE Title__c = :CAPA_TO_MOVE_TITLE];

        // Verify
        System.assertEquals(CAPA_AutomationForActionsCompletedHelper.CAPA_TFUKV_EFFECTIVENESS_CHECK, capa.CMPL123Task_Key_Value__c, 'At this step the CAPA Should contain the key');
        
    }

}