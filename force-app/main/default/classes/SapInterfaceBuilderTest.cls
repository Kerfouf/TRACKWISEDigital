/**
 * @File Name          : SapInterfaceBuilderTest.cls
 * @Description        : Class used to construct data instances for SapInterfaceHandlerTest
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 1/15/2020, 4:14:23 PM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    1/15/2020   Jon Astemborski     Initial Version
**/

@IsTest
public class SapInterfaceBuilderTest {

    public static List<Map<String, Object>> buildProductObjectMapList(String mockSapResponse){
        Map<String, Object> response = (Map<String, Object>) JSON.deserializeUntyped(mockSapResponse);
        List<Object> productList = new List<Object>();

        if ( response.get(SapInterfaceHandler.SAP_Product) instanceof List<Object>) {
            productList = (List<Object>)response.get(SapInterfaceHandler.SAP_PRODUCT);

        }
        else {
            productList.add((Object)response.get(SapInterfaceHandler.SAP_PRODUCT));

        }
        List<Map<String, Object>> prodObjectMapList = new List<Map<String, Object>>();
        for (Object product : productList) {
            Map<String, Object> prodObjMap = (Map<String, Object>) product;
            prodObjectMapList.add(prodObjMap);
        }
        return prodObjectMapList;
    }
}