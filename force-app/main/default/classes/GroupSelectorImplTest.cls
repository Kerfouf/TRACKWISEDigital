/*
* Created on Mon Nov 29, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class GroupSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        GroupSelectorImpl selector = (GroupSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Group.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(Group.Id));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        GroupSelectorImpl selector = (GroupSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(Group.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(Group.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectQueueByNameTest() {

        Group queue = CrmComplaintIntegrationTestDataFactory.createQueue(true);
        Group record;

        Test.startTest();
        record = ((GroupSelector)CrmComplaintIntegrationApplication.selector.newInstance(Group.SObjectType)).selectQueueByName(
            'ApexUnitTestQueue'
        );
        Test.stopTest();

        System.assertNotEquals(null, record);
    }
}