/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : ReprocessErrorLogsBatch_Schedule 
* @Why   : Batch class to execute ReprocessErrorLogsBatch batch class
* @When  : 23-APR-2019
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        23-APR-2019        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

public class ReprocessErrorLogsBatch_Schedule implements Schedulable,Database.AllowsCallouts{
    
    public void execute(SchedulableContext sc){
        //Datetime timestamp = System.now().addHours(-24);
		
		// Querying Error log object and passing the data to the ReprocessErrorLogsBatch batch class to execute 
        String query = 'SELECT Id,Name,External_Case_Id__c, Class_Name__c, Error_Message__c, Error_Type__c, Object_Name__c, Record_ID__c FROM Error_Log__c WHERE LastModifiedDate >=: timeStamp';
        ReprocessErrorLogsBatch bc = new ReprocessErrorLogsBatch(query);
        Database.executeBatch(bc, 200) ;        
    }
}