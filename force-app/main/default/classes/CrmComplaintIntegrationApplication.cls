/*
 * Created on Thurs Oct 28, 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Brian Lavin
 * 
 * Application Context for CRM Complaint Integration.
 */

public inherited sharing class CrmComplaintIntegrationApplication {

    public static final fflib_Application.UnitOfWorkFactory unitOfWork =
        new fflib_Application.UnitOfWorkFactory (
            new List<SObjectType> {
                CMPL123CME__Complaint__c.SObjectType
            }
        ); 
   
    public static final fflib_Application.ServiceFactory service =
        new fflib_Application.ServiceFactory (
            new Map<Type, Type> {
                CrmComplaintIntegrationService.class => CrmComplaintIntegrationServiceImpl.class,
                GlobalAssessmentService.class => GlobalAssessmentServiceImpl.class,
                CrmCaseCommentIntegrationService.class => CrmCaseCommentIntegrationServiceImpl.class,
                CrmWorkOrderIntegrationService.class => CrmWorkOrderIntegrationServiceImpl.class,
                CrmProductsConsumedIntegrationService.class => CrmProductsConsumedIntServiceImpl.class,
                CrmServiceAppointmentIntegrationService.class => CrmServiceAppointmentIntServiceImpl.class
            }
        );
   
    public static final fflib_Application.SelectorFactory selector =
        new fflib_Application.SelectorFactory (
            new Map<SObjectType, Type> {
                Case__x.SObjectType => ExternalCaseSelectorImpl.class,
                Account__x.SObjectType => ExternalAccountSelectorImpl.class,
                Location__x.SObjectType => ExternalLocationSelectorImpl.class,
                Address__x.SObjectType => ExternalAddressSelectorImpl.class,
                Asset__x.SObjectType => ExternalAssetSelectorImpl.class,
                CodeGroup_c__x.SObjectType => ExternalCodeGroupSelectorImpl.class,
                Contact__x.SObjectType => ExternalContactSelectorImpl.class,
                Entitlement__x.SObjectType => ExternalEntitlementSelectorImpl.class,
                Product2__x.SObjectType => ExternalProductSelectorImpl.class,
                RecordType__x.SObjectType => ExternalRecordTypeSelectorImpl.class,
                User__x.SObjectType => ExternalUserSelectorImpl.class,
                CRM_TWD_Complaint_Creation__mdt.SObjectType => ComplaintConfigSelectorImpl.class,
                CMPL123CME__Complaint__c.SObjectType => ComplaintSelectorImpl.class,
                Group.SObjectType => GroupSelectorImpl.class,
                Case_Comment__c.SObjectType => CaseCommentSelectorImpl.class,
                CaseComment__x.SObjectType => ExternalCaseCommentSelectorImpl.class,
                Work_Order__c.SObjectType => WorkOrderSelectorImpl.class,
                WorkOrder__x.SObjectType => ExternalWorkOrderSelectorImpl.class,
                ProductConsumed__x.SObjectType => ExternalProductConsumedSelectorImpl.class,
                Product_Consumed__c.SObjectType => ProductConsumedSelectorImpl.class,
                ServiceAppointment__x.SObjectType => ExternalServiceAppointmentSelectorImpl.class,
                Service_Appointment__c.SObjectType => ServiceAppointmentSelectorImpl.class,
                AsyncApexJob.SObjectType => AsyncApexJobSelectorImpl.class
            }
        );
  }