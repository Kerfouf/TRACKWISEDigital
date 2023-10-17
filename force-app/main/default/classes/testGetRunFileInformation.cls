@isTest
private class testGetRunFileInformation {
    @isTest
    static void testGetRunFileInformation() {
        // Set up mock web service
        Test.setMock(WebServiceMock.class, new MyWebServiceMock());

        // Call the web service method
        RunFileInformation.RunFileInformationSoap_soap service = new RunFileInformation.RunFileInformationSoap_soap();
        RunFileInformation.RunFileInformationResult result = service.GetRunFileInformation('58378648');

        // Assert the expected values
        System.assertEquals('230203CR_E', result.PouchLotNumber);
        System.assertEquals('FA1113', result.InstrumentID);
        System.assertEquals('0', result.ResponseCode);
        System.assertEquals('Success', result.ResponseMessage);
    }
}