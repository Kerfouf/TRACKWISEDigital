@isTest
public with sharing class AddendumHelperTest {
    @isTest
    static void insertTests(){
        Quality_Event__c qe = new Quality_Event__c();
        insert qe;

        CMPL123QMS__CAPA__c capa = new CMPL123QMS__CAPA__c();
        insert capa;
    

        Boolean exceptionThrown = false;
        // Test 1
        Addendum__c er = new Addendum__c();
        try{    
            insert er;
        }catch(Exception e){
            exceptionThrown = true;
        }
        System.assertEquals(true, exceptionThrown, 'An Exception should have been thrown');
        

        // This should be ok
        er.CAPA__c = capa.Id;
        insert er;
        exceptionThrown = false;
        try{    
            // Add another parent should fail
            er.Quality_Event__c = qe.Id;
            update er;
        }catch(Exception e){
            exceptionThrown = true;
        }
        
        System.assertEquals(true, exceptionThrown, 'An Exception should have been thrown');
        

    }
}