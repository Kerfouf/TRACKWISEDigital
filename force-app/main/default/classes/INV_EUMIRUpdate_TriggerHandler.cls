//trigger Investigation_Eu_Mirupdate on CMPL123CME__Investigation__c (after update) - by Shekar 

public class INV_EUMIRUpdate_TriggerHandler{

@future
//public void updateINVEUMIR(Map<Id,CMPL123CME__Investigation__c> oldMap, Map<Id,CMPL123CME__Investigation__c> newMap)
//public void updateINVEUMIR(List<CMPL123CME__Investigation__c> invList)
public static void updateINVEUMIR(List<Id> invIdList)
{
    List<CMPL123CME__EU_MIR__c> EUMIRListupdt= new List<CMPL123CME__EU_MIR__c>();
    map<Id,CMPL123CME__Investigation__c> Inv_Code_Choice_1Map= new map<Id,CMPL123CME__Investigation__c>();
    map<Id,CMPL123CME__Investigation__c> MIRInvestmap= new map<Id,CMPL123CME__Investigation__c>();
    List<Id> MIRId= new List<Id>();
    LIst<string> choice_code= new List<String>();
    map<Id,string> choicecodemap= new map<Id,string>();

    List<CMPL123CME__Investigation__c> invrecords = [SELECT id,CMPL123_WF_Status__c,EU_MIR__c,BMX_Investigation_Answer__c,Justification_for_Annex_B__c,Justification_for_Annex_C__c,Justification_for_Annex_D__c,B_Investigation_Type_Code_Choice_1__c,B_Investigation_Type_Code_Choice_2__c,B_Investigation_Type_Code_Choice_3__c,B_Investigation_Type_Code_Choice_4__c,B_Investigation_Type_Code_Choice_5__c,B_Investigation_Type_Code_Choice_6__c,C_Investigation_Findings_Code_Choice1__c,C_Investigation_Findings_Code_Choice2__c,C_Investigation_Findings_Code_Choice3__c,D_Investigation_Conclusion_Choice1__c,D_Investigation_Conclusion_Choice2__c,D_Investigation_Conclusion_Choice3__c FROM CMPL123CME__Investigation__c WHERE Id IN : invIdList ];
  //for(CMPL123CME__Investigation__c inv:newMap.values())    
  //for(CMPL123CME__Investigation__c inv:Trigger.new) - by Shekar 
    for(CMPL123CME__Investigation__c inv : invrecords )   
    {
        //if(oldmap.get(inv.Id).CMPL123_WF_Status__c != newMap.get(inv.Id).CMPL123_WF_Status__c && inv.CMPL123_WF_Status__c  == 'Closed - Done'){   
        //if(trigger.oldmap.get(inv.Id).CMPL123_WF_Status__c != inv.CMPL123_WF_Status__c && inv.CMPL123_WF_Status__c  == 'Closed - Done'){  - by Shekar 
      if(inv.CMPL123_WF_Status__c  == 'Closed - Done' && (inv.EU_MIR__r.CMPL123_WF_Status__c!='Closed - Done'||inv.EU_MIR__r.CMPL123_WF_Status__c!='Closed - Canceled'))
      {           
            //if((inv.Justification_for_Annex_B__c!=null && inv.Justification_for_Annex_B__c!='') || (inv.Justification_for_Annex_C__c!=null && inv.Justification_for_Annex_C__c!='') || (inv.Justification_for_Annex_D__c!=null && inv.Justification_for_Annex_D__c!='')  ) update by Shiva
            //if(inv.Justification_for_Annex_B__c!=''|| inv.Justification_for_Annex_C__c!='' || inv.Justification_for_Annex_D__c!='') 
            if(String.isNotBlank(inv.Justification_for_Annex_B__c) || String.isNotBlank(inv.Justification_for_Annex_C__c) || String.isNotBlank(inv.Justification_for_Annex_D__c))
            {            
                MIRInvestmap.put(inv.EU_MIR__c,inv);
            }
            MIRId.add(inv.EU_MIR__c);
            if(inv.B_Investigation_Type_Code_Choice_1__c!=null && inv.B_Investigation_Type_Code_Choice_1__c!='')
            {
                choice_code.add('Choice 1' + inv.B_Investigation_Type_Code_Choice_1__c);
            }
            
            if(inv.B_Investigation_Type_Code_Choice_2__c!=null && inv.B_Investigation_Type_Code_Choice_2__c!='')
            {
                choice_code.add('Choice 2' + inv.B_Investigation_Type_Code_Choice_2__c);
            }
            
            if(inv.B_Investigation_Type_Code_Choice_3__c!=null && inv.B_Investigation_Type_Code_Choice_3__c!='')
            {
                choice_code.add('Choice 3' +inv.B_Investigation_Type_Code_Choice_3__c);
            }
            
            if(inv.B_Investigation_Type_Code_Choice_4__c!=null && inv.B_Investigation_Type_Code_Choice_4__c!='')
            {
                choice_code.add('Choice 4' +inv.B_Investigation_Type_Code_Choice_4__c);
            }
            
            if(inv.B_Investigation_Type_Code_Choice_5__c!=null && inv.B_Investigation_Type_Code_Choice_5__c!='')
            {
                choice_code.add('Choice 5' +inv.B_Investigation_Type_Code_Choice_5__c);
            }
            if(inv.B_Investigation_Type_Code_Choice_6__c!=null && inv.B_Investigation_Type_Code_Choice_6__c!='')
            {
                choice_code.add('Choice 6' +inv.B_Investigation_Type_Code_Choice_6__c);
            }
            
            if(inv.C_Investigation_Findings_Code_Choice1__c!=null )
            {
                choicecodemap.put(inv.C_Investigation_Findings_Code_Choice1__c,'choice 1');
                
            }
            
            if(inv.C_Investigation_Findings_Code_Choice2__c!=null )
            {
                choicecodemap.put(inv.C_Investigation_Findings_Code_Choice2__c,'choice 2');
            }
            
            if(inv.C_Investigation_Findings_Code_Choice3__c!=null)
            {
                choicecodemap.put(inv.C_Investigation_Findings_Code_Choice3__c,'choice 3');
            }
            
            if(inv.D_Investigation_Conclusion_Choice1__c!=null)
            {
                choicecodemap.put(inv.D_Investigation_Conclusion_Choice1__c,'choice 1');
            }
            
            if(inv.D_Investigation_Conclusion_Choice2__c!=null)
            {
                choicecodemap.put(inv.D_Investigation_Conclusion_Choice2__c,'choice 2');
            }
            
            if(inv.D_Investigation_Conclusion_Choice3__c!=null)
            {
                choicecodemap.put(inv.D_Investigation_Conclusion_Choice3__c,'choice 3');
            }
        }
    }
    
    List<CMPL123CME__EU_MIR__c> EMIRlistupdt= new List<CMPL123CME__EU_MIR__c>();
        if(!MIRInvestmap.isEmpty())
        {
            List<CMPL123CME__EU_MIR__c> EMIRlist=[select id,CMPL123CME__Explain_If_Investigation_Code_Missing__c,CMPL123CME__Manufacturer_s_Evaluation__c from CMPL123CME__EU_MIR__c where Id IN:MIRInvestmap.keyset()];
            for(CMPL123CME__EU_MIR__c emr: EMIRlist)
            {
                CMPL123CME__EU_MIR__c mr= new CMPL123CME__EU_MIR__c();
                mr.Id=emr.Id;
               // mr.CMPL123CME__Explain_If_Investigation_Code_Missing__c= MIRInvestmap.get(emr.Id).Justification_for_Annex_B__c+MIRInvestmap.get(emr.Id).Justification_for_Annex_C__c+MIRInvestmap.get(emr.Id).Justification_for_Annex_D__c;
                mr.CMPL123CME__Explain_If_Investigation_Code_Missing__c= ((MIRInvestmap.get(emr.Id).Justification_for_Annex_B__c==null)?'':MIRInvestmap.get(emr.Id).Justification_for_Annex_B__c)+' '+'/'+' '+((MIRInvestmap.get(emr.Id).Justification_for_Annex_C__c==null)?'':MIRInvestmap.get(emr.Id).Justification_for_Annex_C__c)+' '+'/'+' '+((MIRInvestmap.get(emr.Id).Justification_for_Annex_D__c==null)?'':MIRInvestmap.get(emr.Id).Justification_for_Annex_D__c);
                mr.CMPL123CME__Manufacturer_s_Evaluation__c=MIRInvestmap.get(emr.Id).BMX_Investigation_Answer__c;
                EMIRlistupdt.add(mr);
            }
        }
        set<CMPL123CME__EU_MIR__c> removenull = new set<CMPL123CME__EU_MIR__c>(EMIRlistupdt);
        EMIRlistupdt=new list<CMPL123CME__EU_MIR__c>(removenull);
        if(!EMIRlistupdt.isEmpty() && EMIRlistupdt.size()>0)
        {
            update EMIRlistupdt;
        }
    
    // Delete Existing Code choice
    List<CMPL123CME__EU_MIR_Code_Choices__c> ChoiceCodedelete1=[SELECT Id,Name,CMPL123CME__Related_EU_MIR__c from CMPL123CME__EU_MIR_Code_Choices__c WHERE Name like '%B-Investigation %' and CMPL123CME__Related_EU_MIR__c IN:MIRId];
    
    List<CMPL123CME__EU_MIR_Code_Choices__c> ChoiceCodedelete2=[SELECT Id,Name,CMPL123CME__Related_EU_MIR__c from CMPL123CME__EU_MIR_Code_Choices__c WHERE Name like '%C-Investigation %' and CMPL123CME__Related_EU_MIR__c IN:MIRId];
    
    List<CMPL123CME__EU_MIR_Code_Choices__c> ChoiceCodedelete3=[SELECT Id,Name,CMPL123CME__Related_EU_MIR__c from CMPL123CME__EU_MIR_Code_Choices__c WHERE Name like '%D-Investigation %' and CMPL123CME__Related_EU_MIR__c IN:MIRId];
    
    if(!ChoiceCodedelete1.isEmpty())
    {
        delete ChoiceCodedelete1;
    }
    
    if(!ChoiceCodedelete2.isEmpty())
    {
        Delete ChoiceCodedelete2;
    }
    
    if(!ChoiceCodedelete3.isEmpty())
    {
        Delete ChoiceCodedelete3;
    }
    // End Deletion
    
    List<CMPL123CME__EU_MIR_Code_Choices__c> cdchoicelist= new List<CMPL123CME__EU_MIR_Code_Choices__c>();
    if(!choice_code.isEmpty())
    {
        for(string str:choice_code)
        {
            string Chcode=str.substring(8,12).trim();
            system.debug('MS::Chcode::'+Chcode);
            List<CMPL123CME__EU_MIR_Code__c> codelist=[select id,name,CMPL123CME__Name_With_Code__c from CMPL123CME__EU_MIR_Code__c where name=:Chcode];      
            system.debug('MS::codelist::'+codelist);
            for(CMPL123CME__EU_MIR_Code__c cd:codelist)
            {
                CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                cdchoice.Name='B-Investigation Type Code'+' '+'-'+' '+str.substring(0,8)+' '+'-'+' '+cd.name;
                cdchoice.CMPL123CME__Choice__c=str.substring(0,8);
                cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                cdchoice.CMPL123CME__Related_EU_MIR__c=MIRId[0];
                cdchoicelist.add(cdchoice);
            }
        }
    }
    If(!choicecodemap.isEmpty())
    {
        List<CMPL123CME__EU_MIR_Code__c> codelist=[select id,name,CMPL123CME__Name_With_Code__c from CMPL123CME__EU_MIR_Code__c where ID IN:choicecodemap.keyset()];      
        
        for(CMPL123CME__EU_MIR_Code__c cd:codelist)
        {
            if(cd.Name.startsWith('C'))
            {           
                CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                cdchoice.Name='C-Investigation Type Code'+' '+'-'+' '+choicecodemap.get(cd.Id)+' '+'-'+' '+cd.name;
                cdchoice.CMPL123CME__Choice__c=choicecodemap.get(cd.Id);
                cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                cdchoice.CMPL123CME__Related_EU_MIR__c=MIRId[0];
                cdchoicelist.add(cdchoice);
            }
            else
            {
                CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                cdchoice.Name='D-Investigation Type Code'+' '+'-'+' '+choicecodemap.get(cd.Id)+' '+'-'+' '+cd.name;
                cdchoice.CMPL123CME__Choice__c=choicecodemap.get(cd.Id);
                cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                cdchoice.CMPL123CME__Related_EU_MIR__c=MIRId[0];
                cdchoicelist.add(cdchoice);
            }
        }
    
    }
    system.debug('MS::cdchoicelist::'+cdchoicelist);
    if(!cdchoicelist.isEmpty())
    {
        insert cdchoicelist;
    }
 }
 
}