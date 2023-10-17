/*
 * Created on Fri Nov 5, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

@IsTest
public with sharing class ComplaintConfigSelectorImplTest {
    
    @IsTest
    static void getSObjectFieldListTest() {
        
        Test.startTest();
        ComplaintConfigSelectorImpl selector = (ComplaintConfigSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CRM_TWD_Complaint_Creation__mdt.SObjectType);
        List<Schema.SObjectField> returnList = selector.getSObjectFieldList();
        Test.stopTest();

        System.assert(returnList.contains(CRM_TWD_Complaint_Creation__mdt.CRM_Field_API_Name__c));
        System.assert(returnList.contains(CRM_TWD_Complaint_Creation__mdt.Object_API_Name__c));
        System.assert(returnList.contains(CRM_TWD_Complaint_Creation__mdt.TWD_Field_API_Name__c));
        System.assert(returnList.contains(CRM_TWD_Complaint_Creation__mdt.Relationship_Name__c));
    }

    @IsTest
    static void getSObjectTypeTest() {
        
        Test.startTest();
        ComplaintConfigSelectorImpl selector = (ComplaintConfigSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CRM_TWD_Complaint_Creation__mdt.SObjectType);
        Schema.SObjectType returnSObjectType = selector.getSObjectType();
        Test.stopTest();

        System.assertEquals(CRM_TWD_Complaint_Creation__mdt.SObjectType, returnSObjectType);
    }

    @IsTest
    static void selectAllTest() {
        List<CRM_TWD_Complaint_Creation__mdt> returnedConfig;

        Test.startTest();
        returnedConfig = ((ComplaintConfigSelectorImpl)CrmComplaintIntegrationApplication.selector.newInstance(CRM_TWD_Complaint_Creation__mdt.SObjectType)).selectAll();
        Test.stopTest();

        System.assertNotEquals(0, returnedConfig.size());
    }
}