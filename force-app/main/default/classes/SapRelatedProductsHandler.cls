/**
 * @File Name          : SapRelatedProductsHandler.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 2/11/2020, 9:44:31 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/10/2020   Jon Astemborski     Initial Version
**/
public without sharing class SapRelatedProductsHandler {
    @AuraEnabled
    public static List<SAP_Product_Information__c> productInformationList {get; set;} 

    @AuraEnabled
    public static String recordId {get;set;}
    
    public SapRelatedProductsHandler() {
        productInformationList = new List<SAP_Product_Information__c>();
    }

    @AuraEnabled
    public static void removeRecords(List<SAP_Product_Information__c> sapRecords){
        try{
       delete sapRecords;
        }
        catch (Exception e)
        {
            System.debug(e);
        }
    }

    @AuraEnabled
    public static List<SAP_Product_Information__c> retrieveSapProductInformation(String recordId){
       return [SELECT Id, Product_Item_Number__c, Product_Item_Description__c FROM SAP_Product_Information__c WHERE change_control__c =: recordId];
    }

    @AuraEnabled
    public static boolean areMultipleProductsImpacted(String recordId){
        CMPL123QMS__Change_Control__c cc = [SELECT Id, Product_Impacted__c FROM CMPL123QMS__Change_Control__c  WHERE id =: recordId limit 1];
        if (cc.Product_Impacted__c  != null ) {
            return cc.Product_Impacted__c.toUpperCase().equals('YES – MULTIPLE ITEMS IMPACTED') ? true : false;
        }
        return false;
    }
}