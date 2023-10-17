@isTest
public without sharing class QualityEventHelperTest {
    
    private static final String QUALITY_EVENT_TITLE = 'QUALITY_EVENT_TITLE';
    private static final String IMPACTED_LOT_SERIAL = 'IMPACTED_LOT_SERIAL';


    @TestSetup
    static void makeData(){
        Quality_Event__c qe = new Quality_Event__c();        
        qe.Title__c = QUALITY_EVENT_TITLE;
        insert qe;

        Impacted_Lot_SN__c il = new Impacted_Lot_SN__c();
        il.Related_Quality_Event__c = qe.Id;
        il.Supplier_Lot_Serial_Number__c = IMPACTED_LOT_SERIAL;
        il.Quantity_Inspected_Tested__c = 'Not null';
        il.Quantity_Failed__c = 'Not null';
        il.Dispositions__c = 'Conforming';
        insert il;
    }

    @IsTest
    static void evaluationCompleteSuccess(){
        Boolean exceptionOccured = false;
        Quality_Event__c qe = [SELECT Id, CMPL123_WF_Action__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        Impacted_Lot_SN__c il = [SELECT Id, Quantity_Inspected_Tested__c, Quantity_Failed__c, Dispositions__c FROM Impacted_Lot_SN__c WHERE Supplier_Lot_Serial_Number__c =:IMPACTED_LOT_SERIAL];

        qe.CMPL123_WF_Action__c = 'Evaluation Complete';
        
        Test.startTest();

        try {
            update qe;
        } catch (Exception ex) {
            exceptionOccured = true;
        }
        
        Test.stopTest();

        System.assert(!exceptionOccured); //Expected : no exceptions occured
    }

    @IsTest
    static void evaluationCompleteFailure(){
        Boolean exceptionOccured = false;
        Quality_Event__c qe = [SELECT Id, CMPL123_WF_Action__c FROM Quality_Event__c WHERE Title__c = :QUALITY_EVENT_TITLE];
        Impacted_Lot_SN__c il = [SELECT Id, Quantity_Inspected_Tested__c, Quantity_Failed__c, Dispositions__c FROM Impacted_Lot_SN__c WHERE Supplier_Lot_Serial_Number__c =:IMPACTED_LOT_SERIAL];

        qe.CMPL123_WF_Action__c = 'Evaluation Complete';
        il.Dispositions__c = null; //Set one of the requiered fields to null

        update il;

        Test.startTest();

        try {
            update qe;            
        } catch (Exception ex) {
            exceptionOccured = true;
        }

        Test.stopTest();

        System.assert(exceptionOccured); //Expected : Exception occured due to related impacted lot requiered field missing at "evaluation complete"
        
    }
}