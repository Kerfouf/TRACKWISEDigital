/**
 * @File Name          : SapCustomerReportController_Test.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 6/9/2020, 10:01:48 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/9/2020   Jon Astemborski     Initial Version
**/
@IsTest
public class SapCustomerReportController_Test {
    @IsTest
    public static void getReportUrl_Exists(){
        String test = SapCustomerReportController.getReportUrl();
    }
    
    @IsTest
    public static void doesUserHaveAccess_No(){
        User u = TestSetup.createUser(true);
        Id ccRecType = Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = TestSetup.createCC(true, ccRecType);
        cc.Change_Owner__c  = u.id;
        system.runAs(u){
            Boolean hasAccess = SapCustomerReportController.doesUserHaveAccess(u.id, cc.id);
        }
    }
}