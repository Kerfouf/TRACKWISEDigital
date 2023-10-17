/*
* Created on Thur Dec 9, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class AsyncApexJobSelectorImpl extends fflib_SObjectSelector implements AsyncApexJobSelector {
    
    public List<String> RUNNING_STATUSES = new List<String> {'Holding','Queued','Preparing','Processing'};

    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            AsyncApexJob.Id
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return AsyncApexJob.SObjectType;
    }
    
    public Boolean isJobRunning(String className) {
        
        Boolean isRunning = false;
        String queryCondition = 'ApexClass.Name = :className ' +
            'AND Status IN :RUNNING_STATUSES';

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(queryCondition)
            .selectFields(getSObjectFieldList());

        for (AsyncApexJob job : Database.query(queryFactory.toSOQL())) {
            isRunning = true;
        }

        return isRunning;
    }
}