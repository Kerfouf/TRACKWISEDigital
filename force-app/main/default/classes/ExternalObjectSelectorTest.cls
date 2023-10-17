@IsTest
public with sharing class ExternalObjectSelectorTest {

    @IsTest
    static void filterCasesTest(){
        
        ExternalObjectSelectorTest.TestExternalObjectSelector testSelector = new ExternalObjectSelectorTest.TestExternalObjectSelector();
        Case__x externalCase = CrmComplaintIntegrationTestDataFactory.createExternalCase();

        List<SObject> records;
        Test.startTest();
        records = testSelector.filterCases(new List<Case__x> { externalCase });
        Test.stopTest();
        
        System.assertEquals(1, records.size());
    }

    public class TestExternalObjectSelector extends ExternalObjectSelector {
        /*Required by fflib*/
        public List<Schema.SObjectField> getSObjectFieldList() {
            return new List<Schema.SObjectField> ();
        }

        /*Required by fflib*/
        public Schema.SObjectType getSObjectType() {
            return Account.SObjectType;
        }
    }
}