@isTest
public class Trigger_Test {
    
    @isTest
    public static void Extension_Request_AuditTrigger_test() {
         CMPL123QMS__Internal_Audit__c auditObj = new CMPL123QMS__Internal_Audit__c();
        
        auditObj.Audit_Title__c = 'abc';
        auditObj.Audit_Type__c ='GMP';
        insert auditObj;
        
        //AuditFinding Object
        Audit_Finding__c auditFindingObj = new Audit_Finding__c();
        auditFindingObj.Audit__c = auditObj.id;
        auditFindingObj.Due_Date__c = Date.today() +1;
        insert auditFindingObj;        
    }
    
    @isTest
    public static void CMPL123_X123Job_AuditTrigger_test(){
        CMPL123__X123Job__c job = new CMPL123__X123Job__c();
        insert job;
    }
    
    @isTest
    public static void Extension_Request_CAPA_AuditTrigger_test(){
    CMPL123QMS__CAPA__c oCMPL123QMSCAPA = new CMPL123QMS__CAPA__c();
      oCMPL123QMSCAPA.Short_Description__c = 'TSO4';
      oCMPL123QMSCAPA.Date_Initiated__c = Date.Today();
      oCMPL123QMSCAPA.CMPL123QMS__CAPA_Type__c = 'Corrective Action';
      oCMPL123QMSCAPA.Description__c = 'TSO4 Section5 Step20 BN DR';
      oCMPL123QMSCAPA.Device_Problem__c = 'Yes';
      oCMPL123QMSCAPA.Health_Risk__c = 'Yes';
      oCMPL123QMSCAPA.Business_Risk__c = 'Low';
      oCMPL123QMSCAPA.Probability_Measure__c = 'Low';
      oCMPL123QMSCAPA.Actual_Risk_Rating__c = 'Low';
      oCMPL123QMSCAPA.Compliance_Risk__c = 'Low';
      oCMPL123QMSCAPA.Severity_Measure__c = 'Medium';
      oCMPL123QMSCAPA.Risk_Category__c = 'Low';
      oCMPL123QMSCAPA.Investigation_Required__c = 'Yes';
      oCMPL123QMSCAPA.Action_Plan__c = 'TSO4 Sec5 Step20 AP Name';
      insert oCMPL123QMSCAPA;
      Extension_Request_CAPA__c capaExt = new Extension_Request_CAPA__c();
      capaExt.CAPA__c = oCMPL123QMSCAPA.id;
      insert capaExt;
    }
    
    @isTest
    public static void CMPL123_X123Task_AuditTrigger_test(){
        CMPL123__X123Task__c task = new CMPL123__X123Task__c();
        insert task;
    }
    
    @isTest
    public static void Extension_Request_QE_AuditTrigger_test(){
     CMPL123QMS__Deviation__c oCMPL123QMSDeviation = new CMPL123QMS__Deviation__c();
        oCMPL123QMSDeviation.CMPL123QMS__Short_Description__c = 'Test';
        oCMPL123QMSDeviation.CMPL123QMS__Type__c = 'Other';
        oCMPL123QMSDeviation.Severity__c = 'Major';
        insert oCMPL123QMSDeviation;
        Extension_Request_QE__c ext  = new Extension_Request_QE__c();
        ext.Quality_Event__c = oCMPL123QMSDeviation.id;
        insert ext;
    }
}