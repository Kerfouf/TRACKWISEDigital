@isTest
global class MyWebServiceMock implements WebServiceMock {
    
    global void doInvoke(
        Object stub, 
        Object request, 
        Map<String, Object> response, 
        String endpoint, 
        String soapAction,
        String requestName, 
        String responseNS, 
        String responseName, 
        String responseType) {
        
        RunFileInformation.RunFileInformationResult result = new RunFileInformation.RunFileInformationResult();
        result.PouchLotNumber = '230203CR_E';
        result.InstrumentID = 'FA1113';
        result.ResponseCode = '0';
        result.ResponseMessage = 'Success';
        
        RunFileInformation.GetRunFileInformationResponse_element responseElement = new RunFileInformation.GetRunFileInformationResponse_element();
        responseElement.GetRunFileInformationResult = result;
        
        response.put('response_x', responseElement);
    }
}