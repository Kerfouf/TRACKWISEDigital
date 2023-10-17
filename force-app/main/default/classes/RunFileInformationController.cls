public class RunFileInformationController {
    @AuraEnabled(cacheable=true)
    public static String GetRunFileInformation( String serialNumber) {//System.Continuation continuation,
        Map<String,String> inputHttpHeaders_x = new Map<String,String>();
        RunFileInformation.RunFileInformationSoap_soap service = new RunFileInformation.RunFileInformationSoap_soap();
        inputHttpHeaders_x.put('Authorization', 'Bearer '+getToken());
        service.inputHttpHeaders_x = inputHttpHeaders_x;
        Map<String,Object> results = new Map<String,Object>();
        try{
            RunFileInformation.RunFileInformationResult response = service.GetRunFileInformation(serialNumber); 
            if(response.InstrumentID != null && response.PouchLotNumber!= null){
                results.put('serialNumber',serialNumber);
                results.put('InstrumentID',response.InstrumentID);
                results.put('PouchLotNumber',response.PouchLotNumber); 
            }else{
                results = null;
            }         
        }catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
        return JSON.serialize(results); 
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
        HTTPResponse response = http.send(req);
        if(response.getStatusCode() == 200){
            Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            token = (string)results.get('access_token');
        }
        return token;
    }
}