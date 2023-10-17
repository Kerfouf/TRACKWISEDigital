/*
 * Created on Tue Dec 21, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

 public with sharing class CrmIntegrationErrorNotificationSched implements Schedulable {
    
    private final Set<String> FAILED_STATUSES = new Set<String> { 'Failed', 'Retry', 'Retrying' };
    private CRM_Integration_Settings__c config;
    public Integer activeFailures;
    private ListView activeFailuresListView;
    
    public CrmIntegrationErrorNotificationSched() {
    }

    public void execute(SchedulableContext sc) {
        this.config = CRM_Integration_Settings__c.getOrgDefaults();
        this.activeFailures = [Select Count() From Error_Log__c Where Status__c In :FAILED_STATUSES];
        if ([SELECT Count() FROM ListView Where SobjectType = 'Error_Log__c' AND Name = 'Active Failures'] > 0) {
            this.activeFailuresListView = [SELECT Id FROM ListView Where SobjectType = 'Error_Log__c' AND Name = 'Active Failures'][0];
        }

        if (activeFailures > 0) {
            sendMail();
        }
    }

    private void sendMail() {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        List<String> toAddress = config.Error_Notification_Address__c.split(',');
        email.setSubject('CRM Integration Error Notification');
        email.setPlainTextBody('There are ' + String.valueOf(activeFailures) + ' active failures. Please review at your earliest convenience.');
        email.setHtmlBody(getHtmlBody());
        email.setToAddresses(toAddress);
        if (!Test.isRunningTest()) {
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { email });
        }
    }

    private String getHtmlBody() {
        String url = URL.getSalesforceBaseUrl().toExternalForm();
        if (this.activeFailuresListView != null) {
            url += '/lightning/o/Error_Log__c/list?filterName=' + activeFailuresListView.Id;
        }
        String body = 
            String.format(
                '<p>There are {0} active errors. Please review at your convenience.</p>', 
                new List<Object> { String.valueOf(activeFailures) }
            ) + 
            '<a href="' + url + '">Active Failures</a>' + 
            '<br><br>';
        return body;
    }
}