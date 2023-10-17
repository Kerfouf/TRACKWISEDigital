@isTest
public with sharing class MIRCodeChoiceManagementTest {
    private static final String USER_EMAIL = 'utest@email.com';

    private static final String INVEST_NAME = 'SUPER_INVESTIGATION_NAME';

    private static final String JUSTIF_FOR_ANNEX_B = 'Super Justif for annex B';
    private static final String JUSTIF_FOR_ANNEX_C = 'Super Justif for annex C';


    @TestSetup
    static void initUserData() {
        // User initialization
        Profile p = [select id from profile where name='Standard User'];

        User u = new User(alias = 'utest', email=USER_EMAIL,
        emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = p.Id, country='United States',
        timezonesidkey='America/Los_Angeles', username='utest123@email.com');
        insert u;

        CMPL123CME__EU_MIR_Code__c B01CODE =new CMPL123CME__EU_MIR_Code__c();
        B01CODE.CMPL123CME__Name__c='Testing of Device';
        B01CODE.Name='B01';
        B01CODE.CMPL123CME__Code_Type__c='B-Investigation Type Code';
        B01CODE.CMPL123CME__Inactive__c = false;
        insert B01CODE;

        CMPL123CME__EU_MIR_Code__c C01CODE =new CMPL123CME__EU_MIR_Code__c();
        C01CODE.CMPL123CME__Name__c='Testing of Device';
        C01CODE.Name='C01';
        C01CODE.CMPL123CME__Code_Type__c='C-Starting Code';
        C01CODE.CMPL123CME__Inactive__c = false;
        insert C01CODE;



        // MIR
        CMPL123CME__EU_MIR__c mir = new CMPL123CME__EU_MIR__c();
        insert mir;

        // Invest
        CMPL123CME__Investigation__c Invest = new CMPL123CME__Investigation__c();
        Invest.Name = INVEST_NAME;
        invest.CMPL123_WF_Status__c = 'Opened';
        Invest.Justification_for_Annex_B__c = JUSTIF_FOR_ANNEX_B;
        Invest.Justification_for_Annex_C__c = JUSTIF_FOR_ANNEX_C;
        // CODE Starting by B (picklist)
        invest.B_Investigation_Type_Code_Choice_1__c='B01 - Testing of Actual/Suspected Device';
        
        // CODE Starting by C (lookup)
        invest.C_Investigation_Findings_Code_Choice1__c = C01CODE.Id;
        invest.EU_MIR__c = mir.id;
        insert invest;

        

    }

    @isTest
    public static void testUpdateMirAndCodeChoices(){
        CMPL123CME__Investigation__c invest = [SELECT Id, EU_MIR__c FROM CMPL123CME__Investigation__c WHERE Name = :INVEST_NAME];
        invest.CMPL123_WF_Status__c = 'A status that obviously  is not closed done';
        update invest;
        
        // test code choice generation
        List<CMPL123CME__EU_MIR_Code_Choices__c> codeChoicesGenerated = [SELECT Id FROM CMPL123CME__EU_MIR_Code_Choices__c WHERE CMPL123CME__Related_EU_MIR__c = :invest.EU_MIR__c];
        System.assertEquals(0, codeChoicesGenerated.size(), 'At this step No Code choice should be generated');

        invest.CMPL123_WF_Status__c = 'Closed - Done';
        update invest;

        Integer EXPECTED_CODE_CHOICES_GENERATED = 2;
        codeChoicesGenerated = [SELECT Id FROM CMPL123CME__EU_MIR_Code_Choices__c WHERE CMPL123CME__Related_EU_MIR__c = :invest.EU_MIR__c];
        System.assertEquals(EXPECTED_CODE_CHOICES_GENERATED, codeChoicesGenerated.size(), 'At this step ' + EXPECTED_CODE_CHOICES_GENERATED + ' code choices should be generated');

        // Now test values have been copied to MIR correctly
        CMPL123CME__EU_MIR__c linkedMIR = [SELECT Id, CMPL123CME__Explain_If_Investigation_Code_Missing__c FROM CMPL123CME__EU_MIR__c WHERE Id = :invest.EU_MIR__c];
        
        // Verify the field contains justif B
        boolean containsjustifB = linkedMIR.CMPL123CME__Explain_If_Investigation_Code_Missing__c.contains(JUSTIF_FOR_ANNEX_B);
        System.assertEquals(true,containsjustifB , 'The field should contains Justif B');

        // Verify the field contains justif C
        boolean containsjustifC = linkedMIR.CMPL123CME__Explain_If_Investigation_Code_Missing__c.contains(JUSTIF_FOR_ANNEX_C);
        System.assertEquals(true,containsjustifC , 'The field should contains Justif C');

    }

    @isTest
    public static void updateWithMassChildren(){
        CMPL123.RecoveryUtil.enableFeatureSuppressPackageTriggersForTest();
        Test.startTest();
        CMPL123CME__Investigation__c invest = [SELECT Id, EU_MIR__c FROM CMPL123CME__Investigation__c WHERE Name = :INVEST_NAME];
        
        List<CMPL123CME__Investigation__c> aLotOfChildrenToInsert = new List<CMPL123CME__Investigation__c>();
        for(Integer i = 0 ; i < 50 ; i++){
            CMPL123CME__Investigation__c toInsert = new CMPL123CME__Investigation__c();
            toInsert.Master_Investigation__c = invest.Id;
            toInsert.Name = 'Name ' + i;
            toInsert.BMX_Invest_Reference__c = false;
            aLotOfChildrenToInsert.add(toInsert);
        }
        insert aLotOfChildrenToInsert;

        // New status ==> Closed - Done
        invest.CMPL123_WF_Status__c = 'Closed - Done';

        // Update a field of the master
        String VALUE_TO_UPDATE = 'UPDATED VALUE TO CHECK IN CHILDREN';
        invest.BMX_Additional_Information__c = VALUE_TO_UPDATE;

        update invest;
        Test.stopTest();
        
        // Now check that the children have the same value
        for(CMPL123CME__Investigation__c clidInvest : [SELECT Id, BMX_Additional_Information__c FROM CMPL123CME__Investigation__c WHERE Master_Investigation__c = :invest.Id]){
            System.assertEquals(VALUE_TO_UPDATE, clidInvest.BMX_Additional_Information__c,'The child value should have been updated');
        }

        CMPL123.RecoveryUtil.disableFeatureSuppressPackageTriggersForTest();
    }
}