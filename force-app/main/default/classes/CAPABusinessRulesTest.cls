@isTest
public with sharing class CAPABusinessRulesTest {

    private static final String TITLE_TO_GIVE_TO_OBJECT = 'TITLE_TO_BE_USED_FOR_ALL_OBJECT_SOQL';

    private static final String ACTIVE_EMAIL = 'this.address.will.never@exist.on.earth';
    private static final String INACTIVE_EMAIL = 'this.other.address.will.never@exist.on.earth';
    
    @TestSetup
    static void makeData(){
        CMPL123QMS__CAPA__c testCAPA = new CMPL123QMS__CAPA__c();
        testCAPA.CMPL123_WF_Status__c = 'Initiated';
        testCAPA.Title__c = TITLE_TO_GIVE_TO_OBJECT;        
        insert testCAPA;
       
        Profile profileForAll = [Select Id from Profile where Name = 'BMX TWD User'];

        User anActiveUser = new User();
        anActiveUser.Email = ACTIVE_EMAIL;
        anActiveUser.Username = ACTIVE_EMAIL;
        anActiveUser.LastName = 'Batman';        
        anActiveUser.Alias = 'AL1';
        anActiveUser.TimeZoneSidKey = 'Europe/Berlin';
        anActiveUser.LocaleSidKey = 'de_DE';
        anActiveUser.EmailEncodingKey = 'UTF-8';
        anActiveUser.ProfileId = profileForAll.Id;
        anActiveUser.LanguageLocaleKey = 'en_US';
        anActiveUser.IsActive = true;
        insert anActiveUser;

        User anInactiveUser = new User();
        anInactiveUser.Email = INACTIVE_EMAIL;
        anInactiveUser.Username = INACTIVE_EMAIL;
        anInactiveUser.LastName = 'Robin';
        anInactiveUser.Alias = 'AL2';
        anInactiveUser.TimeZoneSidKey = 'Europe/Berlin';
        anInactiveUser.LocaleSidKey = 'de_DE';
        anInactiveUser.EmailEncodingKey = 'UTF-8';
        anInactiveUser.ProfileId = profileForAll.Id;
        anInactiveUser.LanguageLocaleKey = 'en_US';
        anInactiveUser.IsActive = false;
        insert anInactiveUser;
    }
    
    
    @isTest
    static void passingTest(){
        User activeUser = [Select Id from User where Email = :ACTIVE_EMAIL];
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;
        capaAction.Assigned_To__c = activeUser.Id;
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = Date.newInstance(2022, 10, 12);
        insert capaAction;
        
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Status__c = Constants.CAPA_STATUS_APPROVAL;                        
        update capaToUpdate;

        // Verify that everything ran well -> that the CAPA Have the good status
        CMPL123QMS__CAPA__c capaToVerify = [SELECT Id, CMPL123_WF_Status__c FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];        
        System.assertEquals(Constants.CAPA_STATUS_APPROVAL, capaToVerify.CMPL123_WF_Status__c, 'The CAPA Should have move to ' + Constants.CAPA_STATUS_APPROVAL + ' status');

    }

    @isTest
    static void noAssignee(){        
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;        
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = Date.newInstance(2022, 10, 12);
        insert capaAction;
        
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Status__c = Constants.CAPA_STATUS_APPROVAL;                        
        Boolean exceptionRan = false;
        try {
            update capaToUpdate;    
        } catch (Exception e) {
            exceptionRan = true;
        }
        System.assertEquals(true, exceptionRan, 'An Exception should have run to raise that No User is Assigned to CAPA Action');
    }



    @isTest
    static void inactiveUser(){
        User inactive = [Select Id from User where Email = :INACTIVE_EMAIL];
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;
        capaAction.Assigned_To__c = inactive.Id;
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = Date.newInstance(2022, 10, 12);
        insert capaAction;
        
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Status__c = Constants.CAPA_STATUS_APPROVAL;                        
        Boolean exceptionRan = false;
        try {
            update capaToUpdate;    
        } catch (Exception e) {
            exceptionRan = true;
        }
        System.assertEquals(true, exceptionRan, 'An Exception should have run to raise that the user is inactive');
    }


    @isTest
    static void cancelledCapaAction(){
        User activeUser = [Select Id from User where Email = :ACTIVE_EMAIL];
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;
        capaAction.Assigned_To__c = activeUser.Id;
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = Date.newInstance(2022, 10, 12);
        capaAction.CMPL123_WF_Status__c = 'Canceled';
        insert capaAction;
        
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Status__c = Constants.CAPA_STATUS_APPROVAL;                        
        Boolean exceptionRan = false;
        try {
            update capaToUpdate;    
        } catch (Exception e) {
            exceptionRan = true;
        }
        System.assertEquals(true, exceptionRan, 'An Exception should have run because there is a linked action, but it is Cancelled');
    }

    @isTest
    static void noCapaAction(){
        
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Status__c = Constants.CAPA_STATUS_APPROVAL;                        
        Boolean exceptionRan = false;
        try {
            update capaToUpdate;    
        } catch (Exception e) {
            exceptionRan = true;
        }
        System.assertEquals(true, exceptionRan, 'An Exception should have run to raise that There is no CAPA Action');
    }


    @isTest
    static void noDueDateCapaAction(){
        User activeUser = [Select Id from User where Email = :ACTIVE_EMAIL];
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;
        capaAction.Assigned_To__c = activeUser.Id;
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = null;
        insert capaAction;
        
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Status__c = Constants.CAPA_STATUS_APPROVAL;                        
        Boolean exceptionRan = false;
        try {
            update capaToUpdate;    
        } catch (Exception e) {
            exceptionRan = true;
        }
        System.assertEquals(true, exceptionRan, 'An Exception should have run to raise that at least one Capa Action has no Due Date');
    }

    @isTest
    static void passingTest_Avoid_CancelCAPA(){
        User activeUser = [Select Id from User where Email = :ACTIVE_EMAIL];
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;
        capaAction.Assigned_To__c = activeUser.Id;
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = Date.newInstance(2022, 10, 12);
        capaAction.CMPL123_WF_Status__c = Constants.CAPA_ACTION_STATUS_CANCELED;
        insert capaAction;
        
        // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Action__c = Constants.CAPA_WF_ACTION_CANCEL;                        
        update capaToUpdate;

        // Verify that everything ran well -> that the CAPA Have the good status
        CMPL123QMS__CAPA__c capaToVerify = [SELECT Id, CMPL123_WF_Action__c FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];        
        System.assertEquals(Constants.CAPA_WF_ACTION_CANCEL, capaToVerify.CMPL123_WF_Action__c, 'The CAPA Should have Action: ' + Constants.CAPA_WF_ACTION_CANCEL + ' status');

    }


    @isTest
    static void passingTest_Avoid_CancelCAPA_Non_Passing(){
        User activeUser = [Select Id from User where Email = :ACTIVE_EMAIL];
        // Get CAPA To Update
        CMPL123QMS__CAPA__c capaToUpdate = [SELECT Id FROM  CMPL123QMS__CAPA__c WHERE Title__c = :TITLE_TO_GIVE_TO_OBJECT];
        
        // Link a CAPA Action to our CAPA        
        CAPA_Action__c capaAction = new CAPA_Action__c();
        capaAction.Title__c = TITLE_TO_GIVE_TO_OBJECT;
        capaAction.Assigned_To__c = activeUser.Id;
        capaAction.CAPA__c = capaToUpdate.Id;
        capaAction.Due_Date__c = Date.newInstance(2022, 10, 12);
        capaAction.CMPL123_WF_Status__c = 'STATUS NOT CANCELED :-)';
        insert capaAction;
        
        Boolean exceptionRan = false;
        try {
            // Now Update the CAPA        
        capaToUpdate.CMPL123_WF_Action__c = Constants.CAPA_WF_ACTION_CANCEL;                        
        update capaToUpdate;
        } catch (Exception e) {
            exceptionRan = true;
        }
        System.assertEquals(true, exceptionRan, 'An Exception should have run to raise that we tried to Cancel a CAPA with a CAPA Action that is not Initiated/Cancel');
    }
}