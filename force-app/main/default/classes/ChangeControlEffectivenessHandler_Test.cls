@isTest
public  class ChangeControlEffectivenessHandler_Test {
    @isTest
    public static void unitTest(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuserCCEff@testorg.com');
        insert u;
        
        CMPL123__Device__c oCMPL123Device = new CMPL123__Device__c();
        oCMPL123Device.Name = '34554';
        insert oCMPL123Device;
        
        CMPL123QMS__Deviation__c oCMPL123QMSDeviation = new CMPL123QMS__Deviation__c();
        oCMPL123QMSDeviation.CMPL123QMS__Short_Description__c = 'Test';
        oCMPL123QMSDeviation.CMPL123QMS__Type__c = 'Other';
        oCMPL123QMSDeviation.Device__c = oCMPL123Device.Id;
        oCMPL123QMSDeviation.Severity__c = 'Major';
        insert oCMPL123QMSDeviation;
        
        CMPL123QMS__Change_Control__c oCMPL123QMSChangeControl = new CMPL123QMS__Change_Control__c();
        oCMPL123QMSChangeControl.Short_Description__c = 'Test';
        oCMPL123QMSChangeControl.Assigned_To__c = u.id;
        oCMPL123QMSChangeControl.Supervisor_Manager__c = u.id;
        oCMPL123QMSChangeControl.Quality_Contact__c = u.id;
        oCMPL123QMSChangeControl.Quality_Event__c = oCMPL123QMSDeviation.id;
        insert oCMPL123QMSChangeControl;
        
        List<Change_Control_Effectiveness_Check__c>lstChangeCEC = new List<Change_Control_Effectiveness_Check__c>();
        Change_Control_Effectiveness_Check__c oChangeControlEffectivenessCheck;
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlEffectivenessCheck.CMPL123_WF_Action__c = 'Approve';
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        insert lstChangeCEC;
        
        Task oTask = new Task();
        oTask.OwnerId = u.id;
        oTask.Subject = 'Call';
        oTask.Status = 'In Progress';
        oTask.Priority = 'Normal';
        oTask.WhatId = lstChangeCEC[0].Id;
        insert oTask;
        try{
            lstChangeCEC[0].CMPL123_WF_Action__c ='Submit for Review';
            update lstChangeCEC[0];
        }
        catch(Exception ex){
            system.debug('@developer-->ex:'+ex);
        }
        
        delete lstChangeCEC[0]; 
        undelete lstChangeCEC[0];
    }
}