@isTest
public  class SearchProductsInSAPControllerTest {

    private static final String QE_TITLE = 'A TITLE TO REQUEST';

    @TestSetup
    static void makeData(){
        Quality_Event__c qe = new Quality_Event__c();
        qe.Title__c = QE_TITLE;
        insert qe;
    }

    @IsTest
    static void serial(){                
        SearchProductsInSAPController.searchProducts('123','','456');
    }

    @IsTest
    static void batch(){                
        SearchProductsInSAPController.searchProducts('123','456','');
    }

    @IsTest
    static void createImpactedLotsFromSAPProducts_Batch(){
        Quality_Event__c qe = [Select Id from Quality_Event__c WHERE Title__c = :QE_TITLE];
        List<materialDocumentItems__x> listToInsert = new List<materialDocumentItems__x>();

    

        materialDocumentItems__x toInsert = new materialDocumentItems__x(
            postingDate__c = DateTime.newInstanceGMT(1999, 9, 22, 3, 1, 2),
            batch__c = '1234',
            material__c = '56',
            materialDescription__c = 'description',
            supplierName__c = 'SUPPNAME',
            supplier__c = '578',
            materialBaseUnit__c = 'BU',
            catalogProfile__c = 'PROF',
            catalogProfileTxt__c = 'PROFTXT',
            manufacturingDate__c = System.Today(),
            vendorBatch__c = 'VENDOR BATCH'
        );

        listToInsert.add(toInsert);


        SearchProductsInSAPController.SAPProductRequestAdaptor search = new SearchProductsInSAPController.BatchNumberSearch('NOT BE USED','NOT BE USED');
        List<Impacted_Lot_SN__c> createdImpactedLots = search.transformSAPInfoInImpactedLots(listToInsert);

        

        
        SearchProductsInSAPController.createImpactedLotsFromSAPProducts(createdImpactedLots, qe.Id);

        // Verify Impacted lots
        createdImpactedLots = [SELECT 
                                    Id,
                                    Date_of_Manufacture_Receipt__c,
                                    Lot_Serial_Number__c,
                                    Item_Number__c,
                                    Item_Description__c,
                                    Supplier_Name__c,
                                    Supplier_Number__c,
                                    Unit_of_Measure__c,
                                    Catalog_Profile_Number__c,
                                    Catalog_Profile_Name__c
                                FROM
                                    Impacted_Lot_SN__c
                                WHERE Related_Quality_Event__c = :qe.Id
        ];
        System.assertEquals(1, createdImpactedLots.size(), 'An impacted lot should have been created');

        Impacted_Lot_SN__c impactedLotToTest = createdImpactedLots.get(0);

        // Verify mapping
        System.assertEquals(toInsert.manufacturingDate__c.date(),impactedLotToTest.Date_of_Manufacture_Receipt__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.batch__c,impactedLotToTest.Lot_Serial_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.material__c,impactedLotToTest.Item_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.materialDescription__c,impactedLotToTest.Item_Description__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.supplierName__c,impactedLotToTest.Supplier_Name__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.supplier__c,impactedLotToTest.Supplier_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.materialBaseUnit__c,impactedLotToTest.Unit_of_Measure__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.catalogProfile__c,impactedLotToTest.Catalog_Profile_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.catalogProfileTxt__c,impactedLotToTest.Catalog_Profile_Name__c, 'Mappring issue for the field');
    }


    @IsTest
    static void createImpactedLotsFromSAPProducts_Serial(){
        Quality_Event__c qe = [Select Id from Quality_Event__c WHERE Title__c = :QE_TITLE];
        List<materialDocumentItems__x> listToInsert = new List<materialDocumentItems__x>();

        materialDocumentItems__x toInsert = new materialDocumentItems__x(
            postingDate__c = DateTime.newInstanceGMT(1999, 9, 22, 3, 1, 2),
            batch__c = '1234',
            material__c = '56',
            materialDescription__c = 'description',
            supplierName__c = 'SUPPNAME',
            supplier__c = '578',
            materialBaseUnit__c = 'BU',
            catalogProfile__c = 'PROF',
            catalogProfileTxt__c = 'PROFTXT',
            manufacturingDate__c = System.Today(),
            vendorBatch__c = 'VENDOR BATCH'
        );

        listToInsert.add(toInsert);


        SearchProductsInSAPController.SAPProductRequestAdaptor search = new SearchProductsInSAPController.SerialNumberSearch('NOT BE USED',toInsert.batch__c);
        List<Impacted_Lot_SN__c> createdImpactedLots = search.transformSAPInfoInImpactedLots(listToInsert);

        

        
        SearchProductsInSAPController.createImpactedLotsFromSAPProducts(createdImpactedLots, qe.Id);

        // Verify Impacted lots
        createdImpactedLots = [SELECT 
                                    Id,
                                    Date_of_Manufacture_Receipt__c,
                                    Lot_Serial_Number__c,
                                    Item_Number__c,
                                    Item_Description__c,
                                    Supplier_Name__c,
                                    Supplier_Number__c,
                                    Unit_of_Measure__c,
                                    Catalog_Profile_Number__c,
                                    Catalog_Profile_Name__c
                                FROM
                                    Impacted_Lot_SN__c
                                WHERE Related_Quality_Event__c = :qe.Id
        ];
        System.assertEquals(1, createdImpactedLots.size(), 'An impacted lot should have been created');

        Impacted_Lot_SN__c impactedLotToTest = createdImpactedLots.get(0);

        // Verify mapping
        System.assertEquals(toInsert.postingDate__c.date(),impactedLotToTest.Date_of_Manufacture_Receipt__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.batch__c,impactedLotToTest.Lot_Serial_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.material__c,impactedLotToTest.Item_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.materialDescription__c,impactedLotToTest.Item_Description__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.supplierName__c,impactedLotToTest.Supplier_Name__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.supplier__c,impactedLotToTest.Supplier_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.materialBaseUnit__c,impactedLotToTest.Unit_of_Measure__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.catalogProfile__c,impactedLotToTest.Catalog_Profile_Number__c, 'Mappring issue for the field');
        System.assertEquals(toInsert.catalogProfileTxt__c,impactedLotToTest.Catalog_Profile_Name__c, 'Mappring issue for the field');
    }
}