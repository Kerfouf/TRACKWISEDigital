public class AssessmentTriggerHandler {
    public static void handle(List<CMPL123CME__Questionnaire__c> assessments) {
        List<Id> eurMirCodeIds = new List<Id>();
        for (CMPL123CME__Questionnaire__c assessment : assessments) {
            if (!eurMirCodeIds.contains(assessment.F_Health_Impact_Choice_1__c)) {
             	eurMirCodeIds.add(assessment.F_Health_Impact_Choice_1__c);   
            }
            if (!eurMirCodeIds.contains(assessment.F_Health_Impact_Choice_2__c)) {
             	eurMirCodeIds.add(assessment.F_Health_Impact_Choice_2__c);   
            }
        }
        Map<Id, CMPL123CME__EU_MIR_Code__c> roleMap = new Map<Id, CMPL123CME__EU_MIR_Code__c>();
        for (CMPL123CME__EU_MIR_Code__c euMirCode : [Select id, name, CMPL123CME__Inactive__c from CMPL123CME__EU_MIR_Code__c where id in :eurMirCodeIds]) {
            roleMap.put(euMirCode.id, euMirCode);   
        }
        for (CMPL123CME__Questionnaire__c assessment : assessments) {
            if (assessment.F_Health_Impact_Choice_1__c != null && (roleMap.get(assessment.F_Health_Impact_Choice_1__c).CMPL123CME__Inactive__c || !roleMap.get(assessment.F_Health_Impact_Choice_1__c).Name.startsWith('F'))) {
                assessment.addError('The F Health Impact Choice 1 must be related to an activate EU MIRE Code which starts with F');
            }
            if (assessment.F_Health_Impact_Choice_2__c != null && (roleMap.get(assessment.F_Health_Impact_Choice_2__c).CMPL123CME__Inactive__c || !roleMap.get(assessment.F_Health_Impact_Choice_2__c).Name.startsWith('F'))) {
                assessment.addError('The F Health Impact Choice 2 must be related to an activate EU MIRE Code which starts with F');
            }
        } 
    }
}