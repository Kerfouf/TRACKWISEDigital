@isTest
public with sharing class LimsIncidentPlatformEventHelperTest {
    
    private static final String ID_OF_INCIDENT_ID_FOR_LIMS = 'LIMS_INCIDENT-ID-THAT-EXIST-FOR-TEST-PURPOSE';
    private static final String QE_TITLE = 'TITLE';
    private static final String QE_DESCRIPTION = 'QE_DESCRIPTION';
    
    
     
    private static LIMS_Inc_PF_Event__e makeData(){
        LIMS_Inc_PF_Event__e pfEvent = new LIMS_Inc_PF_Event__e();
        pfEvent.LIMS_Incident_ID__c = ID_OF_INCIDENT_ID_FOR_LIMS;
        pfEvent.Title__c = QE_TITLE;
        pfEvent.Description__c = QE_DESCRIPTION;

        return pfEvent;
    }

    @IsTest
    public static void verifyFieldsMapping(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        Quality_Event__c qe = [SELECT Id, Title__c, Description__c,LIMS_Incident_Number__c,Origination__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        
        System.assertEquals(qe.LIMS_Incident_Number__c, pfEvent.LIMS_Incident_ID__c, 'Field mapping seems to be incorrect');
        System.assertEquals(qe.Title__c, pfEvent.Title__c, 'Field mapping seems to be incorrect');
        System.assertEquals(qe.Description__c, pfEvent.Description__c, 'Field mapping seems to be incorrect');

        System.assertEquals(qe.Origination__c, LimsIncidentPlatformEventHelper.ORIGINATION_VALUE_FOR_QUALITY_EVENT, 'Origination field is a constant that should equals ' + LimsIncidentPlatformEventHelper.ORIGINATION_VALUE_FOR_QUALITY_EVENT);

    }


    @IsTest
    public static void verifyCreatedImpactedLots(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        
        // Create 3 Impacted lots 
        pfEvent.Product_Codes__c = 'CODE1|CODE2|CODE3';
        pfEvent.Product_Descriptions__c = 'Desc1|Desc2|Desc3';
        pfEvent.Batch_IDs__c = 'Bat1|BATBAT2|BATBATBAT3';
        pfEvent.Vendor_Batch_Id__c = 'VENDO1|V2|v3';


        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        Quality_Event__c qe = [SELECT Id, Title__c, Description__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        
        List<Impacted_Lot_SN__c> createdImpactedLots = [SELECT Id, Item_Number__c, Item_Description__c, Lot_Serial_Number__c, Supplier_Lot_Serial_Number__c FROM Impacted_Lot_SN__c WHERE Related_Quality_Event__c = :qe.Id ORDER BY Item_Number__c ASC];
        System.assertEquals(3, createdImpactedLots.size(), '3 Impacted Lot should have been created');
        
        System.assertEquals('CODE1', createdImpactedLots.get(0).Item_Number__c, 'Incorrect Mapping');
        System.assertEquals('Desc1', createdImpactedLots.get(0).Item_Description__c, 'Incorrect Mapping');
        System.assertEquals('Bat1', createdImpactedLots.get(0).Lot_Serial_Number__c, 'Incorrect Mapping');
        System.assertEquals('VENDO1', createdImpactedLots.get(0).Supplier_Lot_Serial_Number__c, 'Incorrect Mapping');
    }


    @IsTest
    public static void verifyCreatedImpactedLots2(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        
        // Create 3 Impacted lots 
        pfEvent.Product_Codes__c = 'CODE1|CODE2|CODE3';
        pfEvent.Product_Descriptions__c = 'Desc1|Desc2|Desc3';
        pfEvent.Batch_IDs__c = 'Bat1|BATBAT2|BATBATBAT3';
        pfEvent.Vendor_Batch_Id__c = '||';


        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        Quality_Event__c qe = [SELECT Id, Title__c, Description__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        
        List<Impacted_Lot_SN__c> createdImpactedLots = [SELECT Id, Item_Number__c, Item_Description__c, Lot_Serial_Number__c, Supplier_Lot_Serial_Number__c FROM Impacted_Lot_SN__c WHERE Related_Quality_Event__c = :qe.Id ORDER BY Item_Number__c ASC];
        System.assertEquals(3, createdImpactedLots.size(), '3 Impacted Lot should have been created');
        
        System.assertEquals('CODE1', createdImpactedLots.get(0).Item_Number__c, 'Incorrect Mapping');
        System.assertEquals('Desc1', createdImpactedLots.get(0).Item_Description__c, 'Incorrect Mapping');
        System.assertEquals('Bat1', createdImpactedLots.get(0).Lot_Serial_Number__c, 'Incorrect Mapping');
        System.assertEquals(null, createdImpactedLots.get(0).Supplier_Lot_Serial_Number__c, 'Incorrect Mapping');
    }

    @IsTest
    public static void verifyCreatedImpactedLots3(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        
        // Create 3 Impacted lots 
        pfEvent.Product_Codes__c = 'CODE1|CODE2|CODE3';
        pfEvent.Product_Descriptions__c = 'Desc1|Desc2|Desc3';
        pfEvent.Batch_IDs__c = 'Bat1|BATBAT2|BATBATBAT3';
        pfEvent.Vendor_Batch_Id__c = '| |';


        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        Quality_Event__c qe = [SELECT Id, Title__c, Description__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        
        List<Impacted_Lot_SN__c> createdImpactedLots = [SELECT Id, Item_Number__c, Item_Description__c, Lot_Serial_Number__c, Supplier_Lot_Serial_Number__c FROM Impacted_Lot_SN__c WHERE Related_Quality_Event__c = :qe.Id ORDER BY Item_Number__c ASC];
        System.assertEquals(3, createdImpactedLots.size(), '3 Impacted Lot should have been created');
        
        System.assertEquals('CODE1', createdImpactedLots.get(0).Item_Number__c, 'Incorrect Mapping');
        System.assertEquals('Desc1', createdImpactedLots.get(0).Item_Description__c, 'Incorrect Mapping');
        System.assertEquals('Bat1', createdImpactedLots.get(0).Lot_Serial_Number__c, 'Incorrect Mapping');
        System.assertEquals(null, createdImpactedLots.get(0).Supplier_Lot_Serial_Number__c, 'Incorrect Mapping');
    }

    @IsTest
    public static void verifyCreatedImpactedLots4(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        
        // Create 10 Impacted lots 
        pfEvent.Product_Codes__c = 'CODE0|CODE1|CODE2|CODE3|CODE4|CODE5|CODE6|CODE7|CODE8|CODE9';
        pfEvent.Product_Descriptions__c = 'DESCRIPTION - 0|DESCRIPTION - 1|DESCRIPTION - 2|DESCRIPTION - 3|DESCRIPTION - 4|DESCRIPTION - 5|DESCRIPTION - 6|DESCRIPTION - 7|DESCRIPTION - 8|DESCRIPTION - 9';
        pfEvent.Batch_IDs__c = 'B0|B1|B2|B3|B4|B5|B6|B7|B8|B9';
        pfEvent.Vendor_Batch_Id__c = ' ||| ||| ||| ';


        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        Quality_Event__c qe = [SELECT Id, Title__c, Description__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        
        List<Impacted_Lot_SN__c> createdImpactedLots = [SELECT Id, Item_Number__c, Item_Description__c, Lot_Serial_Number__c, Supplier_Lot_Serial_Number__c FROM Impacted_Lot_SN__c WHERE Related_Quality_Event__c = :qe.Id ORDER BY Item_Number__c ASC];
        System.assertEquals(10, createdImpactedLots.size(), '10 Impacted Lot should have been created');
        
        System.assertEquals('CODE0', createdImpactedLots.get(0).Item_Number__c, 'Incorrect Mapping');
        System.assertEquals('DESCRIPTION - 0', createdImpactedLots.get(0).Item_Description__c, 'Incorrect Mapping');
        System.assertEquals('B0', createdImpactedLots.get(0).Lot_Serial_Number__c, 'Incorrect Mapping');
        System.assertEquals(null, createdImpactedLots.get(0).Supplier_Lot_Serial_Number__c, 'Incorrect Mapping');
    }



    @IsTest
    public static void incorrectPicklistValue(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        pfEvent.TWD_Origination_Entity__c = 'THIS VALUE SHOULD CAUSE AN ERROR';

        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        List<Quality_Event__c> qe = [SELECT Id, Title__c, Description__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        System.assertEquals(0, qe.size(), 'No quality Event should have been created');

        // Verify a task have been created
        List<Task> createdTasks = [Select Id, Subject , ActivityDate, Description from Task WHERE Subject = :LimsIncidentPlatformEventHelper.QE_ERROR_TASK_SUBJECT];
        System.assertEquals(1, createdTasks.size(), 'One task should have been created');        
        
    }

    @IsTest
    public static void nonPassingImpactedLots(){
        Test.startTest();
        LIMS_Inc_PF_Event__e pfEvent = makeData();
        
        // Create 3 Impacted lots 
        pfEvent.Product_Codes__c = 'CODE1|CODE2|CODE3';
        pfEvent.Product_Descriptions__c = 'Desc1|Desc3';
        pfEvent.Batch_IDs__c = 'Bat1|BATBAT2|BATBATBAT3';


        EventBus.publish(pfEvent);
        Test.getEventBus().deliver();
        Test.stopTest();

        Quality_Event__c qe = [SELECT Id, Title__c, Description__c FROM Quality_Event__c WHERE LIMS_Incident_Number__c = :ID_OF_INCIDENT_ID_FOR_LIMS];
        
        List<Impacted_Lot_SN__c> createdImpactedLots = [SELECT Id, Item_Number__c, Item_Description__c, Lot_Serial_Number__c FROM Impacted_Lot_SN__c WHERE Related_Quality_Event__c = :qe.Id ORDER BY Item_Number__c ASC];
        System.assertEquals(0, createdImpactedLots.size(), 'No Impacted Lot should have been created');            
    }

}