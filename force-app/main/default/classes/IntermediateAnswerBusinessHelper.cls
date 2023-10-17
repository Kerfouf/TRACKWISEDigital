public class IntermediateAnswerBusinessHelper {
    public static void handle(List<Intermediate_Answer__c> answers, Map<Id, Intermediate_Answer__c> oldMap)
    {
        List<CMPL123CME__Investigation__c> investigationList = new List<CMPL123CME__Investigation__c>();
        List<Id> investigationIds = new List<Id>();
        for (Intermediate_Answer__c answer : answers) {
            investigationIds.add(answer.Related_Investigation__c);
            CMPL123CME__Investigation__c investigation = new CMPL123CME__Investigation__c();
            investigation.Id = answer.Related_Investigation__c;
            investigation.Intermediate_Answer_Value__c = answer.Intermediate_Answer__c;
            investigationList.add(investigation);
        }
        update investigationList;
        
        List<Intermediate_Answer__c> newAnswers = new List<Intermediate_Answer__c>();
        for (CMPL123CME__Investigation__c childInvest : [Select id, Master_Investigation__c from CMPL123CME__Investigation__c where Master_Investigation__c != null and Master_Investigation__c in :investigationIds]) {
            for (Intermediate_Answer__c answer : answers) {
                if (childInvest.Master_Investigation__c == answer.Related_Investigation__c) {
                    Intermediate_Answer__c childAnswer = new Intermediate_Answer__c();
                    childAnswer.CurrencyIsoCode = answer.CurrencyIsoCode;
                    childAnswer.Intermediate_Answer__c = answer.Intermediate_Answer__c;
                    childAnswer.CMPL123Rule_Key_Value__c = answer.CMPL123Rule_Key_Value__c;
                    childAnswer.Related_Investigation__c = childInvest.id;
                    newAnswers.add(childAnswer);
                }
            }
        }
        
        insert newAnswers;        
    }
    
    public static void afterUpdate(List<Intermediate_Answer__c> answers, Map<Id, Intermediate_Answer__c> oldMap){
        List<CMPL123CME__Investigation__c> investigationList = new List<CMPL123CME__Investigation__c>();
        List<Id> investigationIds = new List<Id>();
        for (Intermediate_Answer__c answer : answers) {
            if(answer.Intermediate_Answer__c != oldMap.get(answer.Id).Intermediate_Answer__c){
                CMPL123CME__Investigation__c investigation = new CMPL123CME__Investigation__c();
                investigation.Id = answer.Related_Investigation__c;
                investigation.Intermediate_Answer_Value__c = answer.Intermediate_Answer__c;
                investigationList.add(investigation);      
            }
        }
        update investigationList;
    }
}