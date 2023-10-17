/**
 * @File Name          : SapRelatedProductsHandler_Test.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 6/9/2020, 10:53:27 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/9/2020   Jon Astemborski     Initial Version
**/
@IsTest
public class SapRelatedProductsHandler_Test {
    @IsTest
    public static void removeRecords_test() {
        SapRelatedProductsHandler handler = new SapRelatedProductsHandler();
        List<SAP_Product_Information__c> testList = new List<SAP_Product_Information__c>{new SAP_Product_Information__c()};
        SapRelatedProductsHandler.removeRecords(testList);
    }

    @IsTest
    public static void retrieveSapProductInformation_test() {
        Id ccRecType = Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = TestSetup.createCC(true, ccRecType);
        List<SAP_Product_Information__c> testList = SapRelatedProductsHandler.retrieveSapProductInformation(cc.id);
    }

    @IsTest
    public static void areMultipleProductsImpacted_test() {
        Id ccRecType = Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = TestSetup.createCC(true, ccRecType);
        cc.Product_Impacted__c = 'YES – MULTIPLE ITEMS IMPACTED';
        Boolean multProductsImpacted = SapRelatedProductsHandler.areMultipleProductsImpacted(cc.id);
    }
}