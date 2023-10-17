/*
* Created on Tues Oct 26, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class WorkOrderSelectorImpl extends fflib_SObjectSelector implements WorkOrderSelector {
     
    /*Required by fflib*/
     public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Work_Order__c.Id,
            Work_Order__c.ExternalId__c,
            Work_Order__c.WO_Category__c,
            Work_Order__c.WO_Status__c,
            Work_Order__c.WO_Sub_Category__c,
            Work_Order__c.WO_Subject__c,
            Work_Order__c.WO_Type__c,
            Work_Order__c.StartDate__c,
            Work_Order__c.ClosedDate_c__c,
            Work_Order__c.Name
        };
    }

    /*Required by fflib*/
    public Schema.SObjectType getSObjectType() {
        return Work_Order__c.SObjectType;
    }

    public Map<Id, Work_Order__c> selectWorkOrdersByExternalId(Set<Id> externalIds) {

        Map<Id, Work_Order__c> returnMap = new Map<Id, Work_Order__c> ();

        String queryCondition = 'ExternalId__c in :externalIds';

        fflib_QueryFactory queryFactory = newQueryFactory()
            .setCondition(queryCondition)
            .selectFields(getSObjectFieldList());
            
        fflib_SObjectSelector complaintSelector = (fflib_SObjectSelector) CrmComplaintIntegrationApplication.selector.newInstance(CMPL123CME__Complaint__c.SObjectType);
        complaintSelector.configureQueryFactoryFields(queryFactory, 'ComplaintId__r');
        
        for (Work_Order__c workOrder : Database.query(queryFactory.toSOQL())) {
            returnMap.put(workOrder.ExternalId__c, workOrder);
        }

        return returnMap;
    }

    
}