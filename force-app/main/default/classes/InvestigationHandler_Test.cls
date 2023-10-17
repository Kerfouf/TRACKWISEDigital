/**
#############################################################################
#  File Name     : InvestigationHandler_Test_Class
#  Author        : Sparta Systems 
#  Description: public class which is used to handle all the custom functioanlity on investigation object. 


#############################################################################
*/ 
@IsTest public class InvestigationHandler_Test {
    @IsTest public static void testInvestigationHandler() {
        // User initialization
       /* Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utest12353215511235@email.com');
        insert u;
 
        //Instantiate a new complaint object with all required parameter in the page
        CMPL123CME__Complaint__c complaintObj = new CMPL123CME__Complaint__c();
        complaintObj.CMPL123CME__Assigned_To__c = u.Id;
        complaintObj.CMPL123CME__Short_Description__c ='UnitTest';
        complaintObj.CMPL123CME__Initiator__c = u.id;
        complaintObj.CMPL123CME__Supervisor__c = u.Id;
        complaintObj.CMPL123CME__Impact__c = 'High';
        insert complaintObj;  
        
        List<CMPL123CME__Investigation__c> lstinvestigationObj  = new List<CMPL123CME__Investigation__c>() ;
        CMPL123CME__Investigation__c investobj ;
        
        investobj = new CMPL123CME__Investigation__c();
        investObj.Name = 'UTest1';
        investObj.CMPL123CME__Complaint__c = complaintObj.id ;
        lstinvestigationObj.add(investObj);
        
        investobj = new CMPL123CME__Investigation__c();
        investObj.Name = 'UTest2';
        investObj.CMPL123CME__Complaint__c = complaintObj.id ;
        lstinvestigationObj.add(investObj);
        
        insert lstinvestigationObj;
        
        delete lstinvestigationObj;*/
             
     }

    @IsTest public static void testInvestigationHandlerNegative() {
        // User initialization
        /*Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utes1231235314t@email.com');
        insert u;
                
        //Instantiate a new complaint object with all required parameter in the page
        CMPL123CME__Complaint__c complaintObj = new CMPL123CME__Complaint__c();
        complaintObj.CMPL123CME__Assigned_To__c = u.Id;
        complaintObj.CMPL123CME__Short_Description__c ='UnitTest';
        complaintObj.CMPL123CME__Initiator__c = u.id;
        complaintObj.CMPL123CME__Supervisor__c = u.Id;
        complaintObj.CMPL123CME__Impact__c = 'High';
        insert complaintObj;  
        complaintObj.Assessment_Completed__c = true;
        complaintObj.Investigation_Status__c ='Investigation Completed';
        complaintObj.CMPL123CME__CMPL123_WF_Action__c = 'Close - Complaint';
        update complaintObj;
        
        List<CMPL123CME__Investigation__c> lstinvestigationObj  = new List<CMPL123CME__Investigation__c>() ;
        
        CMPL123CME__Investigation__c investobj,investobj1 ;
        investobj1 = new CMPL123CME__Investigation__c();
        investObj1.Name = 'UTest1';
        investObj1.CMPL123CME__Complaint__c = complaintObj.id ;
        lstinvestigationObj.add(investObj1);
        
        investobj = new CMPL123CME__Investigation__c();
        investObj.Name = 'UTest2';
        investObj.CMPL123CME__Complaint__c = complaintObj.id ;
        lstinvestigationObj.add(investObj);
        try{
            
        insert lstinvestigationObj;
        }
        catch(Exception ex)
        {
            system.debug(' exception ' + ex);
        }
        
        delete lstinvestigationObj;
       // delete lstinvestigationObj[1];
      */           
     }
    
    }