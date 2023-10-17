@isTest
private class ChangeControlPlanHandler_Test {
    
    static testMethod void myUnitTest() {
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser1@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='testuser124@testorg.com');
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
        
        list<CMPL123QMS__Change_Control__c>lstChangeControl = new list<CMPL123QMS__Change_Control__c>();
        
        CMPL123QMS__Change_Control__c oCMPL123QMSChangeControl;
        oCMPL123QMSChangeControl = new CMPL123QMS__Change_Control__c();
        oCMPL123QMSChangeControl.Short_Description__c = 'Test';
        oCMPL123QMSChangeControl.Assigned_To__c = u.id;
        oCMPL123QMSChangeControl.Supervisor_Manager__c = u.id;
        oCMPL123QMSChangeControl.Quality_Contact__c = u.id;
        oCMPL123QMSChangeControl.Quality_Event__c = oCMPL123QMSDeviation.id;
        lstChangeControl.add(oCMPL123QMSChangeControl);
        
        oCMPL123QMSChangeControl = new CMPL123QMS__Change_Control__c();
        oCMPL123QMSChangeControl.Short_Description__c = 'Test1';
        oCMPL123QMSChangeControl.Assigned_To__c = u.id;
        oCMPL123QMSChangeControl.Supervisor_Manager__c = u.id;
        oCMPL123QMSChangeControl.Quality_Contact__c = u.id;
        oCMPL123QMSChangeControl.Quality_Event__c = oCMPL123QMSDeviation.id;
        lstChangeControl.add(oCMPL123QMSChangeControl);
        
        oCMPL123QMSChangeControl = new CMPL123QMS__Change_Control__c();
        oCMPL123QMSChangeControl.Short_Description__c = 'Test2';
        oCMPL123QMSChangeControl.Assigned_To__c = u.id;
        oCMPL123QMSChangeControl.Supervisor_Manager__c = u.id;
        oCMPL123QMSChangeControl.Quality_Contact__c = u.id;
        oCMPL123QMSChangeControl.Quality_Event__c = oCMPL123QMSDeviation.id;
        lstChangeControl.add(oCMPL123QMSChangeControl);
        insert lstChangeControl;
        lstChangeControl[0].Short_Description__c = 'testChangeControl';
        update lstChangeControl[0];
        delete lstChangeControl[1];
        
        List<Change_Control_Effectiveness_Check__c>lstChangeCEC = new List<Change_Control_Effectiveness_Check__c>();
        Change_Control_Effectiveness_Check__c oChangeControlEffectivenessCheck;
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlEffectivenessCheck.CMPL123_WF_Action__c = 'Submit for Approval - Eff. Check Not Required';
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlEffectivenessCheck.CMPL123_WF_Action__c = 'Submit for Review - Change Control';
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlEffectivenessCheck.CMPL123_WF_Action__c = 'Effectiveness Check Plan Created';
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlEffectivenessCheck.CMPL123_WF_Action__c = 'Approve Change Control';
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlEffectivenessCheck.CMPL123_WF_Action__c = 'Complete Review - Change Control';
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        
        oChangeControlEffectivenessCheck = new Change_Control_Effectiveness_Check__c();
        oChangeControlEffectivenessCheck.Change_Control__c = oCMPL123QMSChangeControl.id;
        lstChangeCEC.add(oChangeControlEffectivenessCheck);
        insert lstChangeCEC;
        update oCMPL123QMSChangeControl;
        
        list<Change_Control_Plan__c>lstChangeControlplan = new list<Change_Control_Plan__c>();
        Change_Control_Plan__c oChangeControlPlan;
        oChangeControlPlan = new Change_Control_Plan__c();
        oChangeControlPlan.Name = 'Test';
        oChangeControlPlan.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlPlan.Plan_SME_Approved__c = false;
        
        oChangeControlPlan = new Change_Control_Plan__c();
        oChangeControlPlan.Name = 'TestChangeControlPlan1';
        oChangeControlPlan.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlPlan.Plan_SME_Approved__c = false;
        
        oChangeControlPlan = new Change_Control_Plan__c();
        oChangeControlPlan.Name = 'TestChangeControlPlan2';
        oChangeControlPlan.Change_Control__c = oCMPL123QMSChangeControl.id;
        oChangeControlPlan.Plan_SME_Approved__c = false;
        lstChangeControlplan.add(oChangeControlPlan);
        insert lstChangeControlplan;
        
        Map<Id,Change_Control_Plan__c> changeControlPlanOldMap = new Map<Id,Change_Control_Plan__c>();
        for(Change_Control_Plan__c ccp : lstChangeControlplan){
            changeControlPlanOldMap.put(ccp.id , ccp);
        }
        
        ChangeControlPlanHandler.preventChangeControlPlanDeletion(changeControlPlanOldMap);
            
        lstChangeControlplan[0].Name = 'TestChangeControlPlan1';
        update lstChangeControlplan[0];
        try{
            delete lstChangeControlplan[0];
            undelete lstChangeControlplan[0];
        }
        catch(Exception ex){
            system.debug('@developer-->ex'+ex);
        }
        
        Task oTask= new Task();
        oTask.OwnerId = u.id;
        oTask.Subject = 'Call';
        oTask.Status = 'In Progress';
        oTask.Priority= 'Normal';  
        oTask.WhatId = lstChangeCEC[0].Id;
        insert oTask;
    }
}