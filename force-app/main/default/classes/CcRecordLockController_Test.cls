/**
 * @File Name          : CcRecordLockController_Test.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 6/9/2020, 10:40:52 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/9/2020   Jon Astemborski     Initial Version
**/
@IsTest
public class CcRecordLockController_Test {
    @IsTest
    public static void queryBaseCC_Test() {
        Id ccRecType = Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = TestSetup.createCC(true, ccRecType);
        CcRecordLockController.queryBaseCC(cc.id);

    }
    @IsTest
    public static void queryCC_Test(){
        Id ccRecType = Schema.SObjectType.CMPL123QMS__Change_Control__c.getRecordTypeInfosByName().get('CC Custom').getRecordTypeId();
        CMPL123QMS__Change_Control__c cc = TestSetup.createCC(true, ccRecType);
        try { 
            CcRecordLockController.queryCC(cc);
        }
        catch (AuraHandledException e){
        }
    }
}