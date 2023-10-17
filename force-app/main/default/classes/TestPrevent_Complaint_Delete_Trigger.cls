/**
#############################################################################
#  File Name     : Complaint_Test_Class
#  Author        : Sparta Systems 
#  Description: public class which is used to handle all the custom functioanlity on Complaint object. 


#############################################################################
*/
@IsTest Public Class TestPrevent_Complaint_Delete_Trigger{
    
    @IsTest Public static Void Prevent_Complaint_Delete_Trigger(){
        
        // User initialization
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utestCmpl@email.com');
        insert u;
        
        //Instantiate a new Inquiry object with all required parameter in the page
        Inquiry__c InqObj = new Inquiry__c();
        InqObj.Source__c = 'Email';
        InqObj.Subject__c = 'UnitTest';
        InqObj.Inquiry_Type__c = 'Patient Event';
        InqObj.Manufactured_by_Company__c = 'Yes';
        InqObj.Product_or_Packaging_Issue__c='Yes';
        InqObj.Patient_Affected__c='Yes';
        insert InqObj;
        
        List<CMPL123CME__Complaint__c> complaintObj = new List<CMPL123CME__Complaint__c>();
        
        CMPL123CME__Complaint__c complaintObj1 ;
        
        complaintObj1  = new CMPL123CME__Complaint__c() ;
        complaintObj1 = new CMPL123CME__Complaint__c();
        complaintObj1.CMPL123CME__Assigned_To__c = u.Id;
        complaintObj1.CMPL123CME__Short_Description__c ='UnitTest';
        complaintObj1.CMPL123CME__Initiator__c = u.id;
        complaintObj1.CMPL123CME__Supervisor__c = u.Id;
        complaintObj1.CMPL123CME__Impact__c = 'High';        
        complaintObj.add(complaintObj1);
        
        try{
            
            insert complaintObj; 
        }
        catch(Exception ex)  
        {
            system.debug('exception'+ex);
        }    
        delete complaintObj;   
        delete InqObj;
    }
    
}