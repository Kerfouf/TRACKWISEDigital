/*
 * Created on Tues Nov 16, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ExternalRecordTypeSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ExternalRecordTypeSelectorImpl selector = (ExternalRecordTypeSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(RecordType__x.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(RecordType__x.Id));
        System.assert(returnList.contains(RecordType__x.ExternalId));
        System.assert(returnList.contains(RecordType__x.Name__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ExternalRecordTypeSelectorImpl selector = (ExternalRecordTypeSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(RecordType__x.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(RecordType__x.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectByIdTest() {

        List<RecordType__x> records;

        Test.startTest();
        records = ((ExternalRecordTypeSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(RecordType__x.SObjectType)).selectById(new Set<Id> { fflib_IDGenerator.generate(RecordType__x.SObjectType) });
        Test.stopTest();

        System.assertEquals(0, records.size());
    }
}