/*
* Created on Thur Dec 09, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public abstract class CrmBatchableJob {

    protected CRM_Integration_Settings__c batchConfig;
    protected Datetime startTime;
    static public List<Exception> batchErrors = new List<Exception>();

    public CrmBatchableJob(CRM_Integration_Settings__c batchConfig) {
        this.batchConfig = batchConfig;
        this.startTime = System.now().addSeconds(batchConfig.As_Of_Offset__c == null ? 0 : (Integer)batchConfig.As_Of_Offset__c * -1);
    }

    protected String executeBatch(Object obj, Integer batchSize) {
        String className = String.valueOf(obj).split(':')[0];
        AsyncApexJobSelector selector = (AsyncApexJobSelector) CrmComplaintIntegrationApplication.selector.newInstance(AsyncApexJob.SObjectType);
        if (selector.isJobRunning(className)) {
            return null;
        }
        return Database.executeBatch((Database.Batchable<sObject>)obj, batchSize);
    }
}