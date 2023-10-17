/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : ReprocessErrorLogsBatch 
* @Why   : Batch class to create a CSV file containing failure records information and sending an email to the users with
*          the CSV file attached.
* @When  : 19-APR-2019
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        19-APR-2019        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

public class ReprocessErrorLogsBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    public String queryString;
    public datetime timeStamp= system.now().addHours(-24);
    String finalCSVString = '';
    public List<Error_Log__c> totErrList = new List<Error_Log__c>();
    
	// Intializing the query string to query the Error log object
    public ReprocessErrorLogsBatch(String queryString) {
        this.queryString = queryString;
    }

	// Quering the Error Log object
    public Database.QueryLocator start(Database.BatchableContext bc) { 
        return Database.getQueryLocator(queryString);
    }

    public void execute(Database.BatchableContext bc, List<Error_Log__c> errList) {

        String csvHeader = 'Error Log Number, Record Id, Object Name, Error Type, Error Message, Class Name, External Case Id \n';
        String csvBody = '';
        
		// Creating the CSV file keeping all the error logs
        for(Error_Log__c err : errList) {
            
            if(err.Name <> null) {
                csvBody = csvBody + err.Name + ',';
            } else {
                csvBody = csvBody + ' ,';
            }
            if(err.Record_ID__c <> null) {
                csvBody = csvBody + err.Record_ID__c + ',';
            } else {
                csvBody = csvBody + ' ,';
            }
            if(err.Object_Name__c <> null) {
                csvBody = csvBody + err.Object_Name__c + ',';
            } else {
                csvBody = csvBody + ' ,';
            }
            if(err.Error_Type__c <> null) {
                csvBody = csvBody + err.Error_Type__c + ',';
            } else {
                csvBody = csvBody + ' ,';
            }
            if(err.Error_Message__c <> null) {
                csvBody = csvBody + err.Error_Message__c + ',';
            } else {
                csvBody = csvBody + ' ,';
            }
            if(err.Class_Name__c <> null) {
                csvBody = csvBody + err.Class_Name__c + ',';
            } else {
                csvBody = csvBody + ' ,';
            }
            if(err.External_Case_Id__c <> null) {
                csvBody = csvBody + err.External_Case_Id__c + '\n';
            } else {
                csvBody = csvBody + '\n';
            }
        }

        String finalString = csvHeader + csvBody; 
        finalCSVString += finalString;
    }

    public void finish(Database.BatchableContext bc) {
        
        Complaint_Creation_Batch_Time__c cst = Complaint_Creation_Batch_Time__c.getInstance();
        List<String> emailAddressList = new List<String>();
        
        for(String str : cst.Email_Recipient__c.split(',')) {
            emailAddressList.add(str);
        }
        
        Blob emailAttachment = Blob.valueOf(finalCSVString);
        
		// Creating email with the attachment containg the CSV file with the error logs
        List<Messaging.SingleEmailMessage> smList = new List<Messaging.SingleEmailMessage>();
        String subject = 'Integration Failure Logs';
        String body = 'Dear <b>Administrator</b>, <br/> <br/>';
        body += 'Please find attachment of the Error Log failures in the last 24 hours <br/>';
        smList.add(Utils_CreateComplaintForCaseBatch.returnEmailMessage(subject, body, emailAddressList, emailAttachment));
        Messaging.SendEmailResult[] result = Messaging.sendEmail(smList);
    }

}