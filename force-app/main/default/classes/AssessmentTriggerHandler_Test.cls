@isTest
public class AssessmentTriggerHandler_Test {
	@isTest
    public static void test_handle(){
		CMPL123CME__EU_MIR_Code__c euMirCodeWithF = new CMPL123CME__EU_MIR_Code__c(Name = 'F Code');
        CMPL123CME__EU_MIR_Code__c euMirCodeWithNoF = new CMPL123CME__EU_MIR_Code__c(Name = 'H Code');
        List<CMPL123CME__EU_MIR_Code__c> euMirList = new List<CMPL123CME__EU_MIR_Code__c>();
        euMirList.add(euMirCodeWithF);
        euMirList.add(euMirCodeWithNoF);
        insert euMirList;
        Test.startTest();
		
        CMPL123CME__Questionnaire__c toBeInsertedAssessment = new CMPL123CME__Questionnaire__c();
        euMirCodeWithF = [SELECT id from CMPL123CME__EU_MIR_Code__c where name = 'F Code'];
        toBeInsertedAssessment.F_Health_Impact_Choice_1__c = euMirCodeWithF.id;
        toBeInsertedAssessment.F_Health_Impact_Choice_2__c = euMirCodeWithF.id;
        
        CMPL123CME__Questionnaire__c toNotBeInsertedAssessment = new CMPL123CME__Questionnaire__c();
        euMirCodeWithNoF = [SELECT id from CMPL123CME__EU_MIR_Code__c where name = 'H Code'];
        toNotBeInsertedAssessment.F_Health_Impact_Choice_1__c = euMirCodeWithNoF.id;
        toNotBeInsertedAssessment.F_Health_Impact_Choice_2__c = euMirCodeWithF.id;
        
        List<CMPL123CME__Questionnaire__c> assessments = new List<CMPL123CME__Questionnaire__c>();
      	assessments.add(toBeInsertedAssessment);
        assessments.add(toNotBeInsertedAssessment);

        try {
			insert assessments;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            Boolean expectedExceptionThrown = e.getMessage().contains('The F Health Impact Choice 1 must be related to an activate EU MIRE Code which starts with F') ? true : false;
        	System.assertEquals(expectedExceptionThrown, true);
        }
        assessments.clear();
        toNotBeInsertedAssessment.F_Health_Impact_Choice_1__c = euMirCodeWithF.id;
        toNotBeInsertedAssessment.F_Health_Impact_Choice_2__c = euMirCodeWithNoF.id;
        assessments.add(toNotBeInsertedAssessment);
        try {
			insert assessments;
            throw new testInvestigationException('No Error was catched');
        } catch(Exception e){
            Boolean expectedExceptionThrown = e.getMessage().contains('The F Health Impact Choice 2 must be related to an activate EU MIRE Code which starts with F') ? true : false;
        	System.assertEquals(expectedExceptionThrown, true);
        }

        Test.stopTest();
    }
    
    public class testInvestigationException extends Exception {}
}