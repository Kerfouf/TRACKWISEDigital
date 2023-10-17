/*
* Created on Tue Dec 14, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

public inherited sharing class ErrorLogs extends fflib_SObjectDomain {

    private Map<SObjectType, List<Error_Log__c>> logRegistery;

    public ErrorLogs(List<Error_Log__c> records) {
        super(records);
        this.logRegistery = new Map<SObjectType, List<Error_Log__c>>();
    }

    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> records){
            return new ErrorLogs(records);
        }
    }

    public override void onAfterUpdate(Map<Id, SObject> existingRecords) { 
        handleRetry();
    }

    public override void onBeforeUpdate(Map<Id,SObject> existingRecords) { 
        handleRetrying();
    }

    private void handleRetry() {
        
        List<Error_Log__c> logs = getChangedRecords(new Set<String> {'Status__c'});

        for (Error_Log__c log: logs) {
            if (log.Status__c == 'Retry' || log.Status__c == 'Retrying') {
                registerLogEntry(log);
            }
        }

        executeBatches();
    }

    private void handleRetrying() {
        for (SObject obj : Records) {
            Error_Log__c log = (Error_Log__c) obj;
            if (log.Status__c == 'Retry') {
                log.Status__c = 'Retrying';
            }
        }
    }

    private void executeBatches() {
        
        for (SObjectType sObjType : this.logRegistery.keySet()) {

            CrmRetryJob job;

            switch on sObjType.getDescribe().getName() {
                when 'Case_Comment__c' {
                    job = new CrmCaseCommentsIntegrationRetryJob(
                        this.logRegistery.get(sObjType)
                    );
                }
                when 'CMPL123CME__Complaint__c' {
                    job = new CrmComplaintIntegrationRetryJob(
                        this.logRegistery.get(sObjType)
                    );                   
                }
                when 'CMPL123CME__Questionnaire__c' {
                    job = new CreateGlobalAssessmentsRetryJob(
                        this.logRegistery.get(sObjType)
                    );                   
                }
                when 'Product_Consumed__c' {
                    job = new CrmProductConsumedIntegrationRetryJob(
                        this.logRegistery.get(sObjType)
                    );                   
                }
                when 'Service_Appointment__c' {
                    job = new CrmServiceAppointmentIntegrationRetryJob(
                        this.logRegistery.get(sObjType)
                    );                   
                }
                when 'Work_Order__c' {
                    job = new CrmWorkOrderIntegrationRetryJob(
                        this.logRegistery.get(sObjType)
                    );                   
                }
                when else {
                    
                }
            }

            if (job != null) {
                job.run();
            }
        }
    }

    private void registerLogEntry(Error_Log__c log) {
    
        SObjectType sObjType = ((SObject) Type.forName(log.Object_Name__c).newInstance()).getSObjectType();

        if (logRegistery.get(sObjType) == null) {
            logRegistery.put(sObjType, new List<Error_Log__c>());
        }

        logRegistery.get(sObjType).add(log);
    }
}