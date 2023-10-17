/*
* Created on Fri Dec 10, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public abstract class CrmRetryJob {
    
    protected List<Error_Log__c> logs;
    protected Set<Id> externalIds;

    abstract public String run();

    public CrmRetryJob(List<Error_Log__c> logs) {
        this.logs = logs;
        this.externalIds = new Set<Id>();
        for (Error_Log__c log : logs) {
            this.externalIds.add((Id)log.External_Case_Id__c);
        }
    }

    protected void setLogStatusClosed() {
        List<Error_Log__c> logsToUpdate = new List<Error_Log__c>();
        for (Error_Log__c log : this.logs) {
            logsToUpdate.add(
                new Error_Log__c(
                    Id = log.Id,
                    Status__c = 'Complete'
                )
            );
        }
        update logsToUpdate;
    }
}