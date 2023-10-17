@isTest
private class Investchildupdate_Test {

  private static final String USER_EMAIL = 'utest@email.com';

  @TestSetup
  static void initUserData() {
    // User initialization
    Profile p = [select id from profile where name='Standard User'];

    User u = new User(alias = 'utest', email=USER_EMAIL,
    emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
    localesidkey='en_US', profileid = p.Id, country='United States',
    timezonesidkey='America/Los_Angeles', username='utest123@neyemail.com');
    insert u;
  }

  @isTest
  public static void testSendMails() 
  {
    User testUser = [SELECT Id, Alias, Email FROM User WHERE Email = :USER_EMAIL];

    CMPL123CME__Investigation__c testInvestigation = new CMPL123CME__Investigation__c();
    insert testInvestigation;

    Task taskToSendMailToOwner = new Task();
    taskToSendMailToOwner.OwnerId = testUser.Id;
    taskToSendMailToOwner.WhatId = testInvestigation.Id;
    insert taskToSendMailToOwner;

    // Update record to send mail
    testInvestigation.CMPL123_WF_Status__c = 'Closed - Done';
    update testInvestigation;

  }

  @isTest
  public static void children(){
    CMPL123CME__Investigation__c parent = new CMPL123CME__Investigation__c();
    insert parent;

    CMPL123CME__Investigation__c child = new CMPL123CME__Investigation__c();
    child.Master_Investigation__c = parent.Id;

    insert child;

    parent.CMPL123_WF_Status__c = 'Closed - Done';
    update parent; 
  }
    

}