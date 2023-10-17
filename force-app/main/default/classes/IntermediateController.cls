public with sharing class IntermediateController {
    public String inputText { get; set; }
    private final Intermediate_Answer__c answer;
    public IntermediateController(ApexPages.StandardController controller) {
        this.answer = (Intermediate_Answer__c)controller.getRecord();
    }
    public void saveInput() {
        answer.Intermediate_Answer__c = inputText;
        update answer;

    }

}