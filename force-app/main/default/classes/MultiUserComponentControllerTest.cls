@isTest
public with sharing class MultiUserComponentControllerTest {

    private static final String FIRSTNAME1 = 'Iamwill';
    private static final String FIRSTNAME2 = 'Iamwilliam'; 
    private static final String FIRSTNAME3 = 'DOESNTEXIST123456789'; 

    private static final String QUALITY_EVENT_TITLE = 'TITLE_FOR_THE_QE_TESTIING';


    
    @TestSetup
    static void makeData(){
        
        // Users

        User user1 = TestDataFactory.generateUser();
        user1.FirstName = FIRSTNAME1;
        user1.TWD_Role__c = Constants.TWD_ROLE_QE_CAPA_PARTICIPANT;
        insert user1;

        User user2 = TestDataFactory.generateUser();
        user2.FirstName = FIRSTNAME2;
        user2.TWD_Role__c = Constants.TWD_ROLE_QE_CAPA_PARTICIPANT;
        insert user2;

        User user3 = TestDataFactory.generateUser();
        user3.FirstName = FIRSTNAME3;
        user3.TWD_Role__c = Constants.TWD_ROLE_QE_CAPA_PARTICIPANT;
        insert user3;

        User user4 = TestDataFactory.generateUser();        
        insert user4;

        User user5 = TestDataFactory.generateUser();        
        insert user5;

        // Quality Event
        Quality_Event__c qe = TestDataFactory.generateQualityEvent();
        qe.Title__c = QUALITY_EVENT_TITLE;
        insert qe;

        // Insert 2 contributors on the QE

        Quality_Event_Contributor__c contributor1 = new Quality_Event_Contributor__c();
        contributor1.Contributor_Of_Quality_Event__c = qe.Id;
        contributor1.Contributor_User__c = user1.Id;
        insert contributor1;

        Quality_Event_Contributor__c contributor2 = new Quality_Event_Contributor__c();
        contributor2.Contributor_Of_Quality_Event__c = qe.Id;
        contributor2.Contributor_User__c = user2.Id;
        insert contributor2;
    }
    
    
    
    @isTest
    public static void retrieveFullListOfUsers_1(){
        List<User> userList = MultiUserComponentController.retrieveFullListOfUsers(FIRSTNAME1, new List<Id>());
        Integer expectedSizeOfUserList = 2;
        System.assertEquals(expectedSizeOfUserList, userList.size(), 'Expect this size of Users since ' + expectedSizeOfUserList + ' users have been inserted with such criteria');
    }


    @isTest
    public static void retrieveFullListOfUsers_2(){
        // Get 1 User more
        User userWithId = [Select Id from User where FirstName = :FIRSTNAME3];
        List<Id> listOfIds = new List<Id>();
        listOfIds.add(userWithId.Id);
        
        List<User> userList = MultiUserComponentController.retrieveFullListOfUsers(FIRSTNAME1, listOfIds);
        Integer expectedSizeOfUserList = 3;
        System.assertEquals(expectedSizeOfUserList, userList.size(), 'Expect this size of Users since ' + expectedSizeOfUserList + ' users have been inserted with such criteria');
    }

    @isTest
    public static void retrieveAlreadySelectedUsers_QE(){
        Quality_Event__c qe = [Select Id from Quality_Event__c where Title__c = :QUALITY_EVENT_TITLE];        
        List<User> listOfUsers = MultiUserComponentController.retrieveAlreadySelectedUsers('Quality_Event__c',qe.Id);        
        System.assertEquals(2, listOfUsers.size(), '2 Contributors have been inserted on this QE, hence 2 should be retrieved');
    }


    @isTest
    public static void deleteRecords_QE(){
        Quality_Event__c qe = [Select Id from Quality_Event__c where Title__c = :QUALITY_EVENT_TITLE];        
        User userWithId = [Select Id from User where FirstName = :FIRSTNAME2];
        List<Id> listOfdUserToDelete = new List<Id>();
        listOfdUserToDelete.add(userWithId.Id);

        MultiUserComponentController.deleteRecords('Quality_Event__c' , qe.Id , listOfdUserToDelete);
        List<User> listOfRemainingUsers = MultiUserComponentController.retrieveAlreadySelectedUsers('Quality_Event__c',qe.Id);

        System.assertEquals(1, listOfRemainingUsers.size(), '1 Contributor only should remain since one have been removed');
    }

    @isTest
    public static void createRecords_QE(){
        Quality_Event__c qe = [Select Id from Quality_Event__c where Title__c = :QUALITY_EVENT_TITLE];        
        User userWithId = [Select Id from User where FirstName = :FIRSTNAME3];
        List<Id> listOfdUserToCreate = new List<Id>();
        listOfdUserToCreate.add(userWithId.Id);

        MultiUserComponentController.createRecords('Quality_Event__c' , qe.Id , listOfdUserToCreate);
        List<User> listOfRemainingUsers = MultiUserComponentController.retrieveAlreadySelectedUsers('Quality_Event__c',qe.Id);

        System.assertEquals(3, listOfRemainingUsers.size(), '3 Contributor only should remain since 1 have been added');
    }



    @isTest
    public static void testReadOnly_QE(){
        
        // Rule
        CMPL123__WF_Rule__c rule = new CMPL123__WF_Rule__c();
        rule.Name = 'FAKE RULE';
        rule.CMPL123__Is_Active__c = true;
        rule.CMPL123__Target_Object__c = 'Quality_Event__c';
        rule.CMPL123__Record_Type__c = 'DOES_NOT_EXIST';
        insert rule;


        // Action
        CMPL123__WF_Action__c action = new CMPL123__WF_Action__c();
        action.Name = 'DO SOMETHING';
        insert action;
        
        // Status
        CMPL123__WF_Status__c startStatus = new CMPL123__WF_Status__c();
        startStatus.Name = 'Start';
        insert startStatus;

        CMPL123__WF_Status__c lockStatus = new CMPL123__WF_Status__c();
        lockStatus.Name = 'LOCKED';
        insert lockStatus;


        // Steps
        CMPL123__WF_Step__c fakeStep = new CMPL123__WF_Step__c();
        fakeStep.CMPL123__Start_Status__c = startStatus.Id;
        fakeStep.CMPL123__End_Status__c = lockStatus.Id;
        fakeStep.CMPL123__WF_Rule__c = rule.Id;
        fakeStep.CMPL123__Is_Related_Lists_Locked__c = true;
        fakeStep.CMPL123__Action__c = action.Id;
        fakeStep.CMPL123__Order__c = 1;
        insert fakeStep;


        Quality_Event__c qe = new Quality_Event__c();
        qe.CMPL123_WF_Status__c = lockStatus.Name;
        insert qe;


        Boolean locked = MultiUserComponentController.isComponentNeedToBeLocked('Quality_Event__c', qe.Id);
        System.assert(locked, 'Component should be locked');

    }



    @isTest
    public static void testReadOnly_CI(){
        
        // Rule
        CMPL123__WF_Rule__c rule = new CMPL123__WF_Rule__c();
        rule.Name = 'FAKE RULE';
        rule.CMPL123__Is_Active__c = true;
        rule.CMPL123__Target_Object__c = 'Cause_Investigation__c';
        rule.CMPL123__Record_Type__c = 'DOES_NOT_EXIST';
        insert rule;


        // Action
        CMPL123__WF_Action__c action = new CMPL123__WF_Action__c();
        action.Name = 'DO SOMETHING';
        insert action;
        
        // Status
        CMPL123__WF_Status__c startStatus = new CMPL123__WF_Status__c();
        startStatus.Name = 'Start';
        insert startStatus;

        CMPL123__WF_Status__c lockStatus = new CMPL123__WF_Status__c();
        lockStatus.Name = 'LOCKED';
        insert lockStatus;


        // Steps
        CMPL123__WF_Step__c fakeStep = new CMPL123__WF_Step__c();
        fakeStep.CMPL123__Start_Status__c = startStatus.Id;
        fakeStep.CMPL123__End_Status__c = lockStatus.Id;
        fakeStep.CMPL123__WF_Rule__c = rule.Id;
        fakeStep.CMPL123__Is_Related_Lists_Locked__c = true;
        fakeStep.CMPL123__Action__c = action.Id;
        fakeStep.CMPL123__Order__c = 1;
        insert fakeStep;


        Cause_Investigation__c ci = new Cause_Investigation__c();
        ci.CMPL123_WF_Status__c = lockStatus.Name;
        insert ci;


        Boolean locked = MultiUserComponentController.isComponentNeedToBeLocked('Cause_Investigation__c', ci.Id);
        System.assert(locked, 'Component should be locked');

    }

    
}