@isTest
public class Test_ChangecontrolTrigger { 
    @isTest
    public static void BeforeUpdate(){
        Profile p = [select id from profile where name='Standard User'];
        
        User u = new User(alias = 'utest', email='utest@email.com',
                          emailencodingkey='UTF-8', lastname='Testing', TWD_Role__c='Change Coordinator', languagelocalekey='en_US',
                          localesidkey='en_US', profileid = p.Id, country='United States',
                          timezonesidkey='America/Los_Angeles', username='utestCmpl@email.com');
        insert u;
        
        CMPL123QMS__Change_Control__c ccobj=new CMPL123QMS__Change_Control__c();
        ccobj.Title__c='Test';
        ccobj.Change_Owner__c=u.id;
        ccobj.Origination__c='Corporate';
        ccobj.Risk_Assessment__c='NO';
        ccobj.Due_Date__c=system.today()+10;
        ccobj.External_Responsible_Person__c=u.id;
        
        
        ccobj.CRB_Approver_1__c=u.Id;
        ccobj.CRB_Approver_2__c=u.id;
        ccobj.CRB_Approver_3__c=u.id;
        ccobj.CRB_Approver_4__c=u.id;
        ccobj.CRB_Approver_5__c=u.id;
        ccobj.CRB_Approver_6__c=u.id;
        
        ccobj.Quality_Approver__c=u.id;
        ccobj.Release_Approver_1__c=u.id;
        ccobj.Release_Approver_2__c=u.id;
        ccobj.Release_Approver_4__c=u.id;
        ccobj.Release_Approver_5__c=u.id;
        ccobj.Release_Approver_6__c=u.id;
        ccobj.Release_Approver_3__c=u.id;
       
        
        ccobj.Release_QA_Approver__c=u.id;
        ccobj.Assigned_To__c=u.id;
        ccobj.Quality_Contact__c=u.id;
        ccobj.Supervisor_Manager__c=u.id;
        ccobj.CMPL123QMS__QA_Contact__c=u.id;
        
        ccobj.CMPL123QMS__Main_Contact__c=u.id;
        ccobj.CMPL123QMS__Management_Approved_By__c=u.id;
        ccobj.CMPL123QMS__Manager__c=u.id;
        
        Test.startTest();
        try{
        Insert ccobj;
            system.assert(true,'User selected in "Change Owner" does not have the needed role. Select another user.');
            
        }
        catch(Exception e)
        {
            String message = e.getMessage();
            system.assert(message.contains('Select another use'), 'message=' + message);
    
        }
        Test.stopTest();
    }
}