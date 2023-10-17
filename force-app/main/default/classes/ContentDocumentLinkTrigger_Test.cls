/**
 * @description       : 
 * @author            : Jon Astemborski
 * @group             : 
 * @last modified on  : 08-24-2020
 * @last modified by  : Jon Astemborski
 * Modifications Log 
 * Ver   Date         Author            Modification
 * 1.0   08-24-2020   Jon Astemborski   Initial Version
**/
@isTest
public class ContentDocumentLinkTrigger_Test {
    
@isTest
public static void contentdocumentlink_dmlupdates() {
        Account acc = TestSetup.createAccount(true);
        ContentVersion cv = new ContentVersion();
        cv.Title = 'Test Document';
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf('Test Content');
        cv.IsMajorVersion = true;
        Insert cv;

        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cv.Id].ContentDocumentId;
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = acc.Id;
        cdl.ContentDocumentId = conDocId;
        cdl.shareType = 'V';
        Insert cdl;
        update cdl;
        delete cdl;

    }
}