@isTest
global class RunFileInformationControllerMock implements WebServiceMock {
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
        // start - specify the response you want to send
        //RunFileInformation.RunFileInformationSoap_soap response_x = new RunFileInformation.RunFileInformationSoap_soap();
               RunFileInformation.RunFileInformationResult GetRunFileInformationResult = new RunFileInformation.RunFileInformationResult();
               GetRunFileInformationResult.InstrumentID = '220323QB_E';
               GetRunFileInformationResult.PouchLotNumber = 'TM18619';
               RunFileInformation.GetRunFileInformationResponse_element response_x = new RunFileInformation.GetRunFileInformationResponse_element();
               response_x.GetRunFileInformationResult = GetRunFileInformationResult;
            //RunFileInformation.GetRunFileInformationResponse_element 
        //response_x.return_x = 3.0;
        // end
        response.put('response_x', response_x); 
   }
}