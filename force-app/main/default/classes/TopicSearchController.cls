public with sharing class TopicSearchController {
    @AuraEnabled(cacheable=true)
    public static List<Topic__c> searchTopics(String searchTerm) {
        // Query the topics based on the searchTerm
        String searchQuery = '%' + searchTerm + '%';
        return [SELECT Id, Name FROM Topic__c WHERE Name LIKE :searchQuery ];
    }
}