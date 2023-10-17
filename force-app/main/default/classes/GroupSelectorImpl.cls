/*
* Created on Wed Nov 17, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class GroupSelectorImpl extends fflib_SobjectSelector implements GroupSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Group.Id
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return Group.SObjectType;
    }

    public Group selectQueueByName(String queueName) {
        fflib_QueryFactory queryFactory = newQueryFactory()
            .selectFields(getSObjectFieldList())
            .setCondition('Type = \'Queue\' AND DeveloperName = :queueName');
        return ((List<Group>)Database.query(queryFactory.toSOQL()))[0];
    }
}