/**
 * @File Name          : SapProductInformationController.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 2/11/2020, 10:51:43 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/10/2020   Jon Astemborski     Initial Version
**/
public without sharing class SapProductInformationController {
    public SapProductInformationController() {

    }

    public static void handleUpdateAfterProductImpacted(Map<Id,CMPL123QMS__Change_Control__c> newMap, Map<Id,CMPL123QMS__Change_Control__c> oldMap){
        List<SAP_Product_Information__c> productInformationList = new List<SAP_Product_Information__c>();
        List<CMPL123QMS__Change_Control__c> ccList = new List<CMPL123QMS__Change_Control__c>();
        for ( CMPL123QMS__Change_Control__c cc : newMap.values()){
            if ( oldMap.get(cc.id).Product_Impacted__c != null && oldMap.get(cc.id).Product_Impacted__c != newMap.get(cc.id).Product_Impacted__c) {
                String prodImpacted = cc.Product_Impacted__c != null ? cc.Product_Impacted__c.toUpperCase() : '';
                if ( String.isBlank(prodImpacted) || prodImpacted.contains('NO') ||  prodImpacted.toUpperCase().equals('YES – SINGLE ITEM IMPACTED') ||
                   		prodImpacted.equals('YES – MULTIPLE ITEMS IMPACTED')) {
                    productInformationList = [SELECT Id FROM SAP_Product_Information__c WHERE Change_Control__c =: cc.id];
                    System.debug('list: ' + productInformationList);
                    cc.Product_Item_Number__c = '';
                    cc.Product_Item_Description__c = '';
                    cc.Product_Range__c = '';
                    cc.Global_Trade_Identification_Number__c = '';
                    cc.CE_Approved__c = '';
                    cc.Product_Type__c = '';
                    cc.Make_or_Buy__c = '';
                    cc.Trade_Type__c = '';
                    cc.Legal_Manufacturer__c = '';
                    cc.Site_Responsible__c = '';
                    cc.Commercialization_Coverage__c = '';
                    cc.Origin__c = '';
                }
            }
            if (! productInformationList.isEmpty() ){
                delete productInformationList;
                system.debug('delete');
            }
        }
        
    }
}