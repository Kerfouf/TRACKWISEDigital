public with sharing class MIRCodeChoiceManagement {
    public static void manageMirCodeChoices(Map<Id, CMPL123CME__Investigation__c>  newTrigeringInvestigations){
        // Create a Collection of the Invest Closed - Done
        Map<Id, CMPL123CME__Investigation__c> mapOfClosedDoneInvestigations = new Map<Id, CMPL123CME__Investigation__c>();
        for(Id loopInvestigationId : newTrigeringInvestigations.keyset()){
            CMPL123CME__Investigation__c loopInvestigation = newTrigeringInvestigations.get(loopInvestigationId);
            
            // Manage only if there is a MIR
            Boolean manageInvest = loopInvestigation.CMPL123_WF_Status__c == 'Closed - Done';
            //Updated by Sekhar MALLI 
            system.debug('MS::::Status:::'+loopInvestigation.EU_MIR__r.CMPL123_WF_Status__c);
            //Boolean manageEumir = loopInvestigation.EU_MIR__r.CMPL123_WF_Status__c!='Closed-Submitted' || loopInvestigation.EU_MIR__r.CMPL123_WF_Status__c!='Closed - Canceled';
            manageInvest = manageInvest && String.isNotBlank(loopInvestigation.EU_MIR__c);
            if(manageInvest){
                mapOfClosedDoneInvestigations.put(loopInvestigationId, loopInvestigation);
            }

        }
        Boolean manageEmr= false;
        List<CMPL123CME__EU_MIR__c> euList=[select id,CMPL123_WF_Status__c,Investigation_Evaluation__c from CMPL123CME__EU_MIR__c where Investigation_Evaluation__c IN:newTrigeringInvestigations.keyset()];
        for(CMPL123CME__EU_MIR__c eu:euList){
            if(eu.CMPL123_WF_Status__c=='Closed-Submitted' || eu.CMPL123_WF_Status__c=='Closed - Canceled' ){
               manageEmr= true; 
            } 
        }
        system.debug('MS::::euList:::euList::'+euList);
        if(mapOfClosedDoneInvestigations.isEmpty() || manageEmr ){
            system.debug('MS::::Status:::Enter1::');
            return;
          
        }
        system.debug('MS::::Status:::Enter2::');
        updateMirs(mapOfClosedDoneInvestigations);
        deleteCodeChoices(mapOfClosedDoneInvestigations);
        createCodeChoices(mapOfClosedDoneInvestigations);

    }

    private static void createCodeChoices(Map<Id, CMPL123CME__Investigation__c> mapOfClosedDoneInvestigations){
        

        // For Lookup fields, extract IDs
        Set<Id> mirCodeIDS = Helper.extractListOfIdsOfAField(mapOfClosedDoneInvestigations.values(), new List<String> {
            'C_Investigation_Findings_Code_Choice1__c',
            'C_Investigation_Findings_Code_Choice2__c',
            'C_Investigation_Findings_Code_Choice3__c',
            'D_Investigation_Conclusion_Choice1__c',
            'D_Investigation_Conclusion_Choice2__c',
            'D_Investigation_Conclusion_Choice3__c',
            'G_Component_Code_Choice_1__c',
            'G_Component_Code_Choice_2__c',
            'G_Component_Code_Choice_3__c'
        });

        // For picklists fields, extract the code
        Set<String> mirCodeNames = extractMIRCodeNamesFromRecords(mapOfClosedDoneInvestigations.values(), new List<String> {
            'B_Investigation_Type_Code_Choice_1__c',
            'B_Investigation_Type_Code_Choice_2__c',
            'B_Investigation_Type_Code_Choice_3__c',
            'B_Investigation_Type_Code_Choice_4__c',
            'B_Investigation_Type_Code_Choice_5__c',
            'B_Investigation_Type_Code_Choice_6__c'
        });
        

        // Build a MAP of Id <=> MIR Code
        Map<Id, CMPL123CME__EU_MIR_Code__c> idToMirCodeMap = new Map<Id, CMPL123CME__EU_MIR_Code__c>([
                                                        SELECT
                                                            id,
                                                            name,
                                                            CMPL123CME__Name_With_Code__c
                                                        FROM
                                                            CMPL123CME__EU_MIR_Code__c
                                                        WHERE
                                                            ID IN :mirCodeIDS
                                                            OR
                                                            Name IN :mirCodeNames
        ]);

        // Build another Map of MIR Code Name <=> MIR Code Record
        Map<String , CMPL123CME__EU_MIR_Code__c> nameToMirCodeMap = extractMirCodeNamesMap(idToMirCodeMap);

        List<CMPL123CME__EU_MIR_Code_Choices__c> codeChoicesToInsert = new List<CMPL123CME__EU_MIR_Code_Choices__c>();
        for(CMPL123CME__Investigation__c loopInvestigation : mapOfClosedDoneInvestigations.values()){
            // Starting by B
            addCodeChoiceToList(loopInvestigation, 'B_Investigation_Type_Code_Choice_1__c', 'B-Investigation Type Code', 1, nameToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'B_Investigation_Type_Code_Choice_2__c', 'B-Investigation Type Code', 2, nameToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'B_Investigation_Type_Code_Choice_3__c', 'B-Investigation Type Code', 3, nameToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'B_Investigation_Type_Code_Choice_4__c', 'B-Investigation Type Code', 4, nameToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'B_Investigation_Type_Code_Choice_5__c', 'B-Investigation Type Code', 5, nameToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'B_Investigation_Type_Code_Choice_6__c', 'B-Investigation Type Code', 6, nameToMirCodeMap, codeChoicesToInsert);
            
            
            // Starting by C
            addCodeChoiceToList(loopInvestigation, 'C_Investigation_Findings_Code_Choice1__c', 'C-Investigation Type Code', 1, idToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'C_Investigation_Findings_Code_Choice2__c', 'C-Investigation Type Code', 2, idToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'C_Investigation_Findings_Code_Choice3__c', 'C-Investigation Type Code', 3, idToMirCodeMap, codeChoicesToInsert);

            
            
            // Starting by a D
            addCodeChoiceToList(loopInvestigation, 'D_Investigation_Conclusion_Choice1__c', 'D-Investigation Type Code', 1, idToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'D_Investigation_Conclusion_Choice2__c', 'D-Investigation Type Code', 2, idToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'D_Investigation_Conclusion_Choice3__c', 'D-Investigation Type Code', 3, idToMirCodeMap, codeChoicesToInsert);
            
            // Starting by G
            addCodeChoiceToList(loopInvestigation, 'G_Component_Code_Choice_1__c', 'G-Component Code', 1, idToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'G_Component_Code_Choice_2__c', 'G-Component Code', 2, idToMirCodeMap, codeChoicesToInsert);
            addCodeChoiceToList(loopInvestigation, 'G_Component_Code_Choice_3__c', 'G-Component Code', 3, idToMirCodeMap, codeChoicesToInsert);
        }
        insert codeChoicesToInsert;
    }

    private static void addCodeChoiceToList(CMPL123CME__Investigation__c investigation, String fieldName , String prefix, Integer choiceNumber, Map<Id, CMPL123CME__EU_MIR_Code__c> mirCodeMap, List<CMPL123CME__EU_MIR_Code_Choices__c> codeChoicesToInsert){
        // Check if field value is null
        Id mirCodeID = (Id) investigation.get(fieldName);
        if(String.isBlank(mirCodeID)){
            return;
        }
        // Extract MIR Code from MIR Code Map
        CMPL123CME__EU_MIR_Code__c mirCode = mirCodeMap.get(mirCodeID);
        CMPL123CME__EU_MIR_Code_Choices__c codeChoice = generateCodeChoice(prefix , choiceNumber , mirCode, investigation.EU_MIR__c);

        codeChoicesToInsert.add(codeChoice);
    }

    private static void addCodeChoiceToList(CMPL123CME__Investigation__c investigation, String fieldName , String prefix, Integer choiceNumber, Map<String, CMPL123CME__EU_MIR_Code__c> mirCodeMap, List<CMPL123CME__EU_MIR_Code_Choices__c> codeChoicesToInsert){
        // Check if field value is null
        String mirCodePicklistValue = (String) investigation.get(fieldName);
        if(String.isBlank(mirCodePicklistValue)){
            return;
        }
        // Extract MIR Code from MIR Code Map
        String mirCodeName = extractMIRCodeNameFromPicklistValue(mirCodePicklistValue);
        CMPL123CME__EU_MIR_Code__c mirCode = mirCodeMap.get(mirCodeName);
        CMPL123CME__EU_MIR_Code_Choices__c codeChoice = generateCodeChoice(prefix , choiceNumber , mirCode, investigation.EU_MIR__c);

        codeChoicesToInsert.add(codeChoice);
    }

    private static CMPL123CME__EU_MIR_Code_Choices__c generateCodeChoice(String prefix , Integer choiceNumber, CMPL123CME__EU_MIR_Code__c mirCode, Id mirId){
        String choice = 'Choice';
        String choiceAsAStringWithSpace = choice + ' ' + choiceNumber;
        String choiceAsAStringWithOutSpace = choice + choiceNumber;
        String Name = prefix + ' - ' + choiceAsAStringWithOutSpace + ' - ' + mirCode.Name;

        CMPL123CME__EU_MIR_Code_Choices__c codeChoiceToReturn = new CMPL123CME__EU_MIR_Code_Choices__c();
        codeChoiceToReturn.Name = Name;
        codeChoiceToReturn.CMPL123CME__Choice__c = choiceAsAStringWithSpace;
        codeChoiceToReturn.CMPL123CME__Related_EU_MIR_Code__c = mirCode.Id;
        codeChoiceToReturn.CMPL123CME__Related_EU_MIR__c = mirId;
        
        return codeChoiceToReturn;
    }



    private static void deleteCodeChoices(Map<Id, CMPL123CME__Investigation__c> mapOfClosedDoneInvestigations){
        Set<Id> idOfMirs = Helper.extractListOfIdsOfAField(mapOfClosedDoneInvestigations.values() , 'EU_MIR__c');
        List<CMPL123CME__EU_MIR_Code_Choices__c> codeChoicesToDelete = [SELECT
                                                                            Id
                                                                        FROM
                                                                            CMPL123CME__EU_MIR_Code_Choices__c
                                                                        WHERE
                                                                            (Name LIKE '%B-Investigation %' OR Name LIKE '%C-Investigation %' OR Name LIKE '%D-Investigation %' OR Name LIKE '%G-Component %')
                                                                            AND
                                                                            CMPL123CME__Related_EU_MIR__c IN :idOfMirs
        ];
        delete codeChoicesToDelete;
    }



    private static void updateMirs(Map<Id, CMPL123CME__Investigation__c> mapOfClosedDoneInvestigations){
        Set<Id> idOfMirs = Helper.extractListOfIdsOfAField(mapOfClosedDoneInvestigations.values() , 'EU_MIR__c');
        Map<Id, CMPL123CME__EU_MIR__c> mirMap = new Map<Id, CMPL123CME__EU_MIR__c>([
                                                SELECT
                                                    Id,
                                                    CMPL123CME__Explain_If_Investigation_Code_Missing__c,
                                                    CMPL123CME__Manufacturer_s_Evaluation__c
                                                FROM
                                                    CMPL123CME__EU_MIR__c
                                                WHERE
                                                    Id IN :idOfMirs
        ]);
        
        for(CMPL123CME__Investigation__c loopInvest : mapOfClosedDoneInvestigations.values()){
            CMPL123CME__EU_MIR__c loopMIR = mirMap.get(loopInvest.EU_MIR__c);
            loopMIR.CMPL123CME__Explain_If_Investigation_Code_Missing__c = concatValues(loopInvest, new List<String> {'Justification_for_Annex_B__c','Justification_for_Annex_C__c', 'Justification_for_Annex_D__c'});
            loopMIR.CMPL123CME__Manufacturer_s_Evaluation__c = loopInvest.BMX_Investigation_Answer__c;
            loopMIR.CMPL123CME__Explain_If_Component_Code_Missing__c = loopInvest.Justification_for_Annex_G__c;
        }
        update mirMap.values();

    }

    private static String concatValues(SOBject objectToGetValueIn, List<String> fieldNamesList){
        String stringToReturn = '';
        Iterator<String> fieldNamesListIterator= fieldNamesList.iterator();
        while(fieldNamesListIterator.hasNext()){
            String loopFieldName = fieldNamesListIterator.next();
            String fieldValue = (String) objectToGetValueIn.get(loopFieldName);

            Boolean appendASlash = String.isNotBlank(stringToReturn);
            Boolean valueIsNotBlank = String.isNotBlank(fieldValue);
            appendASlash = appendASlash && valueIsNotBlank;
            if(appendASlash){
                stringToReturn += ' / ';
            }
            if(valueIsNotBlank){
                stringToReturn += fieldValue;
            }
        }
        
        return stringToReturn;
    }

    private static Set<String> extractMIRCodeNamesFromRecords(List<CMPL123CME__Investigation__c> investigations, List<String> fieldsNamesToExtractCodeNames){
        Set<String> mirCodeNames = new Set<String>();
        for(CMPL123CME__Investigation__c loopInvestigation : investigations){
            for(String fieldName : fieldsNamesToExtractCodeNames){
                String fieldValue = (String)loopInvestigation.get(fieldName);
                if(String.isNotBlank(fieldValue)){
                    String mirCodeName = extractMIRCodeNameFromPicklistValue(fieldValue);
                    mirCodeNames.add(mirCodeName);
                }
            }
        }
        return mirCodeNames;
    }

    private static Map<String , CMPL123CME__EU_MIR_Code__c> extractMirCodeNamesMap(Map<Id, CMPL123CME__EU_MIR_Code__c> idToMirCodeMap){
        Map<String , CMPL123CME__EU_MIR_Code__c> mapToReturn = new Map<String , CMPL123CME__EU_MIR_Code__c>();
        for(CMPL123CME__EU_MIR_Code__c loopMIRCode : idToMirCodeMap.values()){
            mapToReturn.put(loopMIRCode.Name, loopMIRCode);
        }
        return mapToReturn;
    }

    private static String extractMIRCodeNameFromPicklistValue(String picklistValue){
        return picklistValue.substring(0, 4).trim();
    }
}