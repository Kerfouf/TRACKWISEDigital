/*
 * Created on Thurs Sept 02 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 */

@isTest
public with sharing class CrmComplaintIntegrationTestDataFactory {
    
    public static Case__x createExternalCase() {
        return createExternalCase('Open');
    }

    public static Case__x createExternalCase(String status) {

        String jsonString;
        Id recordId = fflib_IDGenerator.generate(Case__x.SObjectType);
        Id externalId = fflib_IDGenerator.generate(Case.SObjectType);
        String caseNumber = ((String)recordId).right(6);
        
        jsonString = '{"attributes":{"type":"Case__x","url":"/services/data/v53.0/sobjects/Case__x/' + externalId + '"},'+
            '"Id" : "' + recordId + '",' +
            '"Type__c" : "TechnicalComplaint",' +
            '"ExternalId" : "' + externalId + '",' +
            '"Description_c__c" : "Test Case",' +
            '"CaseNumber_c__c" : "' + caseNumber + '",' +
            '"BatchNumberUnknown_c__c" : false,' +
            '"isCreatedOnSite_c__c" : false,' +
            '"FixedOnPhone_c__c" : false,' +
            '"IsInternalCase_c__c" : false,' +
            '"WasEscalated_c__c" : false,' +
            '"DOA_c__c" : false,' +
            '"Status__c" : "' + status + '",' +
            '"CaseNumber__c" : "' + caseNumber + '"}';

        return (Case__x)JSON.deserialize(jsonString, Case__x.class);
    }

    public static CaseComment__x createExternalCaseComment(Id externalId, String body) {

        Id recordId = fflib_IDGenerator.generate(CaseComment__x.SObjectType);
        Id externalCaseId = fflib_IDGenerator.generate(Case.SObjectType);
        String jsonString = '{"attributes":{"type":"CaseComment__x","url":"/services/data/v53.0/sobjects/CaseComment__x/' + externalId + '"},"Id":"' + recordId + '","ExternalId":"' + externalId + '","CommentBody__c":"' + body + '","ParentId__c":"' + externalCaseId + '"}';

        return (CaseComment__x)JSON.deserialize(jsonString, CaseComment__x.class); 
    }

    public static WorkOrder__x createExternalWorkOrder(Id externalId, String subject) {

        Id recordId = fflib_IDGenerator.generate(WorkOrder__x.SObjectType);
        String jsonString = '{"attributes":{"type":"WorkOrder__x","url":"/services/data/v53.0/sobjects/WorkOrder__x/' + externalId + '"},"Id":"' + recordId + '","ExternalId":"' + externalId + '","Subject__c":"' + subject + '"}';

        return (WorkOrder__x)JSON.deserialize(jsonString, WorkOrder__x.class); 
    }

    public static ProductConsumed__x createExternalProductConsumed(Id externalId, Integer quantityConsumed) {

        Id recordId = fflib_IDGenerator.generate(ProductConsumed__x.SObjectType);
        String jsonString = '{"attributes":{"type":"ProductConsumed__x","url":"/services/data/v53.0/sobjects/ProductConsumed__x/' + externalId + '"},"Id":"' + recordId + '","ExternalId":"' + externalId + '","QuantityConsumed__c":' + quantityConsumed + '}';

        return (ProductConsumed__x)JSON.deserialize(jsonString, ProductConsumed__x.class); 
    }

    public static ServiceAppointment__x createExternalServiceAppointment(Id externalId, String description) {

        Id recordId = fflib_IDGenerator.generate(ServiceAppointment__x.SObjectType);
        String jsonString = '{"attributes":{"type":"ServiceAppointment__x","url":"/services/data/v53.0/sobjects/ServiceAppointment__x/' + externalId + '"},"Id":"' + recordId + '","ExternalId":"' + externalId + '","Description__c":"' + description + '"}';

        return (ServiceAppointment__x)JSON.deserialize(jsonString, ServiceAppointment__x.class); 
    }

    public static CMPL123CME__Complaint__c createComplaint(Boolean doInsert) {

        CMPL123CME__Complaint__c complaint = (CMPL123CME__Complaint__c) SmartFactory.createSObject(
            'CMPL123CME__Complaint__c'
        );
    
        complaint.BMX_Case_External__c = fflib_IDGenerator.generate(Case.SObjectType);
        complaint.BMX_PRE__c = 'Yes';
        complaint.BMX_LongDescription__c = 'Test Complaint';
        
        if (doInsert) {
            insert complaint;
        }

        return complaint;
    }

    public static Case_Comment__c createCaseComment(Boolean doInsert) {

        Case_Comment__c caseComment = (Case_Comment__c) SmartFactory.createSObject(
            'Case_Comment__c'
        );
    
        caseComment.ExternalId__c = fflib_IDGenerator.generate(Case_Comment__c.SObjectType);
        
        if (doInsert) {
            insert caseComment;
        }

        return caseComment;
    }

    public static Work_Order__c createWorkOrder(Boolean doInsert) {

        Work_Order__c workOrder = (Work_Order__c) SmartFactory.createSObject(
            'Work_Order__c'
        );
    
        workOrder.ExternalId__c = fflib_IDGenerator.generate(Work_Order__c.SObjectType);
        
        if (doInsert) {
            insert workOrder;
        }

        return workOrder;
    }

    public static Product_Consumed__c createProductConsumed(Boolean doInsert) {
        Product_Consumed__c productConsumed = (Product_Consumed__c) SmartFactory.createSObject(
            'Product_Consumed__c'
        );

        productConsumed.ExternalId__c = fflib_IDGenerator.generate(Product_Consumed__c.SObjectType);

        if (doInsert) {
            insert productConsumed;
        }

        return productConsumed;
    }

    public static Service_Appointment__c createServiceAppointment(Boolean doInsert) {

        Service_Appointment__c serviceAppointment = (Service_Appointment__c) SmartFactory.createSObject(
            'Service_Appointment__c'
        );

        serviceAppointment.ExternalId__c = fflib_IDGenerator.generate(Service_Appointment__c.SObjectType);

        if (doInsert) {
            insert serviceAppointment;
        }

        return serviceAppointment;
    }

    public static Group createQueue(Boolean doInsert) {
        
        Group queue = new Group(Type = 'Queue', DeveloperName = 'ApexUnitTestQueue', Name = 'Apex Unit Test Queue');

        if (doInsert) {
            insert queue;
        }

        return queue;
    }

    public static CRM_Integration_Settings__c createCrmIntegrationSetting(Boolean doInsert) {
        
        CRM_Integration_Settings__c config = new CRM_Integration_Settings__c(
            SetupOwnerId = UserInfo.getOrganizationId(),
            Complaints_As_Of__c = System.now().addYears(-1),
            Global_Assessments_As_Of__c = System.now().addYears(-1),
            Products_Consumed_As_Of__c = System.now().addYears(-1),
            Service_Appointments_As_Of__c = System.now().addYears(-1),
            Work_Orders_As_Of__c = System.now().addYears(-1),
            Case_Comments_As_Of__c = System.now().addYears(-1),
            Error_Notification_Address__c = 'test@test.com.bmx',
            Complaint_Batch_Size__c = 10,
            Case_Comment_Batch_Size__c = 200,
            Global_Assessment_Batch_Size__c = 10,
            Product_Consumed_Batch_Size__c = 200,
            Service_Appointment_Batch_Size__c = 200,
            Work_Order_Batch_Size__c = 200
        );

        if (doInsert) {
            insert config;
        }

        return config;
    }

    public static Error_Log__c createErrorLog(Boolean doInsert, String objectName, String externalId) {
        Error_Log__c log = new Error_Log__c(
            Object_Name__c = objectName,
            External_Case_Id__c = externalId
        );

        if (doInsert) {
            insert log;
        }

        return log;
    }
}