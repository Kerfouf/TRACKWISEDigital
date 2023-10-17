//trigger EU_MIR_InvestigationUpdate on CMPL123CME__EU_MIR__c (After insert,After update) {  - by Shekar
//trigger EU_MIR_InvestigationUpdate on CMPL123CME__EU_MIR__c (After insert) {

public class EU_MIR_InvestigationUpdate{

//@future
//public static void updateEUMIR(List<Id> eumirIdLists)
public void updateEUMIR(List<CMPL123CME__EU_MIR__c> eumirRecords)
{

//List<CMPL123CME__EU_MIR__c> eumirRecords =[SELECT Id,CMPL123CME__Complaint__c,CMPL123CME__Type_Of_Report__c FROM CMPL123CME__EU_MIR__c WHERE Id IN : eumirIdLists ];

    if(EU_INV_Recursive_Avoid.flag1)
    {
    
    Map<Id,Id> cmptmap= new Map<Id,Id>();
    System.debug('@@@cmptmap'+cmptmap);
    for(CMPL123CME__EU_MIR__c mir: eumirRecords)
    {
        System.debug('@@@mir'+mir);
        if(mir.CMPL123CME__Complaint__c != null && mir.CMPL123CME__Type_Of_Report__c == 'Initial' )
        {
            cmptmap.put(mir.CMPL123CME__Complaint__c, mir.Id);
        }
    }
    
    Map<Id,Id> InvstMap= new Map<Id,Id>();
    
    List<CMPL123CME__Investigation__c> InvestUptlist= new List<CMPL123CME__Investigation__c>();
    System.debug('@@@InvestUptlist'+InvestUptlist);
    List<CMPL123CME__Investigation__c> Investlist =[SELECT Id,CMPL123CME__Complaint__c,EU_MIR__c,CMPL123_WF_Status__c FROM CMPL123CME__Investigation__c WHERE (NOT CMPL123_WF_Status__c like '%Closed%')AND CMPL123CME__Complaint__c IN:cmptmap.keyset()];
    System.debug('@@@Investlist'+Investlist);
    for(CMPL123CME__Investigation__c inv:Investlist)
    {
        System.debug('@@@inv'+inv);
        
        //if(inv.CMPL123_WF_Status__c != 'Closed-Canceled' || inv.CMPL123_WF_Status__c != 'Closed - Done')
        //{
            InvstMap.put(inv.CMPL123CME__Complaint__c,inv.Id);
            
            CMPL123CME__Investigation__c  inst= new CMPL123CME__Investigation__c();
            
            inst.Id=inv.Id;
            inst.EU_MIR__c=cmptmap.get(inv.CMPL123CME__Complaint__c);
            InvestUptlist.add(inst);
        //}
    }
    
    EU_INV_Recursive_Avoid.flag1=false;
    if(!InvestUptlist.isEmpty())
    {
        update InvestUptlist;
    }
    
    List<CMPL123CME__EU_MIR__c> MirUptlist= new List<CMPL123CME__EU_MIR__c>();
        System.debug('@@@MirUptlist'+MirUptlist);
    List<CMPL123CME__EU_MIR__c> MirList=[SELECT id,CMPL123CME__Complaint__c,Investigation_Evaluation__c FROM CMPL123CME__EU_MIR__c WHERE Id IN:cmptmap.values()];
        System.debug('@@@MirList'+MirList);
    for(CMPL123CME__EU_MIR__c eumir: MirList)
    {   
        System.debug('@@@eumir'+eumir);
        CMPL123CME__EU_MIR__c m= new CMPL123CME__EU_MIR__c();
        m.Id=eumir.Id;
        m.Investigation_Evaluation__c = InvstMap.get(eumir.CMPL123CME__Complaint__c);
        MirUptlist.add(m);
    }
    EU_INV_Recursive_Avoid.flag1=false;
    if(!MirUptlist.isEmpty())
    {
        update MirUptlist;
    }
  } 
 }
}