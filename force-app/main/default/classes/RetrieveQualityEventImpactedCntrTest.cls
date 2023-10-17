@isTest
public class RetrieveQualityEventImpactedCntrTest {
 @isTest static void retrieveQualityEvent() {
     test.startTest();
     Test.setMock(HttpCalloutMock.class, new RunFileInformationControllerOauth2Mock());
     Test.setMock(WebServiceMock.class, new RetrieveQualityEventImpactedCntrMock());
     RetrieveQualityEventImpactedController.RetrieveQualityEvent('58378648');
     test.stopTest();
    }
}