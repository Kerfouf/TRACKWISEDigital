public class BmxTriggerUtils {

    /**
     * In order to synchronize with the external CRM system, "shadow" Investigation records
     * are created to link related investigations to a case object in the external CRM
     * These shadow records should not be audit trailed , so applicable records are tagged using the 
     * BMX_Invest_Reference__c field, which is then checked here to flag the records as non auditable.
     * This won't work in bulk update situations where at least one record is auditable because the Audit logic
     * is not row by row
     */
    public static Boolean shouldAuditInvestigation() {
        Boolean shouldAudit = false;
        for(Integer i =0 ; i< Trigger.new.size() && !shouldAudit; i++) {
            CMPL123CME__Investigation__c candidate = (CMPL123CME__Investigation__c ) Trigger.new.get(i);
            shouldAudit = !candidate.BMX_Invest_Reference__c; //If the checkbox is checked, don't audit this record.
        }
        return shouldAudit;
    }
}