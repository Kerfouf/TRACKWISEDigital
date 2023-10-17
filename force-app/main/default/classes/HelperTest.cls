@isTest
public with sharing class HelperTest {
    @isTest
    public static void empty() 
    {
        List<Quality_Event__c> myList= new List<Quality_Event__c>();
        System.assertEquals(true, Helper.isEmpty(myList));

        Set<Id> mySet= new Set<Id>();
        System.assertEquals(true, Helper.isEmpty(mySet));
    }

    @isTest
    public static void fieldCount() 
    {
        Quality_Event__c qe = new Quality_Event__c();
        qe.Title__c = 'test';
        qe.Description__c = 'desc';
        Integer count = Helper.nonEmptyFieldsCount(qe, new List<String>{'Title__c','Description__c'});

        System.assertEquals(2, count);

    }

    @isTest
    public static void onlyOneParent() 
    {
        Quality_Event__c qe = new Quality_Event__c();
        qe.Title__c = 'test';
        List<Quality_Event__c> myList= new List<Quality_Event__c>();
        myList.add(qe);

        Helper.checkOnlyOneParent(myList, new List<String>{'Title__c'}, 'Test');
    }

    @isTest
    public static void listOfIds() 
    {
        Quality_Event__c qe = new Quality_Event__c();
        insert qe;

        List<Quality_Event__c> myList= new List<Quality_Event__c>();
        myList.add(qe);

        Set<Id> ids = Helper.extractListOfIdsOfAField(myList, 'Id');
        // Only one in the loop
        for(Id loopId : ids){
            System.assertEquals(qe.Id, loopId);
        }
    }


}