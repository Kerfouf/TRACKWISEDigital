/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : CreateComplaintForCaseBatch
* @Why   : Batch class to create Complaint records from the Cases which are of type "Technical Complaint" coming from CRM through External Data Source.
*          Also few text fields of external Case are getting updated.
* @When  : 30-NOV-2018

*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        30-NOV-2018         Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

global class CreateComplaintForCaseBatch implements Database.Batchable<sObject>, Database.Stateful,Database.AllowsCallouts {
    
    String queryString;
    
    public Static Final String caseExObjAPIName = 'Case__x';
    public Static Final String contactExObjAPIName = 'Contact__x';
    public Static Final String assetExObjAPIName = 'Asset__x';
    public Static Final String codeGroupExObjAPIName = 'CodeGroup_c__x';
    public Static Final String userExObjAPIName = 'User__x';
    public Static Final String entitlementExObjAPIName = 'Entitlement__x';
    public Static Final String accountExObjAPIName = 'Account__x';
    public Static Final String productExObjAPIName = 'Product2__x';
    public Static Final String locationExObjAPIName = 'Location__x';
    public Static Final String addressExObjAPIName = 'Address__x';
    public Static Final String recTypeExObjAPIName = 'RecordType__x';
    Datetime latestTimeStamp;
    Boolean timeStampUpdated = false;
    public Integer limitCount;
    Datetime lastExecuted;
    
    List<CMPL123CME__Complaint__c> totComplaintReopenList = new List<CMPL123CME__Complaint__c>();
    List<CMPL123CME__Complaint__c> totComplaintReopenUpdList = new List<CMPL123CME__Complaint__c>();
    List<CMPL123CME__Complaint__c> totComplaintAutoCloseList = new List<CMPL123CME__Complaint__c>();
    List<CMPL123CME__Complaint__c> createAssessmentForCmplntList = new List<CMPL123CME__Complaint__c>();
    
    Map<Id, Case__x> totCaseExUpdMap = new Map<Id, Case__x>();
    
    //Intializing external Case query string, limit count and latest time stamp in the constructor
    global CreateComplaintForCaseBatch(String queryString, Integer limitCount, Datetime lastExecuted) {
        this.queryString = queryString;
        this.limitCount = limitCount;
        this.lastExecuted = lastExecuted;
        this.latestTimeStamp = Complaint_Creation_Batch_Time__c.getInstance().Batch_Completion_Time__c;
    }
    
    // querying the external Case records
    global Database.QueryLocator start(Database.BatchableContext bc) { 
        if(!Test.isRunningTest()){
            return Database.getQueryLocator(queryString);
        }else{
            return Database.getQueryLocator('SELECT Id FROM Case LIMIT 1');
        } 
    }
    
    global void execute(Database.BatchableContext bc, List<sobject> caseQuerysObjLst) {
        List<Case__x> caseQueryList = new List<Case__x>();
        if(!Test.isRunningTest()){
            for(Sobject sObj: caseQuerysObjLst){
                Case__x extCaseObj = (Case__x) sObj;
                caseQueryList.add(extCaseObj);
            }
        }
        
        system.debug('==caseQueryList=='+caseQueryList);
        
        if(Test.isRunningTest()){
            caseQueryList.add(BMX_TestDataFactory.getCaseExRecords());
        }
        
        List<Case__x> caseExList = new List<Case__x>();
        List<Case__x> caseExUpdList = new List<Case__x>();
        List<CMPL123CME__Complaint__c> complaintUpsertList = new List<CMPL123CME__Complaint__c>();
        List<CMPL123CME__Complaint__c> complaintReopenList = new List<CMPL123CME__Complaint__c>();
        List<CMPL123CME__Complaint__c> complaintReopenUpdList = new List<CMPL123CME__Complaint__c>();
        List<CMPL123CME__Complaint__c> complaintAutoCloseList = new List<CMPL123CME__Complaint__c>();
        
        List<CRM_TWD_Complaint_Creation__mdt> caseComplaintMappingList = new List<CRM_TWD_Complaint_Creation__mdt>();
        List<CRM_TWD_Complaint_Creation__mdt> caseOtherObjMappingList = new List<CRM_TWD_Complaint_Creation__mdt>();
        
        List<Database.upsertResult> upsertResultList = new List<Database.upsertResult>();
        
        // Sets to keep external record Ids of all the external objects
        Set<Id> caseExIdSet = new Set<Id>();
        Set<Id> contactExIdSet = new Set<Id>();
        Set<Id> assetExIdSet = new Set<Id>();
        Set<Id> codeGroupExIdSet = new Set<Id>();
        Set<Id> userExIdSet = new Set<Id>();
        Set<Id> entitlementExIdSet = new Set<Id>();
        Set<Id> accountExIdSet = new Set<Id>();
        Set<Id> recordTypeExIdSet = new Set<Id>();
        Set<Id> productExIdSet = new Set<Id>();
        Set<Id> locationExIdSet = new Set<Id>();
        Set<Id> addressExIdSet = new Set<Id>();
        Set<Id> caseIdSet = new Set<Id>();
        
        // Maps to keep all the external records 
        Map<Id, Case__x> caseExMap = new Map<Id, Case__x>();
        Map<Id, Contact__x> contactExMap = new Map<Id, Contact__x>();
        Map<Id, Asset__x> assetExMap = new Map<Id, Asset__x>();
        Map<Id, CodeGroup_c__x> codeGroupExMap = new Map<Id, CodeGroup_c__x>();
        Map<Id, User__x> userExMap = new Map<Id, User__x>();
        Map<Id, Entitlement__x> entitlementExMap = new Map<Id, Entitlement__x>();
        Map<Id, Account__x> accountExMap = new Map<Id, Account__x>();
        Map<Id, RecordType__x> recordTypeExMap = new Map<Id, RecordType__x>();
        Map<Id, Product2__x> productExMap = new Map<Id, Product2__x>();
        Map<Id, Location__x> locationExMap = new Map<Id, Location__x>();
        Map<Id, Address__x> addressExMap = new Map<Id, Address__x>();
        Map<Id, CMPL123CME__Complaint__c> cmpResultMap = new Map<Id, CMPL123CME__Complaint__c>();
        Map<Id, Case__x> caseExUpdMap = new Map<Id, Case__x>();
        
        for(Case__x csx : [SELECT Id, CaseNumber_c__c, Entitlement_Name__c, Justificationdecision_make_c__c,DistributorTicketNumber_c__c, ExternalId, BatchExpDate_c__c,SerialNumberAsset_c__c,Reason__c,ATC_c__c,
                            BatchNumber_c__c,UDI_Code_c__c,CaseNumber__c,FirstL2EscalationDate_c__c,DueDate_c__c,CVM_c__c,ClosedDate__c,CustomerContactDate_c__c,Product_c__c,
                            Initial_Software_Version_c__c,CurrentLevel_c__c,ContactEmail__c,isCreatedOnSite_c__c,ContactPhone__c,CatalogProfile_c__c,CaseHasWO_c__c,BatchNumberUnknown_c__c,
                            CreatedDate__c,BatchNumberStatus_c__c,WasEscalated_c__c,Type__c,SubOrigin_c__c,SIGcode_c__c,Subject__c,ShiptoLocationSapNumber_c__c,Status__c,
                            SAPCustomerNumber_c__c,Priority__c,PRE5_c__c,PRE6_c__c,PRE4_c__c,PRE5P2_c__c,PRE2P2_c__c,PRE3P2_c__c,PRE3_1_c__c,PRE1_c__c,PRE2_1_c__c,INVEST_c__c,Origin_c__c,
                            PRE_YesNo_c__c,MaterialCode_c__c,Description_c__c,LastL2toL1DeescalationDate_c__c,SAPAssetNumber_c__c,LastATCSentDateTime_c__c,InvQ6_c__c,InvQ5_c__c,
                            InvQ4_c__c,InvQ3_c__c,InvQ2_c__c,InvQ1_c__c,InvestSubmittedBy_c__c,IsInternalCase_c__c,FirstL2OwnershipTaken_c__c,AssetRecordType_c__c,
                            LastL2EscalationDate_c__c,ContactId__c,EntitlementId__c,FunctionalLocation_c__c,LastModifiedById__c,RESULT_c__c,SAMPLE_c__c,SatisfactionCode_c__c,
                            SoftwareCode_c__c,ActionCode_c__c,ANALYZE_c__c,ErrorCode_c__c,NoInvestJustif_c__c,AssetId__c,ProductId__c,L1Owner_c__c,L2Owner_c__c,CreatedById__c,AccountId__c,ShipToLocation_c__c,SofwareVersion_c__c,ParentId__c, OwnerId__c,LastModifiedDate__c,Case_First_Closed_Date_c__c,FixedOnPhone_c__c,
                            GDPR_L1Q2_c__c,GDPR_L2Q2_c__c,GDPR_L1Q1_c__c,GDPR_L2Q1_c__c,RE_c__c,ShipToLocation_c__r.VisitorAddressId__c,AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c,
                            AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c,AccountId__r.Key_Account_Hierarchy_c__c,AccountId__r.Pricing_Hierarchy_2_c__c,AccountId__r.Pricing_Hierarchy_c__c,
                            AccountId__r.Reporting_Hierarchy_c__c,AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c,AccountId__r.RecordTypeId__c , NumberOfSamplesAffected__c,Product_Code_c__c,PRE1P2__c,Source__c,Contract__c,Severity__c,Social_Media_Impact__c,Customer_type__c,ReagentMaterialCode_c__c,Supplier_ticket_number__c,Trade_type__c,IMDRF_Annex_A_Code__c,IMDRF_Annex_A_Term__c    FROM Case__x 
                            WHERE Id IN: caseQueryList AND ( TWComplaintNumber_c__c = NULL OR  TWComplaintNumber_c__c LIKE 'CN%' ) ]) {
            
            // Filter out any cases that are created outside CRM - Case Number (CaseNumber__c) SAP Case Number (CaseNumber_c__c)
            if ( csx.CaseNumber_c__c == csx.CaseNumber__c) { // As of Winter 20' Direct field comparisons aren't allowed within SOQL
                caseExList.add(csx);
            }
        }
        
        
        if(Test.isRunningTest()){
            caseExList.add(BMX_TestDataFactory.getCaseExRecords());
        }
        
        for(Case__x cs : caseExList) {
            // populating the sets with the parent Ids of the Case Object
            caseIdSet.add(cs.ExternalId);
            caseExIdSet.add(cs.ParentId__c);
            contactExIdSet.add(cs.ContactId__c);
            assetExIdSet.add(cs.AssetId__c);
            assetExIdSet.add(cs.FunctionalLocation_c__c);
            codeGroupExIdSet.add(cs.RESULT_c__c);
            codeGroupExIdSet.add(cs.SAMPLE_c__c);
            codeGroupExIdSet.add(cs.SatisfactionCode_c__c);
            codeGroupExIdSet.add(cs.SoftwareCode_c__c);
            codeGroupExIdSet.add(cs.ActionCode_c__c);
            codeGroupExIdSet.add(cs.ANALYZE_c__c);
            codeGroupExIdSet.add(cs.ErrorCode_c__c);
            codeGroupExIdSet.add(cs.NoInvestJustif_c__c);
            userExIdSet.add(cs.CreatedById__c);
            userExIdSet.add(cs.OwnerId__c);
            userExIdSet.add(cs.L1Owner_c__c);
            userExIdSet.add(cs.L2Owner_c__c);
            userExIdSet.add(cs.LastModifiedById__c);
            userExIdSet.add(cs.Justificationdecision_make_c__c);
            entitlementExIdSet.add(cs.EntitlementId__c);
            accountExIdSet.add(cs.AccountId__c);
            accountExIdSet.add(cs.AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c);
            accountExIdSet.add(cs.AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c);
            accountExIdSet.add(cs.AccountId__r.Key_Account_Hierarchy_c__c);
            accountExIdSet.add(cs.AccountId__r.Pricing_Hierarchy_2_c__c);
            accountExIdSet.add(cs.AccountId__r.Pricing_Hierarchy_c__c);
            accountExIdSet.add(cs.AccountId__r.Reporting_Hierarchy_c__c);
            accountExIdSet.add(cs.AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c);
            recordTypeExIdSet.add(cs.AccountId__r.RecordTypeId__c);
            productExIdSet.add(cs.ProductId__c);
            productExIdSet.add(cs.Product_c__c);
            locationExIdSet.add(cs.ShipToLocation_c__c);
            
            System.debug('Account Id Set' + accountExIdSet.size());
            
            if(cs.ShipToLocation_c__r.VisitorAddressId__c <> null) {
                addressExIdSet.add(cs.ShipToLocation_c__r.VisitorAddressId__c);
            }
        }
        
        // removing the nulls from the sets
        caseExIdSet.remove(null);
        contactExIdSet.remove(null);
        assetExIdSet.remove(null);
        codeGroupExIdSet.remove(null);
        userExIdSet.remove(null);
        entitlementExIdSet.remove(null);
        accountExIdSet.remove(null);
        productExIdSet.remove(null);
        locationExIdSet.remove(null);
        addressExIdSet.remove(null);
        
        Integer recordLimit = Integer.valueOf(Complaint_Creation_Batch_Time__c.getInstance().Record_Limit__c);
        List<Set<Id>> accountLstIds = new List<Set<Id>>();
        Set<Id> accountSetIds = new Set<Id>();
        Integer accountExIdSetSize = accountExIdSet.size();
        
        List<Set<Id>> assetLstIds = new List<Set<Id>>();
        Set<Id> assetSetIds = new Set<Id>();
        Integer assetExIdSetSize = assetExIdSet.size();
        
        List<Set<Id>> codeGrpLstIds = new List<Set<Id>>();
        Set<Id> codeGrpSetIds = new Set<Id>();
        Integer codeGrpExIdSetSize = codeGroupExIdSet.size();
        
        List<Set<Id>> userLstIds = new List<Set<Id>>();
        Set<Id> userSetIds = new Set<Id>();
        Integer userExIdSetSize = userExIdSet.size();
        
        List<Set<Id>> productLstIds = new List<Set<Id>>();
        Set<Id> productSetIds = new Set<Id>();
        Integer productExIdSetSize = productExIdSet.size();
        
        if(accountExIdSetSize < recordLimit){
            accountSetIds.addAll(accountExIdSet);
            accountLstIds.add(accountSetIds);
        } else {
            for(Id key : accountExIdSet){
                accountSetIds.add(key);
                if(accountSetIds.size() >= recordLimit){
                    accountLstIds.add(accountSetIds);
                    accountSetIds = new Set<Id>();
                }
            }
        }
        
        if(assetExIdSetSize < recordLimit){
            assetSetIds.addAll(assetExIdSet);
            assetLstIds.add(assetSetIds);
        } else {
            for(Id key : assetExIdSet){
                assetSetIds.add(key);
                if(assetSetIds.size() >= recordLimit){
                    assetLstIds.add(assetSetIds);
                    assetSetIds = new Set<Id>();
                }
            }
        }
        
        if(codeGrpExIdSetSize < recordLimit){
            codeGrpSetIds.addAll(codeGroupExIdSet);
            codeGrpLstIds.add(codeGrpSetIds);
        } else {
            for(Id key : codeGroupExIdSet){
                codeGrpSetIds.add(key);
                if(codeGrpSetIds.size() >= recordLimit){
                    codeGrpLstIds.add(codeGrpSetIds);
                    codeGrpSetIds = new Set<Id>();
                }
            }
        }
        
        if(userExIdSetSize < recordLimit){
            userSetIds.addAll(userExIdSet);
            userLstIds.add(userSetIds);
        } else {
            for(Id key : userExIdSet){
                userSetIds.add(key);
                if(userSetIds.size() >= recordLimit){
                    userLstIds.add(userSetIds);
                    userSetIds = new Set<Id>();
                }
            }
        }
        
        if(productExIdSetSize < recordLimit){
            productSetIds.addAll(productExIdSet);
            productLstIds.add(productSetIds);
        } else {
            for(Id key : productExIdSet){
                productSetIds.add(key);
                if(productSetIds.size() >= recordLimit){
                    productLstIds.add(productSetIds);
                    productSetIds = new Set<Id>();
                }
            }
        }
        
        if(accountExIdSetSize > recordLimit && math.mod(accountExIdSetSize, recordLimit) != 0){
            accountLstIds.add(accountSetIds);
        }
        
        if(assetExIdSetSize > recordLimit && math.mod(assetExIdSetSize, recordLimit) != 0){
            assetLstIds.add(assetSetIds);
        }
        
        if(codeGrpExIdSetSize > recordLimit && math.mod(codeGrpExIdSetSize, recordLimit) != 0){
            codeGrpLstIds.add(codeGrpSetIds);
        }
        
        if(userExIdSetSize > recordLimit && math.mod(userExIdSetSize, recordLimit) != 0){
            userLstIds.add(userSetIds);
        }
        
        if(productExIdSetSize > recordLimit && math.mod(productExIdSetSize, recordLimit) != 0){
            productLstIds.add(productSetIds);
        }
        
        for(CMPL123CME__Complaint__c cmp : [SELECT Id,BMX_Error_Code_Code__c, Justification_Decision_Maker__c,Justification_decision_Maker_Name__c,Distributor_Ticket_Number__c,BMX_Assessment_Created__c,CMPL123CME__CMPL123_WF_Status__c,
                                            BMX_Case_External_Id__c,CMPL123Task_Key_Value__c,BMX_Status__c,Visitor_City__c,Visitor_Street__c,BMX_Visitor_State__c,
                                            Visitor_Country__c, BMX_Case_Software_Version__c,BMX_Visitor_Address_Name__c,
                                            Visitor_Address_Name__c,BMX_Satisfaction_External__c,BMX_Satisfaction__c,BMX_SAMPLE_External__c,BMX_SAMPLE__c,BMX_RESULT_External__c,
                                            BMX_RESULT__c,BMX_Product_Name__c,BMX_Product_External__c,BMX_Case_Owner_Name__c,BMX_Case_Owner__c,BMX_No_Invest_Justification__c,
                                            BMX_No_Invest_Justification_External__c,BMX_Case_Last_Modified_By__c,BMX_Case_Last_Modified_By_External__c,BMX_Level_2_Owner_External__c,
                                            BMX_Level_2_Owner__c,BMX_Level_1_Owner_External__c,BMX_Level_1_Owner__c,BMX_System__c,BMX_Asset_External__c,BMX_Error_Code__c,
                                            BMX_Error_Code_External__c,BMX_Entitlement_Name__c,BMX_Case_Created_By__c,BMX_Created_By__c,
                                            BMX_Contact_Name__c,BMX_Contact_External__c,BMX_Asset__c,BMX_Assets_External__c,BMX_ANALYZE_External__c,BMX_Analyze__c,
                                            BMX_Action_Code_External__c,BMX_Action_Code__c,BMX_Global_reporting_hierarchy_Level_3__c,BMX_Account_Record_Type__c,
                                            BMX_Global_reporting_hierarchy_Level_2__c,BMX_Global_reporting_hierarchy_Level_4__c,BMX_Account_Category__c,BMX_Division__c,
                                            BMX_Region__c,BMX_Local_pricing_hierarchy_2__c,BMX_Local_pricing_hierarchy__c, BMX_Local_reporting_hierarchy__c,
                                            BMX_Account_Name__c,BMX_Global_reporting_hierarchy_Level_1__c,BMX_Market__c,AccountId__c,BMX_Subsidiary__c,BMX_Account_Sub_category__c,
                                            BMX_Activities__c,Case_Has_WO__c, BMX_BatchNumberUnknown__c,BMX_Catalog_Profile__c,BMX_GDPR_L1Q1__c,BMX_ATC__c, BMX_LongDescription__c,
                                            BMX_PRE3P2__c,BMX_InvQ5_User_Customer_impact_risk__c, BMX_Origin__c,BMX_InvQ4_Was_the_IFU_followed__c,BMX_FixedOnPhone__c,BMX_PRE__c,
                                            BMX_Case_External__c,BMX_Subject__c, BMX_PRE4_PatientHarmedTreatedIncorrectly__c,BMX_UDI_Code__c,BMX_Parent_Case_External__c,
                                            BMX_Case_Date_Time_Opened__c,BMX_INVEST__c,BMX_CaseNumber__c,BMX_Contact_Email__c,BMX_GDPR_L2Q2__c,BMX_Created_On_Site__c,
                                            BMX_InvQ2_Is_the_Tech_Complaint_an_RE__c,BMX_PRE2P2__c,BMX_Case_Date_Time_Closed__c,BMX_InvQ3_Open_Invest_exist_on_issue__c,
                                            BMX_Current_Level__c,BMX_PRE3_1_IndirectHarm_patient_reported__c,BMX_Last_L2_to_L1_Deescalation_Date__c, BMX_Batch_Number_Reagent__c,
                                            BMX_Case_Type__c,BMX_Customer_Contact_Date_Time__c,BMX_Ship_to_Location_SAP_Number__c,BMX_SIG_Code__c,BMX_Material_Code__c,
                                            BMX_Last_L2_Escalation_Date__c, BMX_Was_Escalated_c__c, BMX_Internal_Case__c,CMPL123CME__Date_Due__c,BMX_SAP_Asset_Number__c,
                                            BMX_First_L2_Ownership_Taken__c,BMX_GDPR_L1Q2__c,BMX_Asset_Record_Type__c,BMX_Serial_Number_Asset__c, BMX_Product_Code__c,
                                            BMX_First_L2_Escalation_Date__c,BMX_InvQ1_Any_Complaint_data_missing__c,BMX_Parent_Case__c, BMX_InvestSubmittedBy__c,
                                            BMX_Current_Sofware_version__c, BMX_Case_First_Closed_Date__c,BMX_Batch_Number_Status__c, BMX_SAPCustomerNumber__c,
                                            BMX_InvQ6_Trend_on_the_issue_acceptable__c,BMX_PRE1_Patient_or_operator_death__c,BMX_Priority__c,BMX_LastModifiedDate__c,BMX_Sub_Origin__c,
                                            BMX_PRE2_1_Patient_or_operator_harmed__c,BMX_Batch_Expiration_Date__c,BMX_Contact_Phone__c,BMX_GDPR_L2Q1__c,BMX_CVM__c,
                                            BMX_PRE6_Reported_to_local_Reg_Authority__c,BMX_PRE5_WrongResultsPRE_Guidance_014764__c,BMX_Is_Reportable__c,BMX_Last_ATC_Sent_Date__c,
                                            Visitor_Postal_Code__c,NumberOfSamplesAffected__c,PRE1P2__c,Source__c,Contract__c,Severity__c,Social_Media_Impact__c, Customer_type__c,Reagent_material_code__c,EntitlementId__c,Supplier_ticket_number__c,Trade_type__c,IMDRF_Annex_A_Code__c,IMDRF_Annex_A_Term__c FROM CMPL123CME__Complaint__c WHERE BMX_Case_External__c IN : caseIdSet]) {
            cmpResultMap.put(cmp.BMX_Case_External__c, cmp);
        }
        
        // Populating the maps with parent records of the case object
        for(Contact__x conx : [SELECT Id, ExternalId, Name__c FROM Contact__x WHERE ID IN : contactExIdSet]) {
            contactExMap.put(conx.ExternalId, conx);
        }
        for(Set<Id> setId : assetLstIds){
            for(Asset__x asx : [SELECT Id, ExternalId, Name__c FROM Asset__x WHERE ID IN : setId]) {
                assetExMap.put(asx.ExternalId, asx);
            }
        }
        for(Set<Id> setId : codeGrpLstIds){
            for(CodeGroup_c__x cgx : [SELECT Id, ExternalId, Name__c , Code_c__c FROM CodeGroup_c__x WHERE ID IN : setId]) {
                codeGroupExMap.put(cgx.ExternalId, cgx);
            }
        }
        for(Set<Id> setId : userLstIds){
            for(User__x usx : [SELECT Id, ExternalId, Name__c FROM User__x WHERE ID IN : setId]) {
                userExMap.put(usx.ExternalId, usx);
            }
        }
        for(Entitlement__x enx : [SELECT Id, ExternalId, Name__c FROM Entitlement__x WHERE ID IN : entitlementExIdSet]) {
            entitlementExMap.put(enx.ExternalId, enx);
        }
        
        for(Set<Id> setId : accountLstIds){
            for(Account__x acx : [SELECT Id, ExternalId, Name__c,Market_c__c , Region_c__c , SubCategory_c__c , Category_c__c , Subsidiary_c__c , Activities_c__c ,
                                  Division_c__c ,Pricing_Hierarchy_c__c,Pricing_Hierarchy_2_c__c,Reporting_Hierarchy_c__c ,
                                  Global_Reporting_Hierarchy_Level_1_c__c, Global_Reporting_Hierarchy_Level_2_c__c , Global_Reporting_Hierarchy_Level_3_c__c, 
                                  Key_Account_Hierarchy_c__c , RecordTypeId__c FROM Account__x WHERE ID IN : setId]) {
                                      accountExMap.put(acx.ExternalId, acx);
                                      
                                  }  
        }
        
        
        
        for(RecordType__x rcx : [SELECT Id, ExternalId, Name__c FROM RecordType__x WHERE Id IN: recordTypeExIdSet ]) {
            recordTypeExMap.put(rcx.ExternalId, rcx);
        }
        
        for(Set<Id> setId : productLstIds){
            for(Product2__x prdx : [SELECT Id, ExternalId, Name__c, ProductCode__c FROM Product2__x WHERE ID IN: setId]) {
                productExMap.put(prdx.ExternalId, prdx);
            }
        }
        
        for(Location__x lcx : [SELECT Id, ExternalId, Name__c, VisitorAddressId__c FROM Location__x WHERE ID IN : locationExIdSet]) {
            locationExMap.put(lcx.ExternalId, lcx);
        }
        for(Address__x adx : [SELECT Id, ExternalId, City__c, Country__c,State__c,PostalCode__c,Street__c FROM Address__x WHERE ID IN : addressExIdSet]) {
            addressExMap.put(adx.ExternalId, adx);
        }
        
        for(Address__x add : addressExMap.values()) {
            system.debug('Address Record ---> ' + add.Id);
        }
        
        
        if(Test.isRunningTest()){
            accountExMap.put(BMX_TestDataFactory.getAccountExRecord().ExternalId, BMX_TestDataFactory.getAccountExRecord());
            contactExMap.put(BMX_TestDataFactory.getContactExRecord().ExternalId, BMX_TestDataFactory.getContactExRecord());
            assetExMap.put(BMX_TestDataFactory.getAssetExRecord().ExternalId, BMX_TestDataFactory.getAssetExRecord());
            codegroupExMap.put(BMX_TestDataFactory.getCodeGroupExRecord().ExternalId, BMX_TestDataFactory.getCodeGroupExRecord());
            userExMap.put(BMX_TestDataFactory.getUserExRecord().ExternalId, BMX_TestDataFactory.getUserExRecord());
            entitlementExMap.put(BMX_TestDataFactory.getEntitlementExRecord().ExternalId, BMX_TestDataFactory.getEntitlementExRecord());
            productExMap.put(BMX_TestDataFactory.getProductExRecord().ExternalId, BMX_TestDataFactory.getProductExRecord());
            locationExMap.put(BMX_TestDataFactory.getLocationExRecord().ExternalId, BMX_TestDataFactory.getLocationExRecord());
        }
        
        for(CRM_TWD_Complaint_Creation__mdt mdt : [SELECT CRM_Field_API_Name__c ,Object_API_Name__c ,TWD_Field_API_Name__c, Relationship_Name__c
                                                   FROM CRM_TWD_Complaint_Creation__mdt]) {
                                                       if(mdt.Object_API_Name__c == 'Case__x') {
                                                           caseComplaintMappingList.add(mdt);
                                                       } else {
                                                           caseOtherObjMappingList.add(mdt);
                                                       }
                                                   }
        
        for(Case__x cs : caseExList) {
            
            Boolean isInsert = false;
            Boolean techComplaint = false;
            Boolean reopenedComplaint = false;
            Boolean caseUpdateRequired = false;
            Boolean autoCloseComplaint = false;
            Utils_CreateComplaintForCaseBatch.recordUpdateRequired = false;
            
            CMPL123CME__Complaint__c cmplnt;
            CMPL123CME__Complaint__c reoependCmplntRecord;
            
            
            if(cmpResultMap.get(cs.ExternalId) <> null) {
                cmplnt = cmpResultMap.get(cs.ExternalId);
            } else {
                cmplnt = new CMPL123CME__Complaint__c();
            }
            
            if(cs.Type__c == 'TechnicalComplaint') {
                techComplaint = true;
            }
            
            // Checking if there is a existing complaint for the external Case
            if(cmplnt.Id == null) {
                isInsert = true;
            }
            if( !isInsert && cmplnt.CMPL123CME__CMPL123_WF_Status__c == 'Closed' && (cmplnt.BMX_Status__c == 'Closed' || cmplnt.BMX_Status__c == 'Irrelevant') ) {
                reopenedComplaint = true;
                reoependCmplntRecord = new CMPL123CME__Complaint__c(Id=cmplnt.Id, BMX_Case_External__c=cmplnt.BMX_Case_External__c);
            }
            if( !isInsert && cmplnt.CMPL123CME__CMPL123_WF_Status__c <> 'Closed' && (cs.Status__c == 'Closed' || cs.Status__c == 'Irrelevant')) {
                autoCloseComplaint = true;
            }
            
            if(techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, cs, caseComplaintMappingList, caseExObjAPIName, isInsert, '');
            }
            
            if(cs.ContactId__c <> null && contactExMap.get(cs.ContactId__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, contactExMap.get(cs.ContactId__c), caseOtherObjMappingList, contactExObjAPIName, isInsert, 'ContactId__c');
            }
            
            if(cs.AssetId__c <> null && assetExMap.get(cs.AssetId__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, assetExMap.get(cs.AssetId__c), caseOtherObjMappingList, assetExObjAPIName, isInsert, 'AssetId__c');
            }
            
            if(cs.RESULT_c__c <> null && codeGroupExMap.get(cs.RESULT_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.RESULT_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'RESULT_c__c');
            }
            
            if(cs.SAMPLE_c__c <> null && codeGroupExMap.get(cs.SAMPLE_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.SAMPLE_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'SAMPLE_c__c');
            }
            
            if(cs.SatisfactionCode_c__c <> null && codeGroupExMap.get(cs.SatisfactionCode_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.SatisfactionCode_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'SatisfactionCode_c__c');
            }
            
            if(cs.SoftwareCode_c__c <> null && codeGroupExMap.get(cs.SoftwareCode_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.SoftwareCode_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'SoftwareCode_c__c');
            }

            if(cs.ActionCode_c__c <> null && codeGroupExMap.get(cs.ActionCode_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.ActionCode_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'ActionCode_c__c');
            }
            
            if(cs.ANALYZE_c__c <> null && codeGroupExMap.get(cs.ANALYZE_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.ANALYZE_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'ANALYZE_c__c');
            }
            
            if(cs.ErrorCode_c__c <> null && codeGroupExMap.get(cs.ErrorCode_c__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.ErrorCode_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'ErrorCode_c__c');
                }
            }
            
            if(cs.NoInvestJustif_c__c <> null && codeGroupExMap.get(cs.NoInvestJustif_c__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, codeGroupExMap.get(cs.NoInvestJustif_c__c), caseOtherObjMappingList, codeGroupExObjAPIName, isInsert, 'NoInvestJustif_c__c');
                }
            }
            
            if(cs.CreatedById__c <> null && userExMap.get(cs.CreatedById__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, userExMap.get(cs.CreatedById__c), caseOtherObjMappingList, userExObjAPIName, isInsert, 'CreatedById__c');
            }
            
            if(cs.OwnerId__c <> null && userExMap.get(cs.OwnerId__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, userExMap.get(cs.OwnerId__c), caseOtherObjMappingList, userExObjAPIName, isInsert, 'OwnerId__c');
                }
            }
            
            if(cs.L1Owner_c__c <> null && userExMap.get(cs.L1Owner_c__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, userExMap.get(cs.L1Owner_c__c), caseOtherObjMappingList, userExObjAPIName, isInsert, 'L1Owner_c__c');
                }
            }
            
            if(cs.L2Owner_c__c <> null && userExMap.get(cs.L2Owner_c__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, userExMap.get(cs.L2Owner_c__c), caseOtherObjMappingList, userExObjAPIName, isInsert, 'L2Owner_c__c');    
                }
            }
            
            if(cs.LastModifiedById__c <> null && userExMap.get(cs.LastModifiedById__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, userExMap.get(cs.CreatedById__c), caseOtherObjMappingList, userExObjAPIName, isInsert, 'LastModifiedById__c');
            }
            
            if(cs.EntitlementId__c <> null && entitlementExMap.get(cs.EntitlementId__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, entitlementExMap.get(cs.EntitlementId__c), caseOtherObjMappingList, entitlementExObjAPIName, isInsert, 'EntitlementId__c');
            }
            
            // To check Entitlement is null
            
          /*  if(cs.EntitlementId__c == null && entitlementExMap.get(cs.EntitlementId__c) == null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, entitlementExMap.get(cs.EntitlementId__c), caseOtherObjMappingList, entitlementExObjAPIName, isInsert, 'EntitlementId__c');
            }
*/
            
            if(cs.AccountId__c <> null && accountExMap.get(cs.AccountId__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'AccountId__c');
                }
            }
            
            if(cs.AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c <> null && accountExMap.get(cs.AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Global_Reporting_Hierarchy_Level_3_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Global_Reporting_Hierarchy_Level_3_c__c');
            }
            
            if(cs.AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c <> null && accountExMap.get(cs.AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Global_Reporting_Hierarchy_Level_2_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Global_Reporting_Hierarchy_Level_2_c__c');
            }
            
            if(cs.AccountId__r.Key_Account_Hierarchy_c__c <> null && accountExMap.get(cs.AccountId__r.Key_Account_Hierarchy_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Key_Account_Hierarchy_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Key_Account_Hierarchy_c__c');
            }
            
            if(cs.AccountId__r.Pricing_Hierarchy_2_c__c <> null && accountExMap.get(cs.AccountId__r.Pricing_Hierarchy_2_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Pricing_Hierarchy_2_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Pricing_Hierarchy_2_c__c');
            }
            
            if(cs.AccountId__r.Pricing_Hierarchy_c__c <> null && accountExMap.get(cs.AccountId__r.Pricing_Hierarchy_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Pricing_Hierarchy_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Pricing_Hierarchy_c__c');
            }
            
            if(cs.AccountId__r.Reporting_Hierarchy_c__c <> null && accountExMap.get(cs.AccountId__r.Reporting_Hierarchy_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Reporting_Hierarchy_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Reporting_Hierarchy_c__c');
            }
            
            if(cs.AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c <> null && accountExMap.get(cs.AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, accountExMap.get(cs.AccountId__r.Global_Reporting_Hierarchy_Level_1_c__c), caseOtherObjMappingList, accountExObjAPIName, isInsert, 'Global_Reporting_Hierarchy_Level_1_c__c');
            }
            
            if(cs.AccountId__r.RecordTypeId__c <> null && recordTypeExMap.get(cs.AccountId__r.RecordTypeId__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, recordTypeExMap.get(cs.AccountId__r.RecordTypeId__c), caseOtherObjMappingList, recTypeExObjAPIName, isInsert, 'RecordTypeId__c');
            }
            
            if(cs.ProductId__c <> null && productExMap.get(cs.ProductId__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, productExMap.get(cs.ProductId__c), caseOtherObjMappingList, productExObjAPIName, isInsert, 'ProductId__c');
                }
            }
            
            if(cs.Product_c__c <> null && productExMap.get(cs.Product_c__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, productExMap.get(cs.Product_c__c), caseOtherObjMappingList, productExObjAPIName, isInsert, 'Product_c__c');
                }
            }
            
            if(cs.ShipToLocation_c__c <> null && locationExMap.get(cs.ShipToLocation_c__c) <> null) {
                if(techComplaint) {
                    cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, locationExMap.get(cs.ShipToLocation_c__c), caseOtherObjMappingList, locationExObjAPIName, isInsert, 'ShipToLocation_c__c');
                }
            }
            
            system.debug('Address Value ----> ' + cs.ShipToLocation_c__r.VisitorAddressId__c);
            system.debug('Address Map ----> ' + addressExMap.get(cs.ShipToLocation_c__r.VisitorAddressId__c));
            if(cs.ShipToLocation_c__r.VisitorAddressId__c <> null && addressExMap.get(cs.ShipToLocation_c__r.VisitorAddressId__c) <> null && techComplaint) {
                cmplnt = Utils_CreateComplaintForCaseBatch.populateComplaintDetailsFromExternalObjects(cmplnt, addressExMap.get(cs.ShipToLocation_c__r.VisitorAddressId__c), caseOtherObjMappingList, addressExObjAPIName, isInsert, 'VisitorAddressId__c');
            }
            
            if(cmplnt <> null && techComplaint && (Utils_CreateComplaintForCaseBatch.recordUpdateRequired || isInsert) && !reopenedComplaint && !autoCloseComplaint) {
                complaintUpsertList.add(cmplnt);
            }
            
            if(reopenedComplaint && Utils_CreateComplaintForCaseBatch.recordUpdateRequired && reoependCmplntRecord <> null) {
                complaintReopenList.add(reoependCmplntRecord);
                complaintReopenUpdList.add(cmplnt);
                if(cs.Status__c == 'Closed' || cs.Status__c == 'Irrelevant'){
                    
                    // adding external Cases to the complaintAutoCloseList if the case Status is Closed or Irrelevant
                    complaintAutoCloseList.add(cmplnt);
                }
            }
            
            if(autoCloseComplaint && Utils_CreateComplaintForCaseBatch.recordUpdateRequired) {
                complaintAutoCloseList.add(cmplnt);
            }
            
            if(caseUpdateRequired && cs <> null) {
                caseExUpdList.add(cs);
            }
        }
        
        for(CMPL123CME__Complaint__c cmp : complaintReopenList) {
            cmp.CMPL123Task_Key_Value__c = 'ReopenComplaint';
        }
        
        system.debug('===complaintReopenList===='+complaintReopenList);
        
        for(CMPL123CME__Complaint__c cmp : complaintAutoCloseList) {
            cmp.CMPL123Task_Key_Value__c = 'Autoclose_Complaint';
        }
        system.debug('===complaintAutoCloseList===='+complaintAutoCloseList);
        
        if(caseExUpdList <> null && !caseExUpdList.isEmpty()) {
            //Database.UpdateAsync(caseExUpdList);
            caseExUpdMap.putAll(caseExUpdList);
            totCaseExUpdMap.putAll(caseExUpdMap);
        }
        system.debug('===complaintUpsertList===='+complaintUpsertList);
        if(!complaintUpsertList.isEmpty()) {
            upsertResultList = Database.Upsert(complaintUpsertList, false);
        }
        
        if(!complaintUpsertList.isEmpty()){
            createAssessmentForCmplntList.addAll(complaintUpsertList);
        }
        
        if(!upsertResultList.isEmpty()) {
            List<Error_Log__c> errLogList = new List<Error_Log__c>();
            errLogList = Utils_CreateComplaintForCaseBatch.returnUpsertFailureLogs(upsertResultList, complaintUpsertList, 'CreateComplaintForCaseBatch', 'CMPL123CME__Complaint__c');
            if(!errLogList.isEmpty()) {
                Database.Insert(errLogList, false);
            }
        }
        
        if(!complaintReopenList.isEmpty()) {
            totComplaintReopenList.addAll(complaintReopenList);
        }
        
        system.debug('===complaintReopenList===='+complaintReopenList);
        
        if(!complaintReopenUpdList.isEmpty()) {
            totComplaintReopenUpdList.addAll(complaintReopenUpdList);
        }
        
        system.debug('===complaintReopenUpdList===='+complaintReopenUpdList);
        
        
        if(!complaintAutoCloseList.isEmpty()) {
            totComplaintAutoCloseList.addAll(complaintAutoCloseList);
        }
        
        system.debug('===complaintAutoCloseList===='+complaintAutoCloseList);
    }
    
    global void finish(Database.BatchableContext bc){
        // execute any post-processing operations
        if(!test.isRunningTest() && (!totComplaintReopenList.isEmpty() || !totComplaintReopenUpdList.isEmpty() || !totComplaintAutoCloseList.isEmpty())) {
            
            // executing processReopenCloseComplaintForCaseBatch batch class if the external case is closed/opened in CRM
            processReopenCloseComplaintForCaseBatch pc = new processReopenCloseComplaintForCaseBatch(totComplaintReopenList, totComplaintReopenUpdList ,totComplaintAutoCloseList, lastExecuted);
            Database.executeBatch(pc, 1);
        } else {
            // querying the external Case Comment records which are created/updated in last 24 hours
            
            if(!test.isRunningTest()) {
                
                // executing CreateCaseCommentForComplaintBatch batch class
                CreateCaseCommentForComplaintBatch createCaseComment = new CreateCaseCommentForComplaintBatch(true, lastExecuted);
                database.executebatch(createCaseComment);
            }
        }
        
        if(!createAssessmentForCmplntList.isEmpty()){
            
            // initiating and executing BMX_CreateGlobalAssessmentFrCMPLBatch batch class to create global assessment records for the complaints 
            // having PRE = 'Yes'
            BMX_CreateGlobalAssessmentFrCMPLBatch createGA = new BMX_CreateGlobalAssessmentFrCMPLBatch(createAssessmentForCmplntList);
            database.executeBatch(createGA,1);
        } 
    }
}