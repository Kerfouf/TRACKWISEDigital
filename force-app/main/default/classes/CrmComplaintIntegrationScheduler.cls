/*
* Created on Tue Nov 16, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public with sharing class CrmComplaintIntegrationScheduler implements Schedulable{
   
    public void execute(SchedulableContext context) { 
        CRM_Integration_Settings__c config = CRM_Integration_Settings__c.getOrgDefaults();
        new CrmComplaintIntegrationJob(config).run();
    }
}