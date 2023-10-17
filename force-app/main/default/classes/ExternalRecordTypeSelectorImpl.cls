/*
* Created on Thurs Oct 28, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ExternalRecordTypeSelectorImpl extends fflib_SobjectSelector implements ExternalRecordTypeSelector {
    /*Required by fflib*/
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            RecordType__x.Id,
            RecordType__x.ExternalId,
            RecordType__x.Name__c
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return RecordType__x.SObjectType;
    }

    public List<RecordType__x> selectById(Set<Id> recordIds) {
        return (List<RecordType__x>) selectSObjectsById(recordIds);
    }
}