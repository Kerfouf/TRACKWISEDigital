public with sharing class LimsIncidentPlatformEventHelper {

    public static final String ORIGINATION_VALUE_FOR_QUALITY_EVENT = 'Manufacturing Site';

    public static final String QE_ERROR_TASK_SUBJECT = 'Quality Event creation failed';

    public static final String IL_ERRORS_SUBJECT = 'Quality Event had incorrect impacted LOTs at creation from LIMS';

    public static void managePlatformEvents(List<LIMS_Inc_PF_Event__e> events){
        try {
            Id qualityEventProductRecordTypeId = retrieveQualityEventProductRecordTypeId();
            System.debug('Starting to work on ' + events.size() + ' Events');
            // Create the Quality Event from the Platform Event
            Map<LIMS_Inc_PF_Event__e, Quality_Event__c> mapOfIncomingPFEventToCorrespondingCreatedQualityEvent = new Map<LIMS_Inc_PF_Event__e, Quality_Event__c>();
            for(LIMS_Inc_PF_Event__e loopEvent : events) {
                Quality_Event__c qualityEventToCreate = createQualityEventFromPlatformEvent(loopEvent, qualityEventProductRecordTypeId);
                mapOfIncomingPFEventToCorrespondingCreatedQualityEvent.put(loopEvent , qualityEventToCreate);
            }        
             // Insert the Mapped Quality Events
            insert mapOfIncomingPFEventToCorrespondingCreatedQualityEvent.values();        

            // Generate Impacted LOT Records
            List<Impacted_Lot_SN__c> impactedLotsToCreate = retrieveImpactedLotList(mapOfIncomingPFEventToCorrespondingCreatedQualityEvent);
            
            insert impactedLotsToCreate;
        } catch (DmlException e) {
            // Handle Exceptions here
            
            // Due date
            Date dueDate =  date.today();
            dueDate = dueDate.addDays(7);
            
            // Message
            String message = 'An error occured during creation of the Quality Events, please check Error message: [' + e.getMessage() + ']';
            
            Task errorTask = new Task();
            errorTask.ActivityDate = dueDate;
            errorTask.OwnerId = getIntegrationErrorQueueId();
            errorTask.Description = message.abbreviate(32000);
            errorTask.Subject = QE_ERROR_TASK_SUBJECT;

            insert errorTask;
        }


       
    }

    private static List<Impacted_Lot_SN__c> retrieveImpactedLotList(Map<LIMS_Inc_PF_Event__e, Quality_Event__c> mapOfIncomingPFEventToCorrespondingCreatedQualityEvent){
        // Task error management
        List<Task> taskToBeCreatedInCaseOfError = new List<Task>();
        Id queueAssignmentId = getIntegrationErrorQueueId();
        Id impactedLotLimsRecordTypeId = retrieveImpactedLotLimsRecordTypeId();
        
        List<Impacted_Lot_SN__c> impactedLotsToCreate = new List<Impacted_Lot_SN__c>();
        for(LIMS_Inc_PF_Event__e platformEvent : mapOfIncomingPFEventToCorrespondingCreatedQualityEvent.keySet()) {
            Quality_Event__c qualityEvent = mapOfIncomingPFEventToCorrespondingCreatedQualityEvent.get(platformEvent);
            
            // As per specified, we must create impacted lot with the received values in 3 fields. Values are | separated

            List<String> productCodesAsAList = retrievePipeSeparatedValues(platformEvent.Product_Codes__c);
            List<String> productDescriptionsAsAList = retrievePipeSeparatedValues(platformEvent.Product_Descriptions__c);
            List<String> limsBatchIdsAsAList = retrievePipeSeparatedValues(platformEvent.Batch_IDs__c);
            List<String> productSupplierLotSerialNumber = retrievePipeSeparatedValues(platformEvent.Vendor_Batch_Id__c);
            
            Integer productCodesAsAListSize = productCodesAsAList.size();
            Integer productDescriptionsAsAListSize= productDescriptionsAsAList.size();
            Integer limsBatchIdsAsAListSize= limsBatchIdsAsAList.size();
            Integer productSupplierLotSerialNumberSize= productSupplierLotSerialNumber.size();
            
            // Functionnal need:
            // The CODE and Description fields are mandatory (size > 0 and same size)
            // Batch and supplier serial number are not mandatory (can be empty)
            
            // CODE and description are valid
            Boolean codeAndDescriptionAreValid = productCodesAsAList.size() > 0;
            codeAndDescriptionAreValid = codeAndDescriptionAreValid && productCodesAsAList.size() == productDescriptionsAsAList.size();

            // Batch ID field valid if same size as code OR empty
            Boolean batchIdsFieldIsValid = limsBatchIdsAsAList.size() == productCodesAsAList.size() || String.isBlank(platformEvent.Batch_IDs__c);
            
            // Supplier serial field valid if same size as code OR empty
            Boolean supplierSerialFieldIsValid = productSupplierLotSerialNumber.size() == productCodesAsAList.size() || String.isBlank(platformEvent.Vendor_Batch_Id__c);


            // Now, validate the fact that values are valid for impacted lot creation
            boolean isValid = codeAndDescriptionAreValid && batchIdsFieldIsValid && supplierSerialFieldIsValid;

            
            if(!isValid){
                // Create a task if the values are incorrect
                Task errorTask = new Task();
                String message = 'The Impacted Lots could not be created from the following values because it doesnt include the same count of pipe | separated Values Platform Event values:';
                message += ' Product_Codes__c = ' + platformEvent.Product_Codes__c;
                message += ' Product_Descriptions__c = ' + platformEvent.Product_Descriptions__c;
                message += ' Batch_IDs__c = ' + platformEvent.Batch_IDs__c;
                message += ' Vendor_Batch_Id__c = ' + platformEvent.Vendor_Batch_Id__c;
                
                errorTask.Description = message.abbreviate(32000);
                errorTask.WhatId = qualityEvent.Id;
                errorTask.OwnerId = queueAssignmentId;    
                errorTask.Subject = IL_ERRORS_SUBJECT;
                
                Date dueDate =  date.today();
                dueDate = dueDate.addDays(7);
                
                errorTask.ActivityDate = dueDate;

                taskToBeCreatedInCaseOfError.add(errorTask);
                System.debug('Problem with values');
                continue;
            }
            for(Integer i = 0 ; i < productCodesAsAList.size() ; i++){
                // The CODE AND Description are mandatory, no need to empty check
                String productCode = productCodesAsAList.get(i);
                String productDescription = productDescriptionsAsAList.get(i);

                // Batch ID and Supplier Serial can be empty
                String batchID = String.isNotBlank(platformEvent.Batch_IDs__c)? limsBatchIdsAsAList.get(i) : null;
                String supplierLotSN = String.isNotBlank(platformEvent.Vendor_Batch_Id__c)? productSupplierLotSerialNumber.get(i) : null;

                // Build impacted lot
                Impacted_Lot_SN__c impactedLot = new Impacted_Lot_SN__c();
                
                // Record type
                impactedLot.RecordTypeid = impactedLotLimsRecordTypeId;
                // Values mapping
                impactedLot.Item_Number__c = productCode;
                impactedLot.Item_Description__c = productDescription;
                impactedLot.Lot_Serial_Number__c = batchID;
                impactedLot.Supplier_Lot_Serial_Number__c = supplierLotSN;                                
                impactedLot.Related_Quality_Event__c = qualityEvent.Id;
                impactedLotsToCreate.add(impactedLot);
            }

        }
        if(!taskToBeCreatedInCaseOfError.isEmpty()){
            insert taskToBeCreatedInCaseOfError;
        }
        return impactedLotsToCreate;
    }


    private static Quality_Event__c createQualityEventFromPlatformEvent(LIMS_Inc_PF_Event__e platformEvent, Id qualityEventProductRecordTypeId){
        Quality_Event__c qualityEventToReturn = new Quality_Event__c();
        qualityEventToReturn.RecordTypeid = qualityEventProductRecordTypeId;
        qualityEventToReturn.LIMS_Incident_Number__c = platformEvent.LIMS_Incident_ID__c;
        qualityEventToReturn.Origination__c = ORIGINATION_VALUE_FOR_QUALITY_EVENT;
        qualityEventToReturn.Title__c = platformEvent.Title__c;
        qualityEventToReturn.Description__c = platformEvent.Description__c;
        qualityEventToReturn.Origination_Entity__c = platformEvent.TWD_Origination_Entity__c;
        qualityEventToReturn.Quality_Event_Type__c= platformEvent.LIMS_Incident_Type__c;
        qualityEventToReturn.LIMS_Originator__c = platformEvent.LIMS_Originator__c;        

        return qualityEventToReturn;
    }


    private static List<String> retrievePipeSeparatedValues(String stringToSplit){
        if(String.isBlank(stringToSplit)){
            return new List<String>();
        }
        stringToSplit = stringToSplit.unescapeHtml4();
        Integer countOfPipes = stringToSplit.countMatches('|') + 1;
        System.debug('String to Split: ' + stringToSplit);
        return stringToSplit.split('\\|',countOfPipes);
    }


    private static Id retrieveQualityEventProductRecordTypeId(){
        RecordType rType = [SELECT Id FROM RecordType WHERE SObjectType = 'Quality_Event__c' AND DeveloperName = 'Product'];
        return rType.Id;
    }
    
    private static Id retrieveImpactedLotLimsRecordTypeId(){
        RecordType rType = [SELECT Id FROM RecordType WHERE SObjectType = 'Impacted_Lot_SN__c' AND DeveloperName = 'LIMS_Impacted_Lot'];
        return rType.Id;
    }

    private static Id getIntegrationErrorQueueId(){
        return [Select Id from Group where Type = 'Queue' AND DeveloperName = 'Integration_Issue_Queue'].Id;
    }
    
}