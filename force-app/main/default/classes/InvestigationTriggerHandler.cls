public class InvestigationTriggerHandler { 
    
    Public static void InvestiToEumirupdate(list<CMPL123CME__Investigation__c> myinvestlist)
    {
         try 
         {
         
            Map<Id, Id> investcmpltmap = new Map<Id, Id>();
            List<CMPL123CME__EU_MIR__c> updtEMRlist= new List<CMPL123CME__EU_MIR__c>();
            Map<Id, CMPL123CME__EU_MIR__c> complainIdToInvstIdMap = new Map<Id, CMPL123CME__EU_MIR__c>();
            
            for(CMPL123CME__Investigation__c inv:myinvestlist){
               if(inv.CMPL123CME__Complaint__c !=null && inv.EU_MIR__c==null){
                  investcmpltmap.put(inv.CMPL123CME__Complaint__c,inv.Id);
               }
            }
            System.debug('Map values ::' +investcmpltmap); 
            if(!investcmpltmap.isEmpty())
            {
                
                List<CMPL123CME__EU_MIR__c> EMIRList=[SELECT Id,CMPL123CME__Complaint__c,CMPL123_WF_Status__c,Investigation_Evaluation__c from CMPL123CME__EU_MIR__c WHERE (CMPL123_WF_Status__c like '%Opened%') AND Investigation_Evaluation__c=null AND CMPL123CME__Complaint__c In:investcmpltmap.keyset()];
                System.debug('EMIRList::MR::'+EMIRList);        
                for(CMPL123CME__EU_MIR__c Mir:EMIRList)
                {
                    complainIdToInvstIdMap.put(Mir.CMPL123CME__Complaint__c,Mir);
                    CMPL123CME__EU_MIR__c em= new CMPL123CME__EU_MIR__c();
                    em.Id=Mir.Id;
                    em.Investigation_Evaluation__c=investcmpltmap.get(mir.CMPL123CME__Complaint__c);
                    updtEMRlist.add(em);  
                }
            }
                
            if(!updtEMRlist.isempty()){
                update updtEMRlist;
            }
        
            if(!complainIdToInvstIdMap.isEmpty())
            {
            
                List<CMPL123CME__Investigation__c> updtinv= new List<CMPL123CME__Investigation__c>();
                List<CMPL123CME__Investigation__c> invstList=[SELECT Id,EU_MIR__c,CMPL123CME__Complaint__c from CMPL123CME__Investigation__c where id IN:investcmpltmap.values()];
                
                for(CMPL123CME__Investigation__c inv:invstList)
                {
                    CMPL123CME__Investigation__c i= new CMPL123CME__Investigation__c();
                    i.Id=inv.Id;
                    i.EU_MIR__c=complainIdToInvstIdMap.get(inv.CMPL123CME__Complaint__c).Id;
                    updtinv.add(i);
            
                }
            
                if(!updtinv.isEmpty())
                {
                    update updtinv;
                }
                
            }
        }
        catch(Exception e)
        {
            System.debug('Error from ApexController Method::' + e.getMessage());
        }  
    
    }

}