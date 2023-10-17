public with sharing class GenerateTrendReportController {
    public static final String GENERATED_TREND_REPORT_PDF_VISUALFORCE_URL = '/apex/TrendReportPDFGeneration';
    
    @AuraEnabled
    public static void attachPdfToRecord(Id recordId){
        // Get Trend Report
        Trend_Report__c record = [Select id, Name FROM Trend_Report__c WHERE Id = :recordId];
        
        System.System.debug('Generating Blob with record Id ' + record.Id + ' Name: ' + record.Name);
        Blob pdfAsABlob = getPdfAsABlob(record);
        System.System.debug('Generating ContentVersion');
        ContentVersion version = generateContentVersion(pdfAsABlob, record);
        System.System.debug('Generating ContentDocumentLink with Version Id ' + version.Id);
        ContentDocumentLink cdlToInsert = generateContentDocumentLink(record,version);
        System.System.debug('Inserting ContentDocumentLink  Id ' + cdlToInsert.Id);
        insert cdlToInsert;
        //return true;
    }
    @TestVisible
    private static Blob getPdfAsABlob(Trend_Report__c trendReport){
        // create a virtual page
        PageReference page = new PageReference(GENERATED_TREND_REPORT_PDF_VISUALFORCE_URL);
        // add our record id
        page.getParameters().put('Id', trendReport.Id);
        // generate and PDF blob and return it

        if(Test.isRunningTest()){
            return blob.valueOf('Unit.Test');
        }else{
            return page.getContentAsPDF();
        }        
    }
    
    @TestVisible
    private static ContentVersion generateContentVersion(Blob pdfAsABlob, Trend_Report__c record){
        ContentVersion newVersion = new ContentVersion();
        newVersion.PathOnClient  = generateFileName(record);
        newVersion.Title = generateTitle(record);
        newVersion.VersionData = pdfAsABlob;        
        insert newVersion;
        // We need to request the just inserted ContentVersion to get the ContentDocumentId just generated, since it will be used further
        return [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :newVersion.Id LIMIT 1];
    }

    @TestVisible
    private static ContentDocumentLink generateContentDocumentLink(Trend_Report__c record, ContentVersion version){
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.LinkedEntityId = record.Id;
        cdl.ContentDocumentid = version.ContentDocumentid;
        cdl.ShareType = 'V';
        return cdl;
    }
    @TestVisible
    private static String generateFileName(Trend_Report__c record){        
        return generateTitle(record) + '.pdf';
    }

    @TestVisible
    private static String generateTitle(Trend_Report__c record){
        
        DateTime todaysDate = System.today();
        String todaysDateStr = todaysDate.format('yyyy-MM-dd');
        return 'eu_trend_report_' + record.Name + '_' + todaysDateStr;
    }
    
}