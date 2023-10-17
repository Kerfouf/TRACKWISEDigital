@isTest
public with sharing class GenerateTrendReportTest {
    private static final String IDENTIFIER = 'this.very.unique.email.exist.for.test.purpose@test-me.com';


    @TestSetup
    public static void makeData(){
        Trend_Report__c report = new Trend_Report__c();
        report.BMX_How_Many_And_Which__c = IDENTIFIER;
        insert report;
    }
    
    
    @isTest
    public static void test_getPdfAsABlob(){
        Trend_Report__c report = [Select Id, Name from Trend_Report__c WHERE BMX_How_Many_And_Which__c = :IDENTIFIER];
        Blob myBlob = GenerateTrendReportController.getPdfAsABlob(report);
        System.assertNotEquals(null, myBlob, 'For a given record, the Blob that represent the PDF is expected not to be null');
    }

    @isTest
    public static void test_generateContentVersion(){
        Trend_Report__c report = [Select Id, Name from Trend_Report__c WHERE BMX_How_Many_And_Which__c = :IDENTIFIER];
        Blob myBlob = GenerateTrendReportController.getPdfAsABlob(report);

        ContentVersion cv = GenerateTrendReportController.generateContentVersion(myBlob,report);
        System.assertNotEquals(null, cv.ContentDocumentId, 'The ID should not be null since the ContentVersion should have been inserted');
    }


    @isTest
    public static void test_generateContentDocumentLink(){
        Trend_Report__c report = [Select Id, Name from Trend_Report__c WHERE BMX_How_Many_And_Which__c = :IDENTIFIER];
        Blob myBlob = GenerateTrendReportController.getPdfAsABlob(report);

        ContentVersion cv = GenerateTrendReportController.generateContentVersion(myBlob,report);
        ContentDocumentLink cdl = GenerateTrendReportController.generateContentDocumentLink(report,cv);

        System.assertEquals(report.Id, cdl.LinkedEntityId, 'The Linked Entity Id should be the Trend Report');
        System.assertEquals(cv.ContentDocumentid, cdl.ContentDocumentid, 'The ContentDocumentid should be the same');
        System.assertEquals('V', cdl.ShareType);
    }
    @isTest
    public static void test_TitleAndFileName(){
        Trend_Report__c report = [Select Id, Name from Trend_Report__c WHERE BMX_How_Many_And_Which__c = :IDENTIFIER];
        String title = GenerateTrendReportController.generateTitle(report);
        String fileName = GenerateTrendReportController.generateFileName(report);

        System.assertEquals(fileName, title + '.pdf');
    }

    @isTest
    public static void total_Full_Test(){
        Trend_Report__c report = [Select Id, Name from Trend_Report__c WHERE BMX_How_Many_And_Which__c = :IDENTIFIER];
        GenerateTrendReportController.attachPdfToRecord(report.Id);
        
        ContentDocumentLink cdl = [SELECT Id, LinkedEntityId FROM ContentDocumentLink WHERE LinkedEntityId = :report.Id];

        System.assertNotEquals(null, cdl, 'a ContentDocumentLink should have been added');
    }


}