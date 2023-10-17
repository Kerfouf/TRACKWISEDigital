@isTest
public  class InternalAuditHandler_Test {
      @isTest
      public static void UnitTest(){
          Account oAccount = new Account();
         oAccount.Name = 'Test';
         insert oAccount;
         
         CMPL123QMS__Internal_Audit__c oCMPL123QMSInternalAudit = new CMPL123QMS__Internal_Audit__c();
         oCMPL123QMSInternalAudit.Audit_Title__c ='Test';
         oCMPL123QMSInternalAudit.Audit_Type__c = 'GLP';
         oCMPL123QMSInternalAudit.CMPL123QMS__Manager_of_Area_to_be_Audited__c = oAccount.Id;
         oCMPL123QMSInternalAudit.CMPL123_WF_Action__c = 'Approve Change Control';
         insert oCMPL123QMSInternalAudit;
         
         try{ 
         oCMPL123QMSInternalAudit.CMPL123_WF_Action__c = 'Approve Audit';
         update oCMPL123QMSInternalAudit;
         }
         catch(Exception ex){
           system.debug('@developer-->Exception:'+ex);
         }
         
         Audit_Finding__c oAuditFinding = new Audit_Finding__c();
         oAuditFinding.Audit__c = oCMPL123QMSInternalAudit.Id;
         oAuditFinding.Due_Date__c = Date.Today();
         oAuditFinding.CMPL123_WF_Action__c = 'Pending Submission';
         insert oAuditFinding;
         try{ 
         oCMPL123QMSInternalAudit.CMPL123_WF_Action__c = 'Approve Audit';
         update oCMPL123QMSInternalAudit;
         }
         catch(Exception ex){
           system.debug('@developer-->Exception:'+ex);
         }
         delete oCMPL123QMSInternalAudit;
      }
}