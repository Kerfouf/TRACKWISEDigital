public with sharing class TestDataFactory {


    private final static Profile BMX_TWD_USER_PROFILE = [SELECT Id FROM Profile WHERE Name = :Constants.BMX_TWD_USER_PROFILE_NAME];
    
    public static Quality_Event__c generateQualityEvent(){
        Id recordTypeId = Schema.SObjectType.Quality_Event__c.getRecordTypeInfosByDeveloperName().get('Product').getRecordTypeId();
        
        Quality_Event__c qe = new Quality_Event__c();
        qe.Origination__c = 'Corporate';
        qe.Title__c = 'TEST TITLE';
        qe.Description__c = 'DESCRIPTION';
        qe.RecordTypeId = recordTypeId;

        return qe;
    }


    public static User generateUser(){        
        
        User userToReturn = new User (
            Alias = generateRandomString().right(6),            
            Email = generateRandomString() + '@test.com',
            EmailEncodingKey = 'UTF-8',
            FirstName = generateRandomString(),
            LanguageLocaleKey = 'en_US',
            LastName = generateRandomString(),
            LocaleSidKey = 'en_US',            
            TimeZoneSidKey = 'America/Los_Angeles',
            Username =  generateRandomString() + '@test.com',
            ProfileId = BMX_TWD_USER_PROFILE.Id
        );
        return userToReturn;

    }


    private static String generateRandomString(){
        return String.valueOf(Math.roundToLong(Math.random() * 10000000000L));
    }

    

}