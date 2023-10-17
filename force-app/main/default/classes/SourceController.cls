public with sharing class SourceController {
    @AuraEnabled(cacheable=true)
    public static List<Source__c> fetchSources() {
        List<Source__c> sources = [SELECT Id, Name FROM Source__c];
        System.debug('Sources: ' + sources); // Log the sources
        return sources;
    }
}