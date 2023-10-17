public with sharing class UpdateChildInvestigationJob implements Database.Batchable<Sobject> {
    private Map<Id, CMPL123CME__Investigation__c> newRecords;

    public UpdateChildInvestigationJob(Map<Id, CMPL123CME__Investigation__c> newRecords){
        this.newRecords = newRecords;
    }


    public Database.QueryLocator start(Database.BatchableContext BC) {            
        return Database.getQueryLocator([SELECT 
                                                Id,
                                                Master_Investigation__c
                                        FROM
                                            CMPL123CME__Investigation__c
                                        WHERE
                                            Master_Investigation__c IN : newRecords.keySet()
        ]);
      }


    public void execute(Database.BatchableContext context , List<CMPL123CME__Investigation__c> childrenToSave){            
        List<CMPL123CME__Investigation__c> toUpdate = new List<CMPL123CME__Investigation__c>();

        for(CMPL123CME__Investigation__c child : childrenToSave){

            CMPL123CME__Investigation__c parent = newRecords.get(child.Master_Investigation__c);
            
            child.BMX_Additional_Information__c = parent.BMX_Additional_Information__c;
            child.BMX_All_Copies_of_Patient_Data_Destroyed__c = parent.BMX_All_Copies_of_Patient_Data_Destroyed__c;
            child.BMX_CAPA_Number__c = parent.BMX_CAPA_Number__c;
            child.BMX_Date_Product_Received__c = parent.BMX_Date_Product_Received__c;
            child.BMX_EstimatedInvestigationDuration_Date__c = parent.BMX_EstimatedInvestigationDuration_Date__c;
            child.BMX_FAB_Justification__c = parent.BMX_FAB_Justification__c;
            child.BMX_FAB_Required__c = parent.BMX_FAB_Required__c;
            child.BMX_Investigation_Answer__c = parent.BMX_Investigation_Answer__c;
            child.BMX_Patient_Data_Copied_to_BMX_System__c = parent.BMX_Patient_Data_Copied_to_BMX_System__c;
            child.B_Investigation_Type_Code_Choice_1__c = parent.B_Investigation_Type_Code_Choice_1__c;
            child.B_Investigation_Type_Code_Choice_2__c = parent.B_Investigation_Type_Code_Choice_2__c;
            child.B_Investigation_Type_Code_Choice_3__c = parent.B_Investigation_Type_Code_Choice_3__c;
            child.B_Investigation_Type_Code_Choice_4__c = parent.B_Investigation_Type_Code_Choice_4__c;
            child.B_Investigation_Type_Code_Choice_5__c = parent.B_Investigation_Type_Code_Choice_5__c;
            child.B_Investigation_Type_Code_Choice_6__c = parent.B_Investigation_Type_Code_Choice_6__c;
            child.CMPL123_WF_Status__c = parent.CMPL123_WF_Status__c;
            child.C_Investigation_Findings_Code_Choice1__c = parent.C_Investigation_Findings_Code_Choice1__c;
            child.C_Investigation_Findings_Code_Choice2__c = parent.C_Investigation_Findings_Code_Choice2__c;
            child.C_Investigation_Findings_Code_Choice3__c = parent.C_Investigation_Findings_Code_Choice3__c;
            child.Correction_Number__c = parent.Correction_Number__c;
            child.D_Investigation_Conclusion_Choice1__c = parent.D_Investigation_Conclusion_Choice1__c;
            child.D_Investigation_Conclusion_Choice2__c = parent.D_Investigation_Conclusion_Choice2__c;
            child.D_Investigation_Conclusion_Choice3__c = parent.D_Investigation_Conclusion_Choice3__c;
            child.G_Component_Code_Choice_1__c = parent.G_Component_Code_Choice_1__c;
            child.G_Component_Code_Choice_2__c = parent.G_Component_Code_Choice_2__c;
            child.G_Component_Code_Choice_3__c = parent.G_Component_Code_Choice_3__c;
            child.Justification_for_Annex_B__c = parent.Justification_for_Annex_B__c;
            child.Justification_for_Annex_C__c = parent.Justification_for_Annex_C__c;
            child.Justification_for_Annex_D__c = parent.Justification_for_Annex_D__c;
            child.Justification_for_Annex_G__c = parent.Justification_for_Annex_G__c;
            child.TWD_CAPA__c = parent.TWD_CAPA__c;
            child.TWD_Cause_Investigation__c = parent.TWD_Cause_Investigation__c;
            
            toUpdate.add(child);                
        }
        update toUpdate;
    }
    public void finish(Database.BatchableContext bc){
        // Do nothing
    }
}