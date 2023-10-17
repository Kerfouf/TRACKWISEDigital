public with sharing class ChapterController {
    @AuraEnabled(cacheable=true)
    public static List<Chapter__c> fetchChaptersBySource(List<Id> selectedSourceId) {
        // Query chapters based on the selected source ID
List<Chapter__c> chapters = [SELECT Id,Name,Source__c 
            FROM Chapter__c
            WHERE Source__c IN:selectedSourceId
        ];
        System.debug('Selected Source ID: ' + selectedSourceId);
        return chapters;
    }
}