public class RetrieveQualityEventImpactedController {
    @AuraEnabled(cacheable=true)
    public static List<Impacted_Lot_SN__c> RetrieveQualityEvent( String lotNumber) {
        Map<String,Object> results = new Map<String,Object>();
        Map<String,String> inputHttpHeaders_x = new Map<String,String>();
        List<Impacted_Lot_SN__c> impactedLotSNList = new List<Impacted_Lot_SN__c>();
        RetrieveQualityEventImpacted.RetrieveQualityEventImpactedLotDataSoap_soap service = new RetrieveQualityEventImpacted.RetrieveQualityEventImpactedLotDataSoap_soap();
        inputHttpHeaders_x.put('Authorization', 'Bearer '+getToken());
        service.inputHttpHeaders_x = inputHttpHeaders_x;
        try{
            RetrieveQualityEventImpacted.QualityEventImpactedLotData response = service.RetrieveQualityEventImpactedLotData(lotNumber); 
            system.debug('response1:'+response);
            if(response.ItemNumber !=null){
            Impacted_Lot_SN__c newImpactedLotSN = new Impacted_Lot_SN__c();
			newImpactedLotSN.Item_Number__c = response.ItemNumber;
            newImpactedLotSN.Item_Description__c = response.ItemDescription;
            newImpactedLotSN.Lot_Serial_Number__c = response.SupplierLotOrSerialNumber;
            newImpactedLotSN.Date_of_Manufacture_Receipt__c = date.today();//!String.isBlank(response.DateOfManufactureOrReceipt)?date.parse(response.DateOfManufactureOrReceipt):newImpactedLotSN.Date_of_Manufacture_Receipt__c;
            newImpactedLotSN.Supplier_Name__c = response.SupplierName;
            newImpactedLotSN.Supplier_Number__c = response.SupplierNumber;
            newImpactedLotSN.Unit_of_Measure__c = response.UnitOfMeasure;
            newImpactedLotSN.Item_Number_Revision__c = response.ItemNumberRevision;
            newImpactedLotSN.Order_Number__c = response.OrderNumber;
            newImpactedLotSN.Total_Quantity__c = response.TotalQuantityPotentiallyImpacted;
            impactedLotSNList.add(newImpactedLotSN); 
                system.debug('newImpactedLotSN:'+newImpactedLotSN);
            }
            system.debug('impactedLotSNList:'+impactedLotSNList);
            /*
            system.debug('response:'+response);
            results.put('ItemDescription',response.ItemDescription);
            results.put('SupplierLotOrSerialNumber',response.SupplierLotOrSerialNumber);
            results.put('SupplierName',response.SupplierName);
            results.put('SupplierNumber',response.SupplierNumber);
            results.put('OrderNumber',response.OrderNumber);
            results.put('DateOfManufactureOrReceipt',response.DateOfManufactureOrReceipt);
            results.put('UnitOfMeasure',response.UnitOfMeasure);
            results.put('ItemNumberRevision',response.ItemNumberRevision);
            results.put('TotalQuantityPotentiallyImpacted',response.TotalQuantityPotentiallyImpacted);
            results.put('ResponseCode',response.ResponseCode);
            system.debug('results:'+results);
*/
        }
        catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return impactedLotSNList;
    }
    
    public static string getToken() {
        Webservice_Authentification__mdt authentification_details = Webservice_Authentification__mdt.getInstance('SCPI_RunFileData');
        string token='';
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Content-Type','application/x-www-form-urlencoded');
        req.setHeader( 'Accept', '*/*');
        req.setHeader( 'Accept-Encoding', 'gzip, deflate, br');
        req.setHeader( 'Content-Lengt', '127');
        req.setEndpoint(authentification_details.endpoint__c);
        String CLIENT_ID = authentification_details.client_id__c;
        String CLIENT_SECRET = authentification_details.client_secret__c;
        String authentication = CLIENT_ID+':'+CLIENT_SECRET;
        req.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(authentication)));
        req.setBody('grant_type=client_credentials'+'&client_id='+CLIENT_ID +'&client_secret='+CLIENT_SECRET);
        Http http = new Http();
        System.debug('req ' + req);
        HTTPResponse response = http.send(req);
        System.debug('response ' + response);
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            token = (string)results.get('access_token');
        }
        System.debug('Body ' + response.getBody());
        System.debug('Status ' + response.getStatus());
        System.debug('Status code ' + response.getStatusCode());
        System.debug('token ' + token);
        return token;
    }
    @AuraEnabled
    public static void createImpactLot(List<Impacted_Lot_SN__c> selectedResults, Id qualityEventId) {
        system.debug('selectedResults :'+selectedResults);
        system.debug('qualityEventId :'+qualityEventId);
        Id impactedLotRecordTypeId = Schema.SObjectType.Impacted_Lot_SN__c.getRecordTypeInfosByDeveloperName().get('PW_Impacted_Lot').getRecordTypeId();
        system.debug('impactedLotRecordTypeId :'+impactedLotRecordTypeId);
        for(Impacted_Lot_SN__c loopImpactedLot : selectedResults){
            loopImpactedLot.recordTypeId = impactedLotRecordTypeId;
            loopImpactedLot.Related_Quality_Event__c = qualityEventId;
        }
        system.debug('selectedResults save:'+selectedResults);
        insert selectedResults;
    }
}