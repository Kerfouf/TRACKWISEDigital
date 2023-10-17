public with sharing class SearchProductsInSAPController {

    private static final Integer SAP_QUERY_SIZE_LIMIT = 100;
    
    @AuraEnabled(cacheable=false)
    public static List<Impacted_Lot_SN__c> searchProducts(String materialNumber, String batchNumber, String serialNumber){
        // Search by batch number
        SAPProductRequestAdaptor adaptor;
        if(String.isNotBlank(batchNumber)){
            adaptor = new BatchNumberSearch(materialNumber, batchNumber);            
        }
        else{
            adaptor = new SerialNumberSearch(materialNumber, serialNumber);
            
        }        
        try {
            return adaptor.retrieveResults();
        } catch (System.QueryException e) {
            throw new SAPRequestException(e.getCause());
        }        
    }

    @AuraEnabled
    public static void createImpactedLotsFromSAPProducts(List<Impacted_Lot_SN__c> selectedResults, Id qualityEventId){
        Id impactedLotRecordTypeId = retrieveSAPProductImpactedLotRecordType();
        for(Impacted_Lot_SN__c loopImpactedLot : selectedResults){
            loopImpactedLot.recordTypeId = impactedLotRecordTypeId;
            loopImpactedLot.Related_Quality_Event__c = qualityEventId;
        }
        insert selectedResults;
    }


    private static Id retrieveSAPProductImpactedLotRecordType(){
        return Schema.SObjectType.Impacted_Lot_SN__c.getRecordTypeInfosByDeveloperName().get('SAP_Impacted_Lot').getRecordTypeId();
    }
   

    public class BatchNumberSearch extends SAPProductRequestAdaptor{

        public BatchNumberSearch(String p_materialNumber, String p_batchOrSerialNumber){
            super(p_materialNumber, p_batchOrSerialNumber);
        }

        public override List<Impacted_Lot_SN__c> retrieveResults(){
            List<materialDocumentItems__x> matDocList = listMatDocs(materialNumber, batchOrSerialNumber, '920');
            if(matDocList == null || matDocList.isEmpty()){
                matDocList = listMatDocs(materialNumber,batchOrSerialNumber, '101');
            }
            // If nothing return empty list
            if(matDocList == null || matDocList.isEmpty()){
                return new List<Impacted_Lot_SN__c>();
            }
            List<Impacted_Lot_SN__c> impactedLotsToReturn =  transformSAPInfoInImpactedLots(matDocList);
            return impactedLotsToReturn;
        }

        public override Impacted_Lot_SN__c transformMaterialDocumentItemInImpactedLot(materialDocumentItems__x sapProduct){
            Impacted_Lot_SN__c transformedImpactedLot = super.transformMaterialDocumentItemInImpactedLot(sapProduct);            
            // Functional requirement: The Serial Nomber shloud be set
            transformedImpactedLot.Supplier_Lot_Serial_Number__c = sapProduct.vendorBatch__c;
            
            // Override date only if manufacturing date not null
            if(sapProduct.manufacturingDate__c != null){
                transformedImpactedLot.Date_of_Manufacture_Receipt__c = sapProduct.manufacturingDate__c.date();
            }
            
            return transformedImpactedLot;
        }
        
        private List<materialDocumentItems__x> listMatDocs(String matNum, String batchOrSerialNumber, String goodsMovementType){
            if(Test.isRunningTest()){
                List<materialDocumentItems__x> testListToReturn = new List<materialDocumentItems__x>();
                return testListToReturn;

            }
            return [SELECT
                        manufacturingDate__c,vendorBatch__c,postingDate__c,batch__c,material__c,materialDescription__c,supplierName__c,supplier__c,materialBaseUnit__c, catalogProfile__c, catalogProfileTxt__c
                    FROM materialDocumentItems__x
                    WHERE
                        docLanguage__c ='EN'
                        AND
                        goodsMovementType__c = :goodsMovementType
                        AND
                        material__c = :matNum
                        AND
                        batch__c = :batchOrSerialNumber
                    ORDER BY
                        postingDate__c ASC
                    LIMIT 1
            ];
        }

    }


    public class SerialNumberSearch extends SAPProductRequestAdaptor {

        public SerialNumberSearch(String p_materialNumber, String p_batchOrSerialNumber){
            super(p_materialNumber, p_batchOrSerialNumber);
        }

        public override List<Impacted_Lot_SN__c> retrieveResults(){
            List<materialDocumentSerial__x> materialDocSerials = retrieveMaterialDocSerials();
            // Handle empty
            if(materialDocSerials == null || materialDocSerials.isEmpty()){
                return new List<Impacted_Lot_SN__c>();
            }            
            
            Map<String, materialDocumentSerial__x> filteredMap = new Map<String, materialDocumentSerial__x>();
            for(materialDocumentSerial__x loopMaterialDocSerial : materialDocSerials){
                String key = loopMaterialDocSerial.materialDocument__c + '#'+ loopMaterialDocSerial.materialDocumentItem__c + '#'+ loopMaterialDocSerial.materialDocumentYear__c + '#';
                filteredMap.put(key, loopMaterialDocSerial);                
            }
            


            String externalObjectSOQLQuery = 'SELECT postingDate__c,batch__c,material__c,materialDescription__c,supplierName__c,supplier__c,materialBaseUnit__c, catalogProfile__c, catalogProfileTxt__c FROM materialDocumentItems__x WHERE';

            String whereClause = '';
            for(materialDocumentSerial__x loopMaterialDocSerial : filteredMap.values()){                
                if(String.isNotBlank(whereClause)){
                    whereClause += ' OR ';
                }
                String loopWhere = ' (';
                loopWhere += 'materialDocument__c =\'' + loopMaterialDocSerial.materialDocument__c + '\' ';
                loopWhere += 'AND ';
                loopWhere += 'materialDocumentItem__c =\'' + loopMaterialDocSerial.materialDocumentItem__c + '\' ';
                loopWhere += 'AND ';
                loopWhere += 'materialDocumentYear__c =\'' + loopMaterialDocSerial.materialDocumentYear__c + '\' ';
                loopWhere += ') ';

                whereClause += loopWhere;
            }
            whereClause += ' AND docLanguage__c =\'EN\'';
            String finalQuery = externalObjectSOQLQuery + whereClause + ' LIMIT ' + SAP_QUERY_SIZE_LIMIT;
            
            // Test purpose
            if(Test.isRunningTest()){
                return new List<Impacted_Lot_SN__c>();
            }
            List<materialDocumentItems__x> matDocList = Database.query(finalQuery);
            List<Impacted_Lot_SN__c> impactedLotsToReturn =  transformSAPInfoInImpactedLots(matDocList);
            return  impactedLotsToReturn;                        
        }

        public override Impacted_Lot_SN__c transformMaterialDocumentItemInImpactedLot(materialDocumentItems__x sapProduct){
            Impacted_Lot_SN__c transformedImpactedLot = super.transformMaterialDocumentItemInImpactedLot(sapProduct);            
            // Functional requirement: The Serial Nomber shloud be set
            transformedImpactedLot.Lot_Serial_Number__c = this.batchOrSerialNumber;
            return transformedImpactedLot;
        }


        private List<materialDocumentSerial__x> retrieveMaterialDocSerials(){
            // Testing purpose
            if(Test.isRunningTest()){
                List<materialDocumentSerial__x> testList = new List<materialDocumentSerial__x>();
                materialDocumentSerial__x serial = new materialDocumentSerial__x(materialDocument__c= '123', materialDocumentItem__c = '456', materialDocumentYear__c = '2022');                
                testList.add(serial);
                return testList;

            }
            
            return [
                SELECT
                    materialDocument__c, materialDocumentItem__c, materialDocumentYear__c
                FROM
                    materialDocumentSerial__x
                WHERE
                serialNumber__c = :batchOrSerialNumber
                AND
                material__c = :materialNumber
                AND
                docLanguage__c ='EN'
                AND
                movementType__c IN ('101','920')                                
            ];
        }
        
    }


    public abstract class SAPProductRequestAdaptor {
        protected String materialNumber;
        protected String batchOrSerialNumber;
        
        public SAPProductRequestAdaptor(String p_materialNumber, String p_batchOrSerialNumber){
            this.materialNumber = p_materialNumber;
            this.batchOrSerialNumber = p_batchOrSerialNumber;
        }

        private SAPProductRequestAdaptor(){
            // Without parameters constructor should not be used
        }
        
        public abstract List<Impacted_Lot_SN__c> retrieveResults();


        public List<Impacted_Lot_SN__c> transformSAPInfoInImpactedLots(List<materialDocumentItems__x> toTransform){
            List<Impacted_Lot_SN__c> impactedLotsToReturn = new List<Impacted_Lot_SN__c>();
            for(materialDocumentItems__x loopSAPProduct : toTransform){
                Impacted_Lot_SN__c loopImpactedLot =  transformMaterialDocumentItemInImpactedLot(loopSAPProduct);
                impactedLotsToReturn.add(loopImpactedLot);
            }
            return impactedLotsToReturn;
        }

        public virtual Impacted_Lot_SN__c transformMaterialDocumentItemInImpactedLot(materialDocumentItems__x sapProduct){
            Impacted_Lot_SN__c transformedImpactedLot = new Impacted_Lot_SN__c();            
            // Mapping SAP < - > Impacted Lots
            transformedImpactedLot.Date_of_Manufacture_Receipt__c = sapProduct.postingDate__c?.date();
            transformedImpactedLot.Lot_Serial_Number__c = sapProduct.batch__c;        
            transformedImpactedLot.Item_Number__c = sapProduct.material__c;
            transformedImpactedLot.Item_Description__c = sapProduct.materialDescription__c;                       
            transformedImpactedLot.Supplier_Name__c = sapProduct.supplierName__c;                       
            transformedImpactedLot.Supplier_Number__c = sapProduct.supplier__c ;
            transformedImpactedLot.Unit_of_Measure__c = sapProduct.materialBaseUnit__c;           
            transformedImpactedLot.Catalog_Profile_Number__c = sapProduct.catalogProfile__c;            
            transformedImpactedLot.Catalog_Profile_Name__c = sapProduct.catalogProfileTxt__c;

            return transformedImpactedLot;
        }
        
    } 
    
    public class SAPRequestException extends Exception{
        
    }
}