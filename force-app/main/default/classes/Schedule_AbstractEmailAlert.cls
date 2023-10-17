public abstract class Schedule_AbstractEmailAlert {
    
    public void execute() {

        List<Messaging.SingleEmailMessage> mailsToSendList = new  List<Messaging.SingleEmailMessage>();

        for(String objectAPIName : getObjectApiNames_To_Proceed()){
            All_Objects_Workflow_Email_Notif_Conf.SchedduledEmailAlertConfiguration config = configFactory(objectAPIName);
            String soqlQUERY = config.generateSOQLQuery();
            System.debug('Query to be performed: ' + soqlQUERY);
            List<sObject> sobjList = Database.query(soqlQUERY);

            for(sObject loopObject : sobjList) {
                for (All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator conf : config.getConfiguredConditions()){
                    Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator> setOfConfig = new Set<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator>{conf};
                    Map<All_Objects_Workflow_Email_Notif_Conf.EmailAlertConfigurator , Set<Id>> configToListOfUserIds = GenericEmailAlertHelper.extractMapOfConfigToListOfUsers(loopObject, setOfConfig);
                    if(configToListOfUserIds == null || configToListOfUserIds.isEmpty()){
                        continue;
                    }
                    List<Messaging.SingleEmailMessage> loopMailsToSend = GenericEmailAlertHelper.sendEmails(loopObject, configToListOfUserIds);
                    mailsToSendList.addAll(loopMailsToSend);
                }
                
            }
        }
        try{
            System.debug('Count of Email that will be sent: ' + mailsToSendList.size());
            Messaging.sendEmail(mailsToSendList, false);
        }
        catch(Exception e){
            System.debug('The Send of the emails failed');
        }
    }

    public abstract List<String> getObjectApiNames_To_Proceed();

    public abstract All_Objects_Workflow_Email_Notif_Conf.SchedduledEmailAlertConfiguration configFactory(String objectAPIName);

}