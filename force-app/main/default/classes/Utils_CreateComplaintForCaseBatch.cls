/**
*  --------------------------------------------------------------------------------------------------------------------------------------
* @Who   : Copyright (c) 2017 - 2019  Sparta Systems, Inc.
* @What  : Utils_CreateComplaintForCaseBatch
* @Why   : Utils class to populate Complaint details from external objects, creating error log list and creating email with 
*          error file attached.
* @When  : 18-APR-2019
  
*  --------------------------------------------------------------------------------------------------------------------------------------
*  Modification Log:  
*  --------------------------------------------------------------------------------------------------------------------------------------
*   Developer                Date             Description 
*  --------------------------------------------------------------------------------------------------------------------------------------
*                        18-APR-2019        Created.
*  --------------------------------------------------------------------------------------------------------------------------------------
**/

public class Utils_CreateComplaintForCaseBatch {

    public Static Boolean recordUpdateRequired = false;
     
    
    
/**
* @Method       : populateComplaintDetailsFromExternalObjects
* @Invoke       : 
* @Description  : Method to populate Complaint details from external objects
* @Return       : complaint which needs to get inserted/updated
* @Params       : complaint , sobject , List of metadata for complaint creation, boolean to indicate the complaint insertion/updation , relationship field name 
*                 to which relates the external Case to the parent external objects
**/ 
    public Static CMPL123CME__Complaint__c populateComplaintDetailsFromExternalObjects(CMPL123CME__Complaint__c cmplnt, sobject obj , List<CRM_TWD_Complaint_Creation__mdt> mdtList, String objType, Boolean isInsert, String relationShipFieldName) {

        Boolean updateRequired = false;
        for(CRM_TWD_Complaint_Creation__mdt mdt : mdtList) {
            
            if((mdt.Object_API_Name__c == objType && 
                ((mdt.Relationship_Name__c == null && relationShipFieldName == '') || mdt.Relationship_Name__c == relationShipFieldName) && 
                (obj.get(mdt.CRM_Field_API_Name__c) <> null || obj.get(mdt.CRM_Field_API_Name__c) == null)) )  {

                    if(!isInsert && obj.get(mdt.CRM_Field_API_Name__c) <> cmplnt.get(mdt.TWD_Field_API_Name__c)) {
                        System.debug('Complaint updated ' + obj.get('Id') + ': ' + mdt.CRM_Field_API_Name__c + ' ' + 
                        mdt.TWD_Field_API_Name__c + ' ' + obj.get(mdt.CRM_Field_API_Name__c) + ' ' + cmplnt.get(mdt.TWD_Field_API_Name__c));
                        updateRequired = true;
                    }
                    if(isInsert || updateRequired) {
                        cmplnt.put(mdt.TWD_Field_API_Name__c, obj.get(mdt.CRM_Field_API_Name__c));
                    }
            }
        }

        if(updateRequired) {
            recordUpdateRequired = true;
        }
        return cmplnt;
    }


/**
* @Method       : returnUpsertFailureLogs
* @Invoke       : 
* @Description  : Method to create Error logs from the List of Database.upsertResult
*                 and sent from CreateComplaintForCaseBatch and returning it to that batch class.

* @Return       : List of Error log
* @Params       : Data upsert list , complaint list , class name and object name
**/ 
    public Static List<Error_Log__c> returnUpsertFailureLogs(List<Database.UpsertResult> srList, List<CMPL123CME__Complaint__c> cmpList, String className, String objectName) {

        List<Error_Log__c> errorLogList = new List<Error_Log__c>();
        for(Integer i=0; i <srList.size(); i++) {
            if(!srList[i].isSuccess() ) {
                Error_Log__c el = returnErrorLog(srList[i].getErrors(), className, objectName);
                el.Record_ID__c = cmpList[i].Id;
                el.External_Case_Id__c = cmpList[i].BMX_Case_External__c;
                errorLogList.add(el);
            }
        }
        return errorLogList;   
    }
    
/**
* @Method       : returnSaveFailureLogs
* @Invoke       : 
* @Description  : Method to create Error logs from the List of Database.saveResult
*                 and sent from ProcessReopenCloseComplaintForCaseBatch class and returning it to that batch class.

* @Return       : List of Error log
* @Params       : Save result list , complaint list , class name and object name
**/ 

    public Static List<Error_Log__c> returnSaveFailureLogs(List<Database.SaveResult> srList, List<CMPL123CME__Complaint__c> cmpList, String className, String objectName) {

        List<Error_Log__c> errorLogList = new List<Error_Log__c>();
        for(Integer i=0; i <srList.size(); i++) {
            if(!srList[i].isSuccess() ) {
                Error_Log__c el = returnErrorLog(srList[i].getErrors(), className, objectName);
                el.Record_ID__c = cmpList[i].Id;
                el.External_Case_Id__c = cmpList[i].BMX_Case_External__c;
                errorLogList.add(el);
            }
        }
        return errorLogList;   
    }

/**
* @Method       : returnErrorLog
* @Invoke       : 
* @Description  : Method to create error log records and return it
* @Return       : List of Error log
* @Params       : database error list , class name and object name
**/ 
    public Static Error_Log__c returnErrorLog(List<Database.Error> errList, String className, String objectName) {
        
        Error_Log__c el = new Error_Log__c();

        for(Database.Error err : errList) {
            el.Class_Name__c = className;
            el.Error_Message__c = err.getMessage();
            el.Error_Type__c = err.getStatusCode() + 'Batch DML Exception';
            el.Object_Name__c = objectName;
        }
        return el;
    }


/**
* @Method       : returnEmailMessage
* @Invoke       : 
* @Description  : Method to attach the CSV file with error logs to the Email and returning the email
* @Return       : Email with attachment containg the error logs
* @Params       : subject of email , body of email , email recepients  and email attachment
**/ 
    public Static Messaging.SingleEmailMessage returnEmailMessage(String subject, String body, List<String> emailAddressList, Blob emailAttachment) {


        Messaging.EmailFileAttachment csvAttachment = new Messaging.EmailFileAttachment();
        csvAttachment.setFileName('Error Log Sheet');
        csvAttachment.setBody(emailAttachment);

        Messaging.SingleEmailMessage sm = new Messaging.SingleEmailMessage();
        sm.setSubject(subject);
        sm.setHTMLBody(body);
        sm.setToAddresses(emailAddressList);
        sm.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttachment});
        return sm;
    }

}