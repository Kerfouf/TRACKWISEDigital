/*
* Created on Wed Nov 3, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/
public inherited sharing class CrmCases {

    private final List<String> CLOSED_CASE_STATUSES = new List<String> { 'Closed', 'Irrelevant' };
    private final String CLOSED_COMPLAINT_STATUS = 'Closed';
    
    private List<Case__x> externalCases;
    private Set<Id> externalCaseIds;
    private CrmComplaintConfigInfo configInfo;
    private ComplaintReferenceInfo complaintInfo;
    private ExternalReferenceInfo extInfo;
    
    private CMPL123CME__Complaint__c complaint;
    private boolean requiresUpsert;

    public CrmCases(List<Case__x> externalCases) {
        this.externalCases = externalCases;
        this.externalCaseIds = extractExternalCaseIds(externalCases);
        this.configInfo = new CrmComplaintConfigInfo();
        this.complaintInfo = new ComplaintReferenceInfo(this.externalCaseIds);
        this.extInfo = new ExternalReferenceInfo(this.externalCases);
    }

    public List<CMPL123CME__Complaint__c> toComplaintsUpsertList() {        
        
        List<CMPL123CME__Complaint__c> complaintsRequiringUpsert = new List<CMPL123CME__Complaint__c>();

        for (Case__x extCase : this.externalCases) {            
            toComplaint(extCase);
            
            if (this.requiresUpsert) {
                complaintsRequiringUpsert.add(this.complaint);
            }
        }

        return complaintsRequiringUpsert;
    }

    private Set<Id> extractExternalCaseIds(List<Case__x> externalCases) {
        Set<Id> returnVal = new Set<Id>();
        for (Case__x externalCase : externalCases) {
            returnVal.add(externalCase.ExternalId);
        }
        return returnVal;
    }

    private void toComplaint(Case__x extCase) {
        
        this.requiresUpsert = false;
        this.complaint = this.complaintInfo.getComplaintData(extCase.ExternalId);

        // Is the record new?
        setExternalCaseIdIfNew(extCase);

        // Was the case closed?
        autoCloseComplaintIfCaseClosed(extCase);

        // Was the case re-opened?
        reopenComplaintIfCaseReopened(extCase);

        // Populate the complaint record with data from the external Case object
        populateComplaintDetailsFromExternalCase(extCase);

        // Populate the complaint record with data from related external objects
        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalContactData(extCase.ContactId__c), 
            'ContactId__c',
            'Contact__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAssetData(extCase.AssetId__c), 
            'AssetId__c',
            'Asset__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.RESULT_c__c), 
            'RESULT_c__c',
            'CodeGroup_c__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.SAMPLE_c__c), 
            'SAMPLE_c__c',
            'CodeGroup_c__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.SatisfactionCode_c__c), 
            'SatisfactionCode_c__c',
            'CodeGroup_c__x'
        );

        // populateComplaintDetailsFromExternalObjects(
        //     this.extInfo.getExternalCodeGroupData(extCase.SoftwareCode_c__c), 
        //     'SoftwareCode_c__c'
        // );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.ActionCode_c__c), 
            'ActionCode_c__c',
            'CodeGroup_c__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.ANALYZE_c__c), 
            'ANALYZE_c__c',
            'CodeGroup_c__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.ErrorCode_c__c), 
            'ErrorCode_c__c',
            'CodeGroup_c__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalCodeGroupData(extCase.NoInvestJustif_c__c), 
            'NoInvestJustif_c__c',
            'CodeGroup_c__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalUserData(extCase.CreatedById__c), 
            'CreatedById__c',
            'User__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalUserData(extCase.OwnerId__c), 
            'OwnerId__c',
            'User__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalUserData(extCase.L1Owner_c__c), 
            'L1Owner_c__c',
            'User__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalUserData(extCase.L2Owner_c__c), 
            'L2Owner_c__c',
            'User__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalUserData(extCase.LastModifiedById__c), 
            'LastModifiedById__c',
            'User__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalEntitlementData(extCase.EntitlementId__c), 
            'EntitlementId__c',
            'Entitlement__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__c), 
            'AccountId__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c), 
            'Global_Reporting_Hierarchy_Level_1_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c), 
            'Global_Reporting_Hierarchy_Level_2_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c), 
            'Global_Reporting_Hierarchy_Level_3_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Key_Account_Hierarchy_c__c), 
            'Key_Account_Hierarchy_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Pricing_Hierarchy_c__c), 
            'Pricing_Hierarchy_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Pricing_Hierarchy_2_c__c), 
            'Pricing_Hierarchy_2_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAccountData(extCase.AccountId__r.Reporting_Hierarchy_c__c), 
            'Reporting_Hierarchy_c__c',
            'Account__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalRecordTypeData(extCase.AccountId__r.RecordTypeId__c), 
            'RecordTypeId__c',
            'RecordType__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalProductData(extCase.ProductId__c), 
            'ProductId__c',
            'Product2__x'
        );

        // populateComplaintDetailsFromExternalObjects(
        //     this.extInfo.getExternalProductData(extCase.Product_c__c), 
        //     'Product_c__c'
        // );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalLocationData(extCase.ShipToLocation_c__c), 
            'ShipToLocation_c__c',
            'Location__x'
        );

        populateComplaintDetailsFromExternalObjects(
            this.extInfo.getExternalAddressData(extCase.ShipToLocation_c__r.VisitorAddressId__c), 
            'VisitorAddressId__c',
            'Address__x'
        );
    }

    private void setExternalCaseIdIfNew(Case__x extCase) {
        if (this.complaint.BMX_Case_External__c == null) {
            this.complaint.BMX_Case_External__c = extCase.ExternalId;
            requiresUpsert = true;
        }
    }

    private void autoCloseComplaintIfCaseClosed(Case__x extCase) {
        if (CLOSED_CASE_STATUSES.contains(extCase.Status__c) && this.complaint.CMPL123CME__CMPL123_WF_Status__c != CLOSED_COMPLAINT_STATUS) {
            this.complaint.CMPL123Task_Key_Value__c = 'Autoclose_Complaint';
            requiresUpsert = true;
        }
    }

    private void reopenComplaintIfCaseReopened(Case__x extCase) {
        if (!CLOSED_CASE_STATUSES.contains(extCase.Status__c) && this.complaint.CMPL123CME__CMPL123_WF_Status__c == CLOSED_COMPLAINT_STATUS) {
            this.complaint.CMPL123Task_Key_Value__c = 'ReopenComplaint';
            requiresUpsert = true;
        }
    }

    private void populateComplaintDetailsFromExternalCase(Case__x extCase) {
        populateComplaintDetailsFromExternalObjects(extCase, 'Case__x');
    }

    private void populateComplaintDetailsFromExternalObjects(SObject obj, String objType) {
        populateComplaintDetailsFromExternalObjects(obj, null, objType);
    }

    private void populateComplaintDetailsFromExternalObjects(SObject obj, String relationShipFieldName, String objType) {
        
        List<CRM_TWD_Complaint_Creation__mdt> mdtList = this.configInfo.getMappingsForObject(objType);
        
        for (CRM_TWD_Complaint_Creation__mdt mdt : mdtList) {
            
            Object oCrmValue = obj == null ? '' : obj.get(mdt.CRM_Field_API_Name__c);
            Object oTwdValue = this.complaint.get(mdt.TWD_Field_API_Name__c);
            
            if (isMatch(mdt, relationShipFieldName, oCrmValue, oTwdValue)) {

                if (oTwdValue == null && oCrmValue != null && String.valueOf(oCrmValue) == '') {
                    continue;
                }
                else if (oCrmValue instanceof String && oTwdValue instanceof String) {
                    String crmValue = (String) oCrmValue;
                    String twdValue = (String) oTwdValue;
                    if (crmValue.normalizeSpace() != twdValue.normalizeSpace()){
                        this.complaint.put(mdt.TWD_Field_API_Name__c, crmValue);
                        this.requiresUpsert = true;
                    }
                }
                else {
                    this.complaint.put(mdt.TWD_Field_API_Name__c, oCrmValue);
                    this.requiresUpsert = true;
                }
            }
        }
    }

    private Boolean isMatch(CRM_TWD_Complaint_Creation__mdt mdt, String relationShipFieldName, Object oCrmValue, Object oTwdValue) {
        return ((mdt.Relationship_Name__c == null && relationShipFieldName == null) || mdt.Relationship_Name__c == relationShipFieldName)
            && oCrmValue != oTwdValue;
    }
}