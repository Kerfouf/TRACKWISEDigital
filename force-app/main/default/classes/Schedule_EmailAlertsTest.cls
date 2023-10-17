@isTest
public with sharing class Schedule_EmailAlertsTest {
    private static final String USER_EMAIL = 'utest@email.com';

    @TestSetup
    static void initUserData() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];

        User u = new User(alias = 'utest', email=USER_EMAIL,
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='utest123@email.com');
        insert u;

        Correction__c corr = new Correction__c();
        corr.OwnerId = u.Id;
        insert corr;

        Date dateInThePast =  Date.today();
        dateInThePast = dateInThePast.addDays(7);

        corr.CMPL123_WF_Status__c = 'Initiated';
        corr.Due_Date__c = dateInThePast;
        update corr;

    }
    
    
    
    @isTest
    public static void testScheduledEmailAlerts(){
        
        
        
        Schedule_BeforeDueEmailAlerts beforeAlert = new Schedule_BeforeDueEmailAlerts();
        beforeAlert.execute();
        
        Schedule_AfterDueEmailAlerts afterAlert = new Schedule_AfterDueEmailAlerts();
        afterAlert.execute();

    }
}