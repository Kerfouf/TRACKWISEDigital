public class QualityEventController {
    @AuraEnabled(cacheable=true)
    public static List<String> createQualityEvent(List<Impacted_Lot_SN__c> Impacted_LotSNList) {
        system.debug('enter createQualityEvent');
        system.debug('Impacted_LotSNList:'+Impacted_LotSNList);
        List<String> results = new List<String>();
        Map<String,String> inputHttpHeaders_x = new Map<String,String>();
        QualityEvent.QualityEventSoap_soap service = new QualityEvent.QualityEventSoap_soap();
        QualityEvent.SubmitQualityEventRequest request = new  QualityEvent.SubmitQualityEventRequest();
        List<QualityEvent.SubmitImpactedItem> ImpactedItemList = new List<QualityEvent.SubmitImpactedItem>();
        for(Impacted_Lot_SN__c sn : Impacted_LotSNList){
            QualityEvent.SubmitImpactedItem ImpactedItem = new QualityEvent.SubmitImpactedItem();
            ImpactedItem.PartNumber = sn.Item_Number__c;
            ImpactedItem.LotNumber = sn.Lot_Serial_Number__c;
            ImpactedItem.Disposition = sn.Dispositions__c;
            ImpactedItemList.add(ImpactedItem);
        }
        QualityEvent.ArrayOfSubmitImpactedItem ArrayOfImpactedItem = new QualityEvent.ArrayOfSubmitImpactedItem();
        ArrayOfImpactedItem.SubmitImpactedItem = ImpactedItemList;
        if(ImpactedItemList.size()>0){
            request.QualityEventId = Impacted_LotSNList[0].Related_Quality_Event__r.Name;
            request.Status = Impacted_LotSNList[0].Related_Quality_Event__r.CMPL123_WF_Status__c;  
        }
        request.ImpactedItems = ArrayOfImpactedItem;

        inputHttpHeaders_x.put('Authorization', 'Bearer '+getToken());
        service.inputHttpHeaders_x = inputHttpHeaders_x;
        system.debug('request:'+request); 
        QualityEvent.QualityEventResponse response = service.SubmitQualityEvent(request);
        system.debug('response:'+response);
        return results;
    }
    
    public static string getToken() {
        Webservice_Authentification__mdt authentification_details = Webservice_Authentification__mdt.getInstance('CreateQualityEvent');
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
}