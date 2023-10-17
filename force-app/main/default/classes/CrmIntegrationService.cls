/*
 * Created on Fri Dec 03 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 */

public abstract class CrmIntegrationService {

    private final String FAILURE_STATUS = 'Failed';
    
    /**
    * Handles the logging of CRM integration errors
    * @param  recordId - Failed record Id
    * @param  externalId - External Id of the external source record 
    * @param  className - Name of the class where the error was encountered
    * @param  objectName - The object upon which the DML operation failed 
    * @param  failures - List of DB Save Results with the failed record
    */
    protected void logError(
        String recordId,
        String externalId, 
        String className, 
        String objectName,
        List<DBSaveResultWithRecord> failures) {
        
        fflib_ISObjectUnitOfWork uow = CrmComplaintIntegrationApplication.unitOfWork.newInstance(
            new List<SObjectType> {
                Error_Log__c.sObjectType
            }
        );
        
        for (DBSaveResultWithRecord failure : failures) {
            Database.SaveResult saveResult = failure.result;
            for (Database.Error error : saveResult.getErrors()) {
                Error_Log__c errorLog = new Error_Log__c(
                    Record_ID__c = (String)failure.obj.get(recordId),
                    External_Case_Id__c = (String)failure.obj.get(externalId),
                    Class_Name__c = className,
                    Error_Message__c = error.getMessage(),
                    Error_Type__c = 'DML Exception ' + error.getStatusCode(),
                    Object_Name__c = objectName,
                    Status__c = FAILURE_STATUS
                );
                System.debug(errorLog);
                uow.registerNew(errorLog);
            }
        }

        uow.commitWork();
    }

    /**
    * Handles upsert of new or updated records, providing error handling via
    * DBSaveFailureCallback
    * @param  recordsToUpsert
    * @param  failure - callback object for DML save error
    */
    protected void upsertList(List<SObject> recordsToUpsert, DBSaveFailureCallback failure) {
        
        SPS_Dml dml = new SPS_Dml();
        if (failure != null) {
            dml.setOnFailureCallback(failure);
        }

        fflib_ISObjectUnitOfWork uow = CrmComplaintIntegrationApplication.unitOfWork.newInstance(
            new List<SObjectType> { recordsToUpsert.getSObjectType() }, 
            dml
        );

        for (SObject recordToUpsert : recordsToUpsert) {
            if (recordToUpsert.get('Id') == null) {
                uow.registerNew(recordToUpsert);
            }
            else {
                uow.registerDirty(recordToUpsert);
            }
        }
        
        uow.commitWork();
    }

    protected Set<Id> extractExternalIds(List<SObject> objs) {
        Set<Id> externalIds = new Set<Id>();
        for (SObject obj : objs) {
            externalIds.add((Id)obj.get('ExternalId'));
        }
        return externalIds;
    }
}