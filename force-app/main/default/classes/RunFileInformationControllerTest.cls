@isTest
public class RunFileInformationControllerTest {
 @isTest static void testRunFile() {
     test.startTest();
     Test.setMock(HttpCalloutMock.class, new RunFileInformationControllerOauth2Mock());
     Test.setMock(WebServiceMock.class, new RunFileInformationControllerMock());
     RunFileInformationController.GetRunFileInformation('58378648');
     test.stopTest();
    }
}