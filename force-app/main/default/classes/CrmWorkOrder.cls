/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class CrmWorkOrder {
    
    private List<WorkOrder__x> externalWorkOrders;
    private Map<Id, Work_Order__c> workOrdersByExternalId;

    public CrmWorkOrder(List<WorkOrder__x> externalWorkOrders, Map<Id, Work_Order__c> workOrdersByExternalId) {
        this.externalWorkOrders = externalWorkOrders;
        this.workOrdersByExternalId = workOrdersByExternalId;
    }

    public List<Work_Order__c> toWorkOrdersUpsertList() {

        List<Work_Order__c> returnList = new List<Work_Order__c>();
    
        for (WorkOrder__x externalWorkOrder : externalWorkOrders) {
            Work_Order__c existingWorkOrder = workOrdersByExternalId.get(externalWorkOrder.ExternalId);

            if (existingWorkOrder == null) {
                returnList.add(
                    new Work_Order__c(
                        ComplaintId__r = new CMPL123CME__Complaint__c(BMX_Case_External_Id__c = externalWorkOrder.CaseId__r.ExternalId),
                        ExternalId__c = externalWorkOrder.ExternalId,
                        WO_Category__c = externalWorkOrder.Categories_c__c,
                        WO_Status__c = externalWorkOrder.Status__c,
                        WO_Sub_Category__c = externalWorkOrder.SubCategory_c__c,
                        WO_Subject__c = externalWorkOrder.Subject__c,
                        WO_Type__c = externalWorkOrder.SAP_ServiceOrderType_c__c,
                        StartDate__c = externalWorkOrder.StartDate__c,
                        ClosedDate_c__c = externalWorkOrder.ClosedDate_c__c,
                        Name = externalWorkOrder.WorkOrderNumber__c
                    )
                );
            }
            else {
                if (requiresUpdate(externalWorkOrder, existingWorkOrder)) {
                    // update existing
                    existingWorkOrder.WO_Category__c = externalWorkOrder.Categories_c__c;
                    existingWorkOrder.WO_Status__c = externalWorkOrder.Status__c;
                    existingWorkOrder.WO_Sub_Category__c = externalWorkOrder.SubCategory_c__c;
                    existingWorkOrder.WO_Subject__c = externalWorkOrder.Subject__c;
                    existingWorkOrder.WO_Type__c = externalWorkOrder.SAP_ServiceOrderType_c__c;
                    existingWorkOrder.StartDate__c = externalWorkOrder.StartDate__c;
                    existingWorkOrder.ClosedDate_c__c = externalWorkOrder.ClosedDate_c__c;
                    existingWorkOrder.Name = externalWorkOrder.WorkOrderNumber__c;
                    
                    // add to list
                    returnList.add(existingWorkOrder);
                }
            }
        }

        return returnList;
    }

    private Boolean requiresUpdate(WorkOrder__x externalWorkOrder, Work_Order__c existingWorkOrder) {
        Boolean categoryChanged = externalWorkOrder.Categories_c__c != existingWorkOrder.WO_Category__c;
        Boolean statusChanged = externalWorkOrder.Status__c != existingWorkOrder.WO_Status__c;
        Boolean subCategoryChanged = externalWorkOrder.Categories_c__c != existingWorkOrder.WO_Category__c;
        Boolean subjectChanged = externalWorkOrder.Subject__c != existingWorkOrder.WO_Subject__c;
        Boolean typeChanged = externalWorkOrder.SAP_ServiceOrderType_c__c != existingWorkOrder.WO_Type__c;
        Boolean startDateChanged = externalWorkOrder.StartDate__c != existingWorkOrder.StartDate__c;
        Boolean closedDateChanged = externalWorkOrder.ClosedDate_c__c != existingWorkOrder.ClosedDate_c__c;
        Boolean nameChanged = externalWorkOrder.WorkOrderNumber__c != existingWorkOrder.Name;

        return nameChanged || categoryChanged || statusChanged || subCategoryChanged || subjectChanged || typeChanged || startDateChanged || closedDateChanged;
    }
}