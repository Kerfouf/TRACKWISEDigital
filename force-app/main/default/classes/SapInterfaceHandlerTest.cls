/**
 * @File Name          : SapInterfaceHandlerTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 1/15/2020, 5:06:28 PM
 * @Modification Log   : 
 * Ver       Date            Author                 Modification
 * 1.0    1/14/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public class SapInterfaceHandlerTest {
    private static final String PRODUCT_PARAM_PREFIX = '?productID=';
    private static final String ESCAPED_SINGLE_QUOTE = '\'';
    @IsTest
    public static void transformSapProductInformation_IdIsCloned(){
        Id recordTypeId = (Id)Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = Testsetup.createCC(true, recordTypeId);
        cc.Product_Impacted__c = 'Yes – Single Item Impacted';
        SapProductInformation productInformation = new SapProductInformation();
        productInformation.productItemNumber = 'test123';
        CMPL123QMS__Change_Control__c updatedCC = SapInterfaceHandler.transformSapProductInformation(cc, productInformation);
        System.assertEquals(cc.id, updatedCC.id);
        System.assertEquals(productInformation.productItemNumber, updatedCC.Product_Item_Number__c);
    }

    @IsTest
    public static void updateChangeControlWithProductInformation_updatedCC(){
        Id recordTypeId = (Id)Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = Testsetup.createCC(false, recordTypeId);
        cc.Product_Item_Number__c = 'test12345';
        cc.Product_Impacted__c = 'Yes – Single Item Impacted';
        insert cc;

        SapProductInformation productInformation = new SapProductInformation();
        productInformation.productItemNumber = 'test123';
        List<SapProductInformation> prodList = new List<SapProductInformation>{productInformation};

        SapInterfaceHandler.updateChangeControlWithProductInformation(prodList, cc.id);
        CMPL123QMS__Change_Control__c updatedCC = [select id, product_item_number__c from  CMPL123QMS__Change_Control__c where id=:cc.id];
        System.assertNotEquals('test12345', updatedCC.Product_Item_Number__c);
    }

    @IsTest
    public static void checkForError_throwError(){
        try{
            Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(SapCalloutMockRequest.errorMesage);
            SapInterfaceHandler.checkForError(response);
        }
        catch (AuraHandledException e){
            System.assertEquals(e.getMessage(), e.getMessage());
        }
    }


    @IsTest
    public static void updateChangeControlWithProductInformation_dmlFailureCC(){
        Id recordTypeId = (Id)Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = Testsetup.createCC(false, recordTypeId);
        cc.Product_Item_Number__c = 'test12345';
        cc.Product_Impacted__c = 'Yes – Single Item Impacted';
        insert cc;

        SapProductInformation productInformation = new SapProductInformation();
        productInformation.productItemNumber = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque eleifend vulputate nibh, ut scelerisque nisl pellentesque non. ' + 
                'Nunc vitae tortor mi. Mauris placerat eros varius auctor euismod. Mauris ac pharetra massa, non mollis lacus. Praesent semper tortor id eros finibus hendrerit. Donec lobortis' + 
                'condimentum eros, vel auctor arcu iaculis eget. Proin vestibulum accumsan eleifend. Ut ultricies lacinia urna id lobortis. Aenean sollicitudin sit amet ipsum eget maximus. ' + 
                'Nunc dictum nibh at pharetra pellentesque. Ut a ante a massa vehicula ultrices. Donec lorem justo, ultrices euismod porta scelerisque, vehicula at elit. Aliquam pretium, ' + 
                'risus vel porta porta, ligula est tempor libero, in congue lacus erat non purus. Aenean lacinia elementum leo placerat lobortis. Suspendisse aliquet tellus neque.' + 
                ' Pellentesque sit amet ipsum ante. Nulla facilisi. Suspendisse hendrerit mollis leo, ac pretium ligula dictum id. Quisque viverra gravida nunc tristique tincidunt. ' + 
                'Sed ut ornare risus, a placerat velit.';
        try{
            List<SapProductInformation> prodList = new List<SapProductInformation>{productInformation};
            SapInterfaceHandler.updateChangeControlWithProductInformation(prodList, cc.id);
        }
        catch(AuraHandledException e) {
            System.assert(e.getMessage().containsAny('STRING_TOO_LONG'));
        }
       
    }

    @IsTest(SeeAllData=true)
    public static void createHttpRequest_createdRequest(){
        String productItemNum = 'test123';
        String url = PRODUCT_PARAM_PREFIX + ESCAPED_SINGLE_QUOTE + productItemNum + ESCAPED_SINGLE_QUOTE;

        HttpRequest req = SapInterfaceHandler.createHttpRequest(productItemNum);
        SAP_Product_Interface__c productInterface = SAP_Product_Interface__c.getInstance();
        
        System.assertEquals(productInterface.Endpoint__c + url, req.getEndpoint());
        System.assertEquals('GET', req.getMethod());
    }

    @IsTest
    public static void createProductUrlParam_createdUrl(){
        String productItemNum = 'test123';
        String url = PRODUCT_PARAM_PREFIX + ESCAPED_SINGLE_QUOTE + productItemNum + ESCAPED_SINGLE_QUOTE;
        String actualUrl = SapInterfaceHandler.createProductUrlParam(productItemNum);
        System.assertEquals(url, actualUrl);
    }

    @IsTest(SeeAllData=true)
    public static void sapCallout_validRequestResponse(){
        String productItemNum = '34*';
        String url = PRODUCT_PARAM_PREFIX + ESCAPED_SINGLE_QUOTE + productItemNum + ESCAPED_SINGLE_QUOTE;
        HttpRequest req = SapInterfaceHandler.createHttpRequest(productItemNum);
        Test.setMock(HttpCalloutMock.class, new SapCalloutMock());
        HttpResponse res = SapInterfaceHandler.sapCallout(req);
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        String actualValue = res.getBody();
        System.assert(!String.isEmpty(actualValue));
        System.assertEquals(200, res.getStatusCode());
    }

    @IsTest(SeeAllData=true) 
    public static void retrieveSapProductInformation_isValid(){
        String productItemNum = '34*';
        String url = PRODUCT_PARAM_PREFIX + ESCAPED_SINGLE_QUOTE + productItemNum + ESCAPED_SINGLE_QUOTE;
        HttpRequest req = SapInterfaceHandler.createHttpRequest(productItemNum);
        Test.setMock(HttpCalloutMock.class, new SapCalloutMock());
        List<SapProductInformation> prodItemNumberList = SapInterfaceHandler.retrieveSapProductInformation(productItemNum);
        System.assert(prodItemNumberList.size() > 0);
    }

    @IsTest
    public static void transformSapInterfaceResponse_nothingReturned(){
        List<SapProductInformation> prodList = SapInterfaceHandler.transformSapInterfaceResponse('\"\"');
        System.assert(prodList.isEmpty());
    }

    @IsTest
    public static void buildProductCharacteristics_ArrayOfElements(){
        List<Map<String,Object>> productObjectList = SapInterfaceBuilderTest.buildProductObjectMapList(SapCalloutMockRequest.sapResponseWithSingleProductArrayOfElementInCharacteristic);
        for (Map<String,Object> productObject : productObjectList) {
             SapProductInformation sapProdInfo  = new SapProductInformation();
             SapProductInformation sapProdInfoUpdated = SapInterfaceHandler.buildProductCharacteristics(productObject, sapProdInfo);
             System.assert(sapProdInfoUpdated != null);
             System.assert(sapProdInfoUpdated.siteResponsible != '');
         }
    }


    @IsTest
    public static void buildProductCharacteristics_SingleElement(){
         List<Map<String,Object>> productObjectList = SapInterfaceBuilderTest.buildProductObjectMapList(SapCalloutMockRequest.sapResponseWithSingleProductSingleElementInCharacteristic);
         for (Map<String,Object> productObject : productObjectList) {
             SapProductInformation sapProdInfo  = new SapProductInformation();
             SapProductInformation sapProdInfoUpdated = SapInterfaceHandler.buildProductCharacteristics(productObject, sapProdInfo);
             System.assert(sapProdInfoUpdated != null);
             System.assert(sapProdInfoUpdated.siteResponsible != '');
         }
    }
}