/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : CreateAllChildSchedulableBatch
* @Why   : 
* @When  : 09-May-2019
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        09-May-2019         Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

global class CreateAllChildSchedulableBatch implements Schedulable,Database.AllowsCallouts{   

/**
* @Method       : execute
* @Invoke       : 
* @Description  : Method to query all the external case records created/updated in last 24 hours in CRM and passing those records
*                 to the CreateComplaintForCaseBatch batch class for processing.
* @Return       : N/A
* @Params       : 
**/ 
 
    global void execute(SchedulableContext sc) { 
        
        // querying the external Case records which are created/updated in last 24 hours 
        DateTime latestTimeStamp = Complaint_Creation_Batch_Time__c.getInstance().Batch_Completion_Time__c;

        Integer count = [SELECT Count() FROM Case__x WHERE LastModifiedDate__c >=: latestTimeStamp];
        String formattedTime = latestTimeStamp.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss.SSSZ');

        String query = 'SELECT Id, ExternalId FROM Case__x WHERE LastModifiedDate__c >= ' + formattedTime;

        Complaint_Creation_Batch_Time__c cst = [SELECT Id, Batch_Completion_Time__c FROM Complaint_Creation_Batch_Time__c LIMIT 1];
        cst.Batch_Completion_Time__c = System.now();
        update cst;
        CreateComplaintForCaseBatch bc = new CreateComplaintForCaseBatch(query, count, latestTimeStamp);
        Database.executeBatch(bc, 50);
    }  
}