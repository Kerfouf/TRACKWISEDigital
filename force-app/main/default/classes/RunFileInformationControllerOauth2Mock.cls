@isTest
global class RunFileInformationControllerOauth2Mock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"access_token":"sabdasfkjakjfjahajsf"}');
        response.setStatusCode(200);
        return response; 
    }
}