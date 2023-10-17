public class EU_MIR_InvestigationHandler_Invocable {
    
    @InvocableMethod
    public static void populateInvist_Updatein(List<EU_mirWrapper> EMIRSetId)
    {
    
        try 
        {
            system.debug('MSR::EMIRSetId...'+EMIRSetId);
            List<CMPL123CME__EU_MIR__c> mirlist=[Select id,CMPL123CME__Complaint__c,CMPL123CME__Type_Of_Report__c from CMPL123CME__EU_MIR__c where id=:EMIRSetId[0].Eumirids];
            List<CMPL123CME__Investigation__c> invstList = new List<CMPL123CME__Investigation__c>();
            List<CMPL123CME__EU_MIR__c> eumirList = new List<CMPL123CME__EU_MIR__c>();
            if(checkRecursiveonEMIR.isFirstTime)
            {
                checkRecursiveonEMIR.isFirstTime = false;
                Map<Id, Id> cmptmap = new Map<Id, Id>();             
                for(CMPL123CME__EU_MIR__c mir:mirlist)
                {
                     if(mir.CMPL123CME__Complaint__c !=null && (mir.CMPL123CME__Type_Of_Report__c == 'Initial'|| mir.CMPL123CME__Type_Of_Report__c=='Follow up') ){     
                        cmptmap.put(mir.CMPL123CME__Complaint__c,mir.Id);
                     }
                
                }
                
                system.debug('MSR::cmptmap...'+cmptmap);
                Map<Id, Id> complainIdToInvstIdMap = new Map<Id, Id>(); 
                if(!cmptmap.isEmpty())
                {
                
                    for(CMPL123CME__Investigation__c inv:[SELECT Id,CMPL123CME__Complaint__c,EU_MIR__c,CMPL123_WF_Status__c FROM CMPL123CME__Investigation__c WHERE (NOT CMPL123_WF_Status__c like '%Closed%') AND CMPL123CME__Complaint__c IN:cmptmap.keyset()])
                    {
                        complainIdToInvstIdMap.put(inv.CMPL123CME__Complaint__c, inv.Id);
                        
                    }
                }
                
                system.debug('MSR::complainIdToInvstIdMap...'+complainIdToInvstIdMap);
                if(!complainIdToInvstIdMap.isEmpty())
                {
                    
                    List<CMPL123CME__EU_MIR__c> eumirnewlist=[Select id,CMPL123CME__Complaint__c,CMPL123CME__Type_Of_Report__c from CMPL123CME__EU_MIR__c where id IN:cmptmap.values()];
                    for(CMPL123CME__EU_MIR__c mir:eumirnewlist){
                        if(mir.CMPL123CME__Complaint__c !=null && (mir.CMPL123CME__Type_Of_Report__c == 'Initial'|| mir.CMPL123CME__Type_Of_Report__c=='Follow up')){
                        
                            invstList.add(new CMPL123CME__Investigation__c(Id = complainIdToInvstIdMap.get(mir.CMPL123CME__Complaint__c), EU_MIR__c = mir.Id));
                            
                            eumirList.add(new CMPL123CME__EU_MIR__c(Id = mir.Id, Investigation_Evaluation__c = complainIdToInvstIdMap.get(mir.CMPL123CME__Complaint__c)));
                        }
                    }
                }
            }
            system.debug('MSR::eumirList::'+eumirList);
                if(!eumirList.isEmpty())
                   update eumirList;
                if(!invstList.isEmpty())
                    update invstList;
            
            
        } catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    
    }
    
    Public class EU_mirWrapper
    {
        @InvocableVariable
        public Id Eumirids;
    }
    
    
 }