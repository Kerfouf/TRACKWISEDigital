@isTest
global class RetrieveQualityEventImpactedCntrMock implements WebServiceMock{
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
        	   //RetrieveQualityEventImpacted.RetrieveQualityEventImpactedLotData req = new RetrieveQualityEventImpacted.RetrieveQualityEventImpactedLotData('58378648');
               //req.lotNumber = '58378648';
               RetrieveQualityEventImpacted.QualityEventImpactedLotData response_x = new RetrieveQualityEventImpacted.QualityEventImpactedLotData();
               response_x.ItemNumber = '';
               response_x.ItemDescription = '';
               response_x.SupplierLotOrSerialNumber = '';
               response_x.SupplierName = '';
               response_x.SupplierNumber = '';
               response_x.OrderNumber = '';
               response_x.DateOfManufactureOrReceipt = '';
               response_x.UnitOfMeasure = '';
               response_x.ItemNumberRevision = '';
               response_x.TotalQuantityPotentiallyImpacted = 0;
               response_x.ResponseCode = '';
               response_x.ResponseMessage = '';
        response.put('response_x', response_x); 
   }
}