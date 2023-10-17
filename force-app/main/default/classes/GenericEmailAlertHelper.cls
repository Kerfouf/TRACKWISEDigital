public with sharing class GenericEmailAlertHelper {

    public static void sendEmailNotifications(Map<Id, SOBject> oldObjects , List<SOBject> newObjects, String objectType){
        /*if(true)
            return;
        */
        All_Objects_Workflow_Email_Notif_Conf.GenericEmailAlertConfigurator configurator = emailConfiguratorFactory(objectType);
                                
        List<Messaging.SingleEmailMessage> mailsToSendList = new  List<Messaging.SingleEmailMessage>();
        for(SOBject loopNewObject : newObjects) {
            SObject loopOldObject = oldObjects.get(loopNewObject.Id);
            Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> mailInfoAndTargetUsers = emailToSendInfo(loopOldObject ,loopNewObject, configurator);            
            mailsToSendList.addAll(sendEmails(loopNewObject, mailInfoAndTargetUsers));
        }
        try{
            System.debug('Count of Email that will be sent: ' + mailsToSendList.size());
            Messaging.sendEmail(mailsToSendList, false);
        }
        catch(Exception e){
            System.debug('The Send of the emails failed');
        }
        
        
    }

    public static List<Messaging.SingleEmailMessage> sendEmails(SOBject relatedToObject, Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> mailInfoAndTargetUsers){
        List<Messaging.SingleEmailMessage> mailsToSendList = new  List<Messaging.SingleEmailMessage>();
        for(All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator mailConfiguration : mailInfoAndTargetUsers.keySet()){
            Set<Id> loopIdListToSendMail = mailInfoAndTargetUsers.get(mailConfiguration);
            if(Helper.isEmpty(loopIdListToSendMail)){
                continue;
            }
            for(Id userId : loopIdListToSendMail) {
                Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
                emailToSend.setTargetObjectId(userId);
                emailToSend.setSenderDisplayName('bioMerieux TWD');
                emailToSend.setReplyTo('no-reply@no-reply.biomerieux.com');
                emailToSend.setUseSignature(false);
                emailToSend.setBccSender(false);
                emailToSend.setSaveAsActivity(false);
                
                // Body
                String bodyValue = replaceValues(relatedToObject, mailConfiguration.EmailBodyLabelValue, mailConfiguration);
                String subjectValue = replaceValues(relatedToObject, mailConfiguration.EmailSubjectValue, mailConfiguration);
                emailToSend.setPlainTextBody(bodyValue);
                emailToSend.setSubject(subjectValue);
                
                emailToSend.setWhatId(relatedToObject.Id);
                mailsToSendList.add(emailToSend);
            }
        }
        return mailsToSendList;
    }

    public static Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> emailToSendInfo(SObject oldReferenceObject , SObject newReferenceObject, All_Objects_Workflow_Email_Notif_Conf.GenericEmailAlertConfigurator config) {
        
        Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator> mailsInfo = extractMailsToSendInfo(oldReferenceObject ,newReferenceObject, config);
        Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> mapToReturn = extractMapOfConfigToListOfUsers(newReferenceObject, mailsInfo);
        return mapToReturn;
    }

    public static Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> extractMapOfConfigToListOfUsers(SObject objectToProceed, Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator> mailsInfo){
        Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> mapToReturn = new Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>>();
        for(All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator info : mailsInfo) {
            for(String fieldName : info.recipientFields){
                Id userId = (Id) objectToProceed.get(fieldName);
                
                // if null, don't execute the rest, go to next loop element
                if(String.isBlank(userId)){
                    continue;
                }
                if(!mapToReturn.containsKey(info)){
                    mapToReturn.put(info , new Set<Id>());
                }
                mapToReturn.get(info).add(userId);
            }
        }
        return mapToReturn;
    }

    private static Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator> extractMailsToSendInfo(SObject oldReferenceObject , SObject newReferenceObject, All_Objects_Workflow_Email_Notif_Conf.GenericEmailAlertConfigurator config) {
        Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator> conditionsThatRequireMailSending = new Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator>();
        for(All_Objects_Workflow_Email_Notif_Conf.WorkflowEmailAlertConfigurator conditions : config.getConfiguredConditions()){
            for(String fieldName : conditions.fieldToExpectedValues.keySet()){
                
                List<String> listOfExpectedValues = conditions.fieldToExpectedValues.get(fieldName);

                // See if it's a change of Status, action
                Boolean valueHasChanged = valueHasChanged(oldReferenceObject , newReferenceObject , fieldName);                                        
                
                String stringValueOfField = (String) newReferenceObject.get(fieldName);
                if(String.isBlank(stringValueOfField)){
                    continue;
                }

                // Does the value of the field match the expected value to send mail?                
                Boolean meetsConditionForMailSending = false;
                if(conditions.comparisonToapply == All_Objects_Workflow_Email_Notif_Conf.COMPARISON_TYPE.STRICT){
                    meetsConditionForMailSending = listOfExpectedValues.contains(stringValueOfField);
                }
                if(conditions.comparisonToapply == All_Objects_Workflow_Email_Notif_Conf.COMPARISON_TYPE.CONTAINS){                                        
                    for(String expectedApproximateValue : listOfExpectedValues){                        
                        meetsConditionForMailSending = meetsConditionForMailSending || stringValueOfField.containsIgnoreCase(expectedApproximateValue);
                    }
                }

                // Mail will be sent only if new value and match condition
                if(valueHasChanged && meetsConditionForMailSending){
                    conditionsThatRequireMailSending.add(conditions);
                }
            }
        }
        return conditionsThatRequireMailSending;
    }

    private static Boolean valueHasChanged(SObject oldValue, SObject newValue , String fieldName){
        return oldValue.get(fieldName) != newValue.get(fieldName);
    }

    private static String replaceValues(SObject relatedObject, String textToCompute, All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator config){                
        String textToReturn = textToCompute;
        
        // Record values
        Map<String , String> placeHolderToFielApiName = config.getFieldsReplacementMapping();
        for(String placeOlderInLabel : placeHolderToFielApiName.keySet()){
            String fieldName = placeHolderToFielApiName.get(placeOlderInLabel);
            Object fieldValue =  relatedObject.get(fieldName);
            if(fieldValue == null){
                continue;
            }
            // extract Value
            String fieldValueAsAString;
            if(fieldValue instanceof Date){
                Date dateFieldValue =  (Date) fieldValue;
                Integer d = dateFieldValue.day();
                Integer mo = dateFieldValue.month();
                Integer yr = dateFieldValue.year();
                DateTime dateAsADateTime = DateTime.newInstance(yr, mo, d);
                fieldValueAsAString = dateAsADateTime.format('d MMMM y');
            }
            else{
                fieldValueAsAString = fieldValue.toString();
            }
                
            textToReturn = textToReturn.replace(placeOlderInLabel, fieldValueAsAString);
        }

        // URL
        String url = URL.getSalesforceBaseUrl().toExternalForm()+'/' + relatedObject.Id;
        textToReturn = textToReturn.replace('{Link}',url);

        // Object Name
        String objectName = relatedObject.getSObjectType().getDescribe().getLabel();
        textToReturn = textToReturn.replace('{Object}',objectName);
        return textToReturn;
    }

    private static All_Objects_Workflow_Email_Notif_Conf.GenericEmailAlertConfigurator emailConfiguratorFactory(String objectType){
        if(objectType == Constants.CAPA_ACTION_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.Capa_Action_EmailAlertConfigurator();
        }
        if(objectType == Constants.CAPA_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.Capa_EmailAlertConfigurator();
        }
        if(objectType == Constants.CAUSE_INVESTIGATION_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.Cause_Investigation_EmailAlertConfigurator();
        }
        if(objectType == Constants.CORRECTION_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.Correction_EmailAlertConfigurator();
        }
        if(objectType == Constants.EXTENSION_REQUEST_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.Extension_Request_EmailAlertConfigurator();
        }
        if(objectType == Constants.RISK_FILE_REVIEW_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.RiskFileReview_EmailAlertConfigurator();
        }
        if(objectType == Constants.QMS_TASKS_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.QMS_Tasks_EmailAlertConfigurator();
        }
        if(objectType == Constants.ADDENDUM_API_NAME){
            return new All_Objects_Workflow_Email_Notif_Conf.Addendum_EmailAlertConfigurator();
        }
        return null;
    }
}