public with sharing class BatchInvestChildupdate  {

    
    public static void execute(List<Investchildupdate.InvestWrapper>  InvestList){
        try{
            map<Id,CMPL123CME__Investigation__c> MIRInvestmap= new map<Id,CMPL123CME__Investigation__c>();
            List<Id> MIRId= new List<Id>();
            LIst<string> choice_code= new List<String>();
            map<Id,string> choicecodemap= new map<Id,string>();
            
            List<CMPL123CME__Investigation__c> Childinvrecords = [SELECT id,CMPL123_WF_Status__c,EU_MIR__c,BMX_Investigation_Answer__c,Justification_for_Annex_B__c,Justification_for_Annex_C__c,Justification_for_Annex_D__c,Justification_for_Annex_G__c,B_Investigation_Type_Code_Choice_1__c,B_Investigation_Type_Code_Choice_2__c,B_Investigation_Type_Code_Choice_3__c,B_Investigation_Type_Code_Choice_4__c,B_Investigation_Type_Code_Choice_5__c,B_Investigation_Type_Code_Choice_6__c,C_Investigation_Findings_Code_Choice1__c,C_Investigation_Findings_Code_Choice2__c,C_Investigation_Findings_Code_Choice3__c,D_Investigation_Conclusion_Choice1__c,D_Investigation_Conclusion_Choice2__c,D_Investigation_Conclusion_Choice3__c,G_Component_Code_Choice_1__c,G_Component_Code_Choice_2__c,G_Component_Code_Choice_3__c FROM CMPL123CME__Investigation__c WHERE Master_Investigation__c=:InvestList[0].ParentId];
            for(CMPL123CME__Investigation__c chinvst:Childinvrecords)
            {
                if(String.isNotBlank(chinvst.Justification_for_Annex_B__c) || String.isNotBlank(chinvst.Justification_for_Annex_C__c) || String.isNotBlank(chinvst.Justification_for_Annex_D__c) || String.isNotBlank(chinvst.Justification_for_Annex_G__c) )
                {            
                    MIRInvestmap.put(chinvst.EU_MIR__c,chinvst);
                }
                MIRId.add(chinvst.EU_MIR__c);
            }
            List<CMPL123CME__Investigation__c> invrecords = [SELECT
                                                                id,
                                                                CMPL123_WF_Status__c,
                                                                EU_MIR__c,BMX_Investigation_Answer__c,
                                                                Justification_for_Annex_B__c,
                                                                Justification_for_Annex_C__c,
                                                                Justification_for_Annex_D__c,
                                                                Justification_for_Annex_G__c,
                                                                B_Investigation_Type_Code_Choice_1__c,
                                                                B_Investigation_Type_Code_Choice_2__c,
                                                                B_Investigation_Type_Code_Choice_3__c,
                                                                B_Investigation_Type_Code_Choice_4__c,
                                                                B_Investigation_Type_Code_Choice_5__c,
                                                                B_Investigation_Type_Code_Choice_6__c,
                                                                C_Investigation_Findings_Code_Choice1__c,
                                                                C_Investigation_Findings_Code_Choice2__c,
                                                                C_Investigation_Findings_Code_Choice3__c,
                                                                D_Investigation_Conclusion_Choice1__c,
                                                                D_Investigation_Conclusion_Choice2__c,
                                                                D_Investigation_Conclusion_Choice3__c,
                                                                G_Component_Code_Choice_1__c,
                                                                G_Component_Code_Choice_2__c,
                                                                G_Component_Code_Choice_3__c 
                                                            FROM
                                                                CMPL123CME__Investigation__c
                                                            WHERE
                                                                Id =:InvestList[0].ParentId
                                                                AND
                                                                Master_Investigation__c=null
            ];
            system.debug('MS::cdchoicelist::'+Childinvrecords);
            system.debug('MS::cdchoicelist::'+invrecords);
            for(CMPL123CME__Investigation__c inv : invrecords )   
            {
            
                if(inv.CMPL123_WF_Status__c  == 'Closed - Done')
                {           
                    if(String.isNotBlank(inv.Justification_for_Annex_B__c) || String.isNotBlank(inv.Justification_for_Annex_C__c) || String.isNotBlank(inv.Justification_for_Annex_D__c) || String.isNotBlank(inv.Justification_for_Annex_G__c))
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
                    
                    if(inv.G_Component_Code_Choice_1__c!=null)
                    {
                        choicecodemap.put(inv.G_Component_Code_Choice_1__c,'choice 1');
                    }
                    
                    if(inv.G_Component_Code_Choice_2__c!=null)
                    {
                        choicecodemap.put(inv.G_Component_Code_Choice_2__c,'choice 2');
                    }
                    
                    if(inv.G_Component_Code_Choice_3__c!=null)
                    {
                        choicecodemap.put(inv.G_Component_Code_Choice_3__c,'choice 3');
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
                    mr.CMPL123CME__Explain_If_Component_Code_Missing__c=((MIRInvestmap.get(emr.Id).Justification_for_Annex_G__c==null)?'':MIRInvestmap.get(emr.Id).Justification_for_Annex_G__c);
                    EMIRlistupdt.add(mr);
                }
            }
            
            system.debug('MIRInvestmap::MSR...'+MIRInvestmap.size());
            system.debug('MIRInvestmapGValue::MSR...'+MIRInvestmap);
            system.debug('EU MIR List...'+EMIRlistupdt.size());
            system.debug('EUMIRListofRecords...'+EMIRlistupdt);
            if(!EMIRlistupdt.isEmpty() && EMIRlistupdt.size()>0)
            {
                update EMIRlistupdt;/*
                List<List<SOBject>> splitedList = splitList(EMIRlistupdt);
                for(List<SOBject> loopList : splitedList){
                    BatchableDml job = new BatchableDml(loopList , DML_METHOD.M_UPDATE);
                    System.enqueueJob(job);
                }*/
            }
                
            // Delete Existing Code choice
            List<CMPL123CME__EU_MIR_Code_Choices__c> ChoiceCodedelete = [SELECT
                                                                            Id
                                                                        FROM
                                                                            CMPL123CME__EU_MIR_Code_Choices__c
                                                                        WHERE
                                                                            (Name LIKE '%B-Investigation %' OR Name LIKE '%C-Investigation %' OR Name LIKE '%D-Investigation %' OR Name LIKE '%G-Component %')
                                                                            AND
                                                                            CMPL123CME__Related_EU_MIR__c IN:MIRId
            ];
                        
            System.debug('MS::ChoiceCodedelete::'+ChoiceCodedelete.size());
            
            if(!ChoiceCodedelete.isEmpty())
            {
                delete ChoiceCodedelete;
                //List<List<SOBject>> splitedList = splitList(ChoiceCodedelete);
                //for(List<SOBject> loopList : splitedList){
                //    BatchableDml job = new BatchableDml(loopList , DML_METHOD.M_DELETE);
                //    System.enqueueJob(job);
                //}
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
                    system.debug('MS::codelist@@'+codelist);
                    for(CMPL123CME__EU_MIR_Code__c cd:codelist)
                    {
                        for(Id emrids:MIRId)
                        {
                            CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                            cdchoice.Name='B-Investigation Type Code'+' '+'-'+' '+str.substring(0,8)+' '+'-'+' '+cd.name;
                            cdchoice.CMPL123CME__Choice__c=str.substring(0,8);
                            cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                            cdchoice.CMPL123CME__Related_EU_MIR__c=emrids;
                            cdchoicelist.add(cdchoice);
                        }
                    }
                }
            }
            If(!choicecodemap.isEmpty())
            {
                List<CMPL123CME__EU_MIR_Code__c> codelist=[select id,name,CMPL123CME__Name_With_Code__c from CMPL123CME__EU_MIR_Code__c where ID IN:choicecodemap.keyset()];      
                system.debug('EUMIR::CodesMSR@@@@'+codelist);
                for(CMPL123CME__EU_MIR_Code__c cd:codelist)
                {
                    if(cd.Name.startsWith('C'))
                    {     
                        for(Id emrids:MIRId)
                        {                         
                            CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                            cdchoice.Name='C-Investigation Type Code'+' '+'-'+' '+choicecodemap.get(cd.Id)+' '+'-'+' '+cd.name;
                            cdchoice.CMPL123CME__Choice__c=choicecodemap.get(cd.Id);
                            cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                            cdchoice.CMPL123CME__Related_EU_MIR__c=emrids;
                            cdchoicelist.add(cdchoice);
                        }
                    }
                    
                    if(cd.Name.startsWith('D'))
                    {
                        for(Id emrids:MIRId)
                        {
                            CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                            cdchoice.Name='D-Investigation Type Code'+' '+'-'+' '+choicecodemap.get(cd.Id)+' '+'-'+' '+cd.name;
                            cdchoice.CMPL123CME__Choice__c=choicecodemap.get(cd.Id);
                            cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                            cdchoice.CMPL123CME__Related_EU_MIR__c=emrids;
                            cdchoicelist.add(cdchoice);
                        }
                    }  
                    
                    if(cd.Name.startsWith('G')){
                    
                        for(Id emrids:MIRId){
                            
                            CMPL123CME__EU_MIR_Code_Choices__c cdchoice= new CMPL123CME__EU_MIR_Code_Choices__c();
                            cdchoice.Name='G-Component Code'+' '+'-'+' '+choicecodemap.get(cd.Id)+' '+'-'+' '+cd.name;
                            cdchoice.CMPL123CME__Choice__c=choicecodemap.get(cd.Id);
                            cdchoice.CMPL123CME__Related_EU_MIR_Code__c=cd.Id;
                            cdchoice.CMPL123CME__Related_EU_MIR__c=emrids;
                            cdchoicelist.add(cdchoice);
                            
                        }
                        
                    }
                    
                }
            
            }
            system.debug('MS::cdchoicelist::'+cdchoicelist);
            if(!cdchoicelist.isEmpty())
            {
                insert cdchoicelist;
                /*
                List<List<SOBject>> splitedList = splitList(cdchoicelist);
                for(List<SOBject> loopList : splitedList){
                    BatchableDml job = new BatchableDml(loopList , DML_METHOD.M_INSERT);
                    System.enqueueJob(job);
                }*/
            }

        }
       catch(DmlException  e){
           System.debug('Closed EMIR Records Connot be Updated : ' + e.getMessage());
       }
    }    
}