/*
* Created on Mon Nov 22, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public interface CrmWorkOrderIntegrationService {
    List<WorkOrder__x> getExternalWorkOrdersByDateModified(DateTime asOf);
    List<WorkOrder__x> getExternalWorkOrdersByExternalIds(Set<Id> externalIds);
    void upsertWorkOrders(List<WorkOrder__x> workOrders);
}