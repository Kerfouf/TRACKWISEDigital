/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class CrmWorkOrderIntegrationServiceImpl extends CrmIntegrationService implements CrmWorkOrderIntegrationService, DBSaveFailureCallback {
    
    public List<WorkOrder__x> getExternalWorkOrdersByDateModified(DateTime asOf) {
        ExternalWorkOrderSelector selector = (ExternalWorkOrderSelector) CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        return selector.selectByDateModified(asOf);
    }

    public List<WorkOrder__x> getExternalWorkOrdersByExternalIds(Set<Id> externalIds) {
        ExternalWorkOrderSelector selector = (ExternalWorkOrderSelector) CrmComplaintIntegrationApplication.selector.newInstance(WorkOrder__x.SObjectType);
        return selector.selectByExternalIds(externalIds);
    }

    public void upsertWorkOrders(List<WorkOrder__x> externalWorkOrders) {

        Set<Id> externalWorkOrderExternalIds = extractExternalIds(externalWorkOrders);

        WorkOrderSelector selector = (WorkOrderSelector) CrmComplaintIntegrationApplication.selector.newInstance(Work_Order__c.SObjectType);
        Map<Id, Work_Order__c> workOrdersByExternalId = selector.selectWorkOrdersByExternalId(externalWorkOrderExternalIds);

        List<Work_Order__c> workOrdersToUpsert = new CrmWorkOrder(externalWorkOrders, workOrdersByExternalId).toWorkOrdersUpsertList();

        upsertList(workOrdersToUpsert, this);
    }

    public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
        logError(
            'Id',
            'ExternalId__c',
            'CrmWorkOrderIntegrationServiceImpl',
            'Work_Order__c',
            failures
        );
    }
}