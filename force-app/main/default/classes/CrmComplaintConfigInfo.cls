public inherited sharing class CrmComplaintConfigInfo {
    
    private Map<String, List<CRM_TWD_Complaint_Creation__mdt>> configMap = new Map<String, List<CRM_TWD_Complaint_Creation__mdt>>();
    
    public CrmComplaintConfigInfo() {
        initialize();
    }

    public List<CRM_TWD_Complaint_Creation__mdt> getMappingsForObject(String objectApiName) {
        return configMap.get(objectApiName);
    }

    private void initialize() {
        ComplaintConfigSelector selector = (ComplaintConfigSelector) CrmComplaintIntegrationApplication.selector.newInstance(
            CRM_TWD_Complaint_Creation__mdt.SObjectType
        );

        for (CRM_TWD_Complaint_Creation__mdt config : selector.selectAll()){
            if (!configMap.containsKey(config.Object_API_Name__c)) {
                configMap.put(config.Object_API_Name__c, new List<CRM_TWD_Complaint_Creation__mdt>());
            }
            configMap.get(config.Object_API_Name__c).add(config);
        }
    }
}