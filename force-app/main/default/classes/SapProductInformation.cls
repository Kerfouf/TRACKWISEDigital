/**
 * @File Name          : SapProductInformation.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 1/15/2020, 3:53:46 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/15/2020   Jon Astemborski     Initial Version
**/

public class SapProductInformation {
    @AuraEnabled
    public String productItemNumber {get;set;}
    @AuraEnabled
    public String productDescription {get;set;}
    @AuraEnabled
    public String productRange {get;set;}
    @AuraEnabled
    public String productType {get;set;}
    @AuraEnabled
    public String makeOrBuy {get;set;}
    @AuraEnabled
    public String tradeType {get;set;}
    @AuraEnabled
    public String legalManufacturer {get;set;}
    @AuraEnabled
    public String siteResponsible {get;set;}
    @AuraEnabled
    public String gtin {get;set;}
    @AuraEnabled
    public String ceApproved {get;set;}
    @AuraEnabled
    public String commercializationCoverage {get;set;}
    @AuraEnabled
    public String originAnimalHuman {get;set;}

    private static final String SAP_PRODUCT_ITEM_NUM = 'Product';
    private static final String SAP_PRODUCT_ITEM_DESCRIPTION = 'ProductDescription';
    private static final String SAP_PRODUCT_RANGE = 'ProductRange';
    private static final String SAP_GTIN = 'ProductStandardID';

    private static final String SAP_CE_Approved = 'CE_MARKED';
    private static final String SAP_PRODUCT_TYPE = 'MARKET_TYPE'; 
    private static final String SAP_MAKE_OR_BUY = 'MAKE_BUY';
    private static final String SAP_TRADE_TYPE = 'TRADE_TYPE';
    private static final String SAP_LEGAL_MANUFACTURER = 'LEGAL_MANUFACTURER';
    private static final String SAP_SITE_RESPONSIBLE = 'SITE_RESPONSIBLE';
    private static final String SAP_COMMERCIALIZATION_CHANGE= 'LOCAL_MARKET'; 
    private static final String SAP_HUMAN_ANIMAL_ORIGIN = 'HA_ORIGIN';

    public SapProductInformation() {
        productItemNumber = '';
        productDescription = '';
        productRange = '';
        productType = '';
        makeOrBuy = '';
        tradeType = '';
        legalManufacturer = '';
        siteResponsible = '';
        gtin = '';
        ceApproved = '';
        commercializationCoverage = '';
        originAnimalHuman = '';
    }

    public override String toString(){
        return 'Item Num: ' + this.productItemNumber + ' \nDescription: ' + this.productDescription + ' \nRange: ' + this.productRange + ' \nCEApproved: ' + 
        this.ceApproved + ' \nProductType: ' + this.productType + ' \nmakeorbuy:' + this.makeOrBuy + ' \nSite Responsible' + this.siteResponsible;
    }

    public void buildFromString(String fieldName, String value){
        switch on fieldName{
            when 'CE_MARKED'{
                this.ceApproved = value;
            }
            when 'MARKET_TYPE'{
                this.productType = value;
            }
            when 'MAKE_BUY'{
                this.makeOrBuy = value;
            }
            when 'TRADE_TYPE'{
                this.tradeType = value;
            }
            when 'LEGAL_MANUFACTURER'{
                this.legalManufacturer = value;
            }
            when 'SITE_RESPONSIBLE'{
                this.siteResponsible = value;
            }
            when 'LOCAL_MARKET'{
                this.commercializationCoverage = value;
            }
            when 'HA_ORIGIN'{
                this.originAnimalHuman = value;
            }
        }
    }

    public SapProductInformation(Builder builder){
        this.productItemNumber = builder.productItemNumber; 
        this.productDescription = builder.productDescription; 
        this.productRange = builder.productRange; 
        this.productType = builder.productType; 
        this.makeOrBuy = builder.makeOrBuy; 
        this.tradeType = builder.tradeType; 
        this.legalManufacturer = builder.legalManufacturer; 
        this.siteResponsible = builder.siteResponsible; 
        this.gtin = builder.gtin; 
        this.ceApproved = builder.ceApproved; 
        this.commercializationCoverage = builder.commercializationCoverage; 
        this.originAnimalHuman = builder.originAnimalHuman; 
    }

    public class Builder{
        @AuraEnabled
        public String productItemNumber {get;set;}
        @AuraEnabled
        public String productDescription {get;set;}
        @AuraEnabled
        public String productRange {get;set;}
        @AuraEnabled
        public String productType {get;set;}
        @AuraEnabled
        public String makeOrBuy {get;set;}
        @AuraEnabled
        public String tradeType {get;set;}
        @AuraEnabled
        public String legalManufacturer {get;set;}
        @AuraEnabled
        public String siteResponsible {get;set;}
        @AuraEnabled
        public String gtin {get;set;}
        @AuraEnabled
        public String ceApproved {get;set;}
        @AuraEnabled
        public String commercializationCoverage {get;set;}
        @AuraEnabled
        public String originAnimalHuman {get;set;}

        public Builder(SapProductInformation product){
            this.productItemNumber = product.productItemNumber; 
            this.productDescription = product.productDescription; 
            this.productRange = product.productRange; 
            this.productType = product.productType; 
            this.makeOrBuy = product.makeOrBuy; 
            this.tradeType = product.tradeType; 
            this.legalManufacturer = product.legalManufacturer; 
            this.siteResponsible = product.siteResponsible; 
            this.gtin = product.gtin; 
            this.ceApproved = product.ceApproved; 
            this.commercializationCoverage = product.commercializationCoverage; 
            this.originAnimalHuman = product.originAnimalHuman; 
        }

        public Builder productItemNumber(String val){
            this.productItemNumber = val; return this;
        }

        public Builder productDescription(String val){
            this.productDescription = val; return this;
        }

        public Builder productRange(String val){
            this.productRange = val; return this;
        }

        public Builder productType(String val){
            this.productType = val; return this;
        }

        public Builder makeOrBuy(String val){
            this.makeOrBuy = val; return this;
        }

        public Builder tradeType(String val){
            this.tradeType = val; return this;
        }

        public Builder legalManufacturer(String val){
            this.legalManufacturer = val; return this;
        }

        public Builder siteResponsible(String val){
            this.siteResponsible = val; return this;
        }

        public Builder gtin(String val){
            this.gtin = val; return this;
        }

        public Builder ceApproved(String val){
            this.ceApproved = val; return this;
        }

        public Builder commercializationCoverage(String val){
            this.commercializationCoverage = val; return this;
        }

        public Builder originAnimalHuman(String val){
            this.originAnimalHuman = val; return this;
        }
    
        public SapProductInformation build(){
            return new SapProductInformation(this);
        }
    }
}