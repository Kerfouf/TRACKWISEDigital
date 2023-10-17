@isTest
public class CAPA_ValidationHandler_Test {
  
    @isTest
    public static void myUnitTest() {
       Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1230@testorg.com');
              insert u;
              
              CMPL123__Device__c oCMPL123Device = new CMPL123__Device__c();
              oCMPL123Device.Name = '34554';
              insert oCMPL123Device;
              
              CMPL123QMS__CAPA__c oCMPL123QMSCAPA = new CMPL123QMS__CAPA__c();
              oCMPL123QMSCAPA.Short_Description__c = 'TSO4';
              oCMPL123QMSCAPA.Date_Initiated__c = Date.Today();
              oCMPL123QMSCAPA.CMPL123QMS__CAPA_Type__c = 'Corrective Action';
              oCMPL123QMSCAPA.Description__c = 'TSO4 Section5 Step20 BN DR';
              oCMPL123QMSCAPA.Device__c = oCMPL123Device.id;
              oCMPL123QMSCAPA.Device_Problem__c = 'Yes';
              oCMPL123QMSCAPA.Health_Risk__c = 'Yes';
              oCMPL123QMSCAPA.Business_Risk__c = 'Low';
              oCMPL123QMSCAPA.Probability_Measure__c = 'Low';
              oCMPL123QMSCAPA.Actual_Risk_Rating__c = 'Low';
              oCMPL123QMSCAPA.Compliance_Risk__c = 'Low';
              oCMPL123QMSCAPA.Severity_Measure__c = 'Medium';
              oCMPL123QMSCAPA.Risk_Category__c = 'Low';
              oCMPL123QMSCAPA.Investigation_Required__c = 'Yes';
              oCMPL123QMSCAPA.CAPA_Plan_Owner__c = u.id;
              oCMPL123QMSCAPA.Action_Plan__c = 'TSO4 Sec5 Step20 AP Name';
              //oCMPL123QMSCAPA.CMPL123_WF_Action__c = 'Approve';
              try{
              insert oCMPL123QMSCAPA;
              }
              catch(Exception ex){
                system.debug('@developer-->Exception1:'+ex);
              }
              
              List<CAPA_Plan__c>lstCAPAPlan = new List<CAPA_Plan__c>();
              CAPA_Plan__c oCAPAPlan;
              oCAPAPlan = new CAPA_Plan__c();
              oCAPAPlan.Name = 'Test';
              oCAPAPlan.CAPA__c = oCMPL123QMSCAPA.id;
              lstCAPAPlan.add(oCAPAPlan);
              
              oCAPAPlan = new CAPA_Plan__c();
              oCAPAPlan.Name = 'TestTest';
              oCAPAPlan.CAPA__c = oCMPL123QMSCAPA.id;
              lstCAPAPlan.add(oCAPAPlan);
              insert lstCAPAPlan;
              
              delete lstCAPAPlan[0];
    }
    
   @isTest
    public static void myUnitTest1() {
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
            User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='testuser1233@testorg.com');
              insert u;
              
              CMPL123__Device__c oCMPL123Device = new CMPL123__Device__c();
              oCMPL123Device.Name = '34554';
              insert oCMPL123Device;
              
              CMPL123QMS__CAPA__c oCMPL123QMSCAPA = new CMPL123QMS__CAPA__c();
              oCMPL123QMSCAPA.Short_Description__c = 'TSO4';
              oCMPL123QMSCAPA.Date_Initiated__c = Date.Today();
              oCMPL123QMSCAPA.CMPL123QMS__CAPA_Type__c = 'Corrective Action';
              oCMPL123QMSCAPA.Description__c = 'TSO4 Section5 Step20 BN DR';
              oCMPL123QMSCAPA.Device__c = oCMPL123Device.id;
              oCMPL123QMSCAPA.Device_Problem__c = 'Yes';
              oCMPL123QMSCAPA.Health_Risk__c = 'Yes';
              oCMPL123QMSCAPA.Business_Risk__c = 'Low';
              oCMPL123QMSCAPA.Probability_Measure__c = 'Low';
              oCMPL123QMSCAPA.Actual_Risk_Rating__c = 'Low';
              oCMPL123QMSCAPA.Compliance_Risk__c = 'Low';
              oCMPL123QMSCAPA.Severity_Measure__c = 'Medium';
              oCMPL123QMSCAPA.Risk_Category__c = 'Low';
              oCMPL123QMSCAPA.Investigation_Required__c = 'Yes';
              oCMPL123QMSCAPA.CAPA_Plan_Owner__c = u.id;
              oCMPL123QMSCAPA.Action_Plan__c = 'TSO4 Sec5 Step20 AP Name';
              oCMPL123QMSCAPA.CMPL123_WF_Action__c = 'Submit for Review - CAPA';
              try{
              insert oCMPL123QMSCAPA;
              }
              catch(Exception ex){
                system.debug('@developer-->Exception2:'+ex);
              }
              List<CAPA_Investigation__c>lstCAPAInvestigation = new List<CAPA_Investigation__c>();
              CAPA_Investigation__c oCAPAInvestigation;
              oCAPAInvestigation = new CAPA_Investigation__c();
              oCAPAInvestigation.CAPA__c = oCMPL123QMSCAPA.id;
              lstCAPAInvestigation.add(oCAPAInvestigation);
              
              oCAPAInvestigation = new CAPA_Investigation__c();
              oCAPAInvestigation.CAPA__c = oCMPL123QMSCAPA.id;
              lstCAPAInvestigation.add(oCAPAInvestigation);
              insert lstCAPAInvestigation;
              
              delete lstCAPAInvestigation;
    } 
}