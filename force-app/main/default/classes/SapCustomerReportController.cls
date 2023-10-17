/**
 * @File Name          : SapCustomerReportController.cls
 * @Description        : 
 * @Author             : Jon Astemborski
 * @Group              : 
 * @Last Modified By   : Jon Astemborski
 * @Last Modified On   : 6/9/2020, 9:35:29 AM
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/9/2020   Jon Astemborski     Initial Version
**/
public class SapCustomerReportController {
    private static final String TWD_ROLE_CHANGE_COORDINATOR = 'Change Coordinator';
    public Boolean isUserCoordinatorOrOwner {get;set;}
    
    public SapCustomerReportController(){
        
    }

    @AuraEnabled
    public static String getReportUrl(){
        SAP_Customer_Report__c customerReport = SAP_Customer_Report__c.getOrgDefaults();
        return customerReport.URL__c;
    }
    
    @AuraEnabled
    public static Boolean doesUserHaveAccess(Id userId, Id recordId){
        String twdRole = [Select id, twd_role__c from User where id=:userId].twd_role__c;
        boolean isCoordinator = twdRole == null ? false : twdRole.equals(TWD_ROLE_CHANGE_COORDINATOR);
        CMPL123QMS__Change_Control__c cc = [select id, Change_Owner__c  from CMPL123QMS__Change_Control__c where id=:recordId];
        boolean isOwner = userId.equals(cc.Change_owner__c);
        System.debug('is coord ' + isCoordinator);
        System.debug('is owner ' + isOwner);

        return isCoordinator || isOwner;
    }
}