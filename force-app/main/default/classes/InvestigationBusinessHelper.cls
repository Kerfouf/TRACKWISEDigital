/**
#############################################################################
#  File Name     : InvestigationBusinessHelper
#  Author        : Ikhadallem Lotfi 
#  Description: public static handler class for the trigger InvestigationTrigger to ensure every investigation approver user has the role 'Investigation Approver'. 

#############################################################################
*/

public class InvestigationBusinessHelper {
    public static void handle(List<CMPL123CME__Investigation__c> investigations, Map<Id, CMPL123CME__Investigation__c> oldMap) {
        String investRole = Label.INVEST_APPROVE_ROLE;
        String error = Label.ERROR_APPROVER;
        Boolean errorRFA = false;
        Boolean errorCRA = false;
        List<User> approvers = new List<User>();
        List<Id> approverIds = new List<Id>();
        for (CMPL123CME__Investigation__c investigation : investigations) {
            if (!approverIds.contains(investigation.BMX_Investigation_Approver__c)) {
             	approverIds.add(investigation.BMX_Investigation_Approver__c);   
            }
            if (!approverIds.contains(investigation.BMX_Approver_1__c)) {
             	approverIds.add(investigation.BMX_Approver_1__c);   
            }
            if (!approverIds.contains(investigation.BMX_Approver_2__c)) {
             	approverIds.add(investigation.BMX_Approver_2__c);   
            }
            if (!approverIds.contains(investigation.BMX_Approver_3__c)) {
             	approverIds.add(investigation.BMX_Approver_3__c);   
            }
            if (!approverIds.contains(investigation.BMX_Approver_4__c)) {
             	approverIds.add(investigation.BMX_Approver_4__c);   
            }
            if (!approverIds.contains(investigation.BMX_Expert_Investigator__c)) {
             	approverIds.add(investigation.BMX_Expert_Investigator__c);   
            }
            if (!approverIds.contains(investigation.OwnerId)) {
             	approverIds.add(investigation.OwnerId);   
            }
        }
        Map<Id, String> roleMap = new Map<Id, String>();
        for (User approver : [Select id, TWD_Role__c, isActive from user where id in :approverIds]) {
            if (approver.TWD_Role__c != null && approver.isActive) {
             	roleMap.put(approver.id, approver.TWD_Role__c);   
            } else {
                roleMap.put(approver.id, '');
            }
        }
        for (CMPL123CME__Investigation__c investigation : investigations) { 
            if (investigation.BMX_Investigation_Approver__c != oldMap.get(investigation.Id).BMX_Investigation_Approver__c && investigation.BMX_Investigation_Approver__c != null && !roleMap.get(investigation.BMX_Investigation_Approver__c).contains(investRole) && roleMap.get(investigation.BMX_Investigation_Approver__c) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Investigation Approver', investRole}));
            }
            if (investigation.BMX_Approver_1__c != oldMap.get(investigation.Id).BMX_Approver_1__c && investigation.BMX_Approver_1__c != null && !roleMap.get(investigation.BMX_Approver_1__c).contains(investRole) && roleMap.get(investigation.BMX_Approver_1__c) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 1', investRole}));
            }
            if (investigation.BMX_Approver_2__c != oldMap.get(investigation.Id).BMX_Approver_2__c && investigation.BMX_Approver_2__c != null && !roleMap.get(investigation.BMX_Approver_2__c).contains(investRole) && roleMap.get(investigation.BMX_Approver_2__c) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 2', investRole}));
            }
            if (investigation.BMX_Approver_3__c != oldMap.get(investigation.Id).BMX_Approver_3__c && investigation.BMX_Approver_3__c != null && !roleMap.get(investigation.BMX_Approver_3__c).contains(investRole) && roleMap.get(investigation.BMX_Approver_3__c) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 3', investRole}));
            }
            if (investigation.BMX_Approver_4__c != oldMap.get(investigation.Id).BMX_Approver_4__c && investigation.BMX_Approver_4__c != null && !roleMap.get(investigation.BMX_Approver_4__c).contains(investRole) && roleMap.get(investigation.BMX_Approver_4__c) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Approver 4', investRole}));
            }
            if (investigation.BMX_Expert_Investigator__c != oldMap.get(investigation.Id).BMX_Expert_Investigator__c && investigation.BMX_Expert_Investigator__c != null && !roleMap.get(investigation.BMX_Expert_Investigator__c).contains(investRole) && roleMap.get(investigation.BMX_Expert_Investigator__c) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Expert Investigator', investRole}));
            }
            if (investigation.OwnerId != oldMap.get(investigation.Id).OwnerId && investigation.OwnerId != null && !roleMap.get(investigation.OwnerId).contains(investRole) && roleMap.get(investigation.OwnerId) != null) {
                investigation.addError(String.format(Label.ERROR_APPROVER, new List<String>{'Owner', investRole}));
            }
            if (investigation.CMPL123_WF_Status__c == 'Pending Approval' && investigation.CMPL123_WF_Status__c != oldMap.get(investigation.Id).CMPL123_WF_Status__c) {
                for (Run_File_Analysis__c rfa : [Select Assay__c, CurrencyIsoCode, Instrument_Serial_Number__c,
                                                Investigtor_Observation_c__c, Panel__c, Empty_Pouch_Lot__c,
                                                CMPL123Rule_Key_Value__c, Test_Serial_Number__c, Specimen_Type__c,
                                                 Related_Invsestigation__c
                                                from Run_File_Analysis__c where Related_Invsestigation__c = :investigation.id]) {
                    
                                                    
                    if (rfa.Assay__c == null || rfa.Assay__c.trim() == '' || rfa.Instrument_Serial_Number__c == null || rfa.Instrument_Serial_Number__c.trim() == '' || rfa.Investigtor_Observation_c__c == null || rfa.Investigtor_Observation_c__c.trim() == '' || rfa.Panel__c == null || rfa.Panel__c.trim() == '' || rfa.Empty_Pouch_Lot__c == null || rfa.Empty_Pouch_Lot__c.trim() == '' || rfa.Test_Serial_Number__c == null || rfa.Test_Serial_Number__c.trim() == '' || rfa.Specimen_Type__c == null || rfa.Specimen_Type__c.trim() == '') {
                        errorRFA = true;
                    }
                }
                for (Cause_and_Risk_Analysis__c cra : [Select assay__c, BMX_Catalog_Profile__c, Cause_of_Complaint_c__c,
                                                      CurrencyIsoCode, Failure_type__c, Panel__c, Quality_affected__c,
                                                      Risk_ID__c, Related_Invsestigation__c 
                                                      from Cause_and_Risk_Analysis__c
                                                      where Related_Invsestigation__c = :investigation.id]) {
                    if (cra.Assay__c == null || cra.Assay__c.trim() == '' || cra.BMX_Catalog_Profile__c == null || cra.BMX_Catalog_Profile__c.trim() == '' || cra.Cause_of_Complaint_c__c == null || cra.Cause_of_Complaint_c__c.trim() == '' || cra.CurrencyIsoCode == null || cra.CurrencyIsoCode.trim() == '' || cra.Failure_type__c == null || cra.Failure_type__c.trim() == '' || cra.Panel__c == null || cra.Panel__c.trim() == '' || cra.Quality_affected__c == null || cra.Risk_ID__c == null || cra.Risk_ID__c.trim() == '') {
                        errorCRA = true;
                    }
                }
                if (errorCRA && errorRFA) {
					investigation.addError(Label.ERROR_CLOSING_INVEST);                   
                } else if (errorCRA) {
                    investigation.addError(Label.ERROR_CLOSING_INVEST_CRA);
                } else if (errorRFA) {
                    investigation.addError(Label.ERROR_CLOSING_INVEST_RFA);
                }
            }
        }
    }

	public static void handleAfterInsertOrUpdateMasterRef(List<CMPL123CME__Investigation__c> investigations, Map<Id, CMPL123CME__Investigation__c> oldMap)
    {
        List<Intermediate_Answer__c> newAnswers = new List<Intermediate_Answer__c>();
        List<Id> toDelete = new List<Id>();
        for (CMPL123CME__Investigation__c investigation : investigations) {
          	// if the invest is a child invest, then get the IA of the master and insert them on the child
            if (investigation.Master_Investigation__c != null && 
                (oldMap == null || oldMap.get(investigation.id) == null
                 || (oldMap.get(investigation.id) != null && oldMap.get(investigation.id).Master_Investigation__c != investigation.Master_Investigation__c) )) {
                if (oldMap != null && oldMap.get(investigation.id) != null && oldMap.get(investigation.id).Master_Investigation__c != investigation.Master_Investigation__c) {
                    // delete previous master's answers
                    toDelete.add(investigation.id);
                }
                for (Intermediate_Answer__c answer : [Select id, Related_Investigation__c, Intermediate_Answer__c, CurrencyIsoCode, CMPL123Rule_Key_Value__c from Intermediate_Answer__c where Related_Investigation__c = :investigation.Master_Investigation__c]) {
                    Intermediate_Answer__c newAnswer = new Intermediate_Answer__c();
                    newAnswer.CurrencyIsoCode = answer.CurrencyIsoCode;
                    newAnswer.Intermediate_Answer__c = answer.Intermediate_Answer__c;
                    newAnswer.CMPL123Rule_Key_Value__c = answer.CMPL123Rule_Key_Value__c;
                    newAnswer.Related_Investigation__c = investigation.id;
                    System.debug(newAnswer.Related_Investigation__c);
                    newAnswers.add(newAnswer);
                }
            }
        }
		delete [Select id from Intermediate_Answer__c where Related_Investigation__c in :toDelete];
        insert newAnswers;
    }

}