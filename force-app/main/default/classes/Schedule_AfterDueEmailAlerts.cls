public with sharing class Schedule_AfterDueEmailAlerts extends Schedule_AbstractEmailAlert implements Schedulable {

    private static final List<String> OBJECT_API_NAMES_TO_PROCEED = new List<String>{
                                                                                        Constants.QUALITY_EVENT_API_NAME,
                                                                                        Constants.CAUSE_INVESTIGATION_API_NAME,
                                                                                        Constants.CAPA_API_NAME,
                                                                                        Constants.CAPA_ACTION_API_NAME,
                                                                                        Constants.CORRECTION_API_NAME,
                                                                                        Constants.QMS_TASKS_API_NAME
                                                                                    };

    public override List<String> getObjectApiNames_To_Proceed(){
        return OBJECT_API_NAMES_TO_PROCEED;
    }


    public void execute(SchedulableContext SC) {
        execute();
    }

    public override All_Objects_Workflow_Email_Notif_Conf.SchedduledEmailAlertConfiguration configFactory(String apiName){
        if(apiName == Constants.QUALITY_EVENT_API_NAME){
            return new QualityEvent_AfterDue();
        }
        if(apiName == Constants.CAUSE_INVESTIGATION_API_NAME){
            return new Cause_Investigation_AfterDue();
        }
        if(apiName == Constants.CAPA_API_NAME){
            return new CAPA_AfterDue();
        }
        if(apiName == Constants.CAPA_ACTION_API_NAME){
            return new CAPA_Action_AfterDue();
        }
        if(apiName == Constants.CORRECTION_API_NAME){
            return new Correction_AfterDue();
        }
        if(apiName == Constants.QMS_TASKS_API_NAME){
            return new QMS_Task_AfterDue();
        }
        return null;
    }
 

    public abstract class AbstractAfterDueAlertConfig extends All_Objects_Workflow_Email_Notif_Conf.SchedduledEmailAlertConfiguration{
        public virtual override String getWhereClause(){
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Evaluation\') AND Due_Date__c < TODAY';
        }
        
        public virtual override List<EmailAlertConfigurator> getConfiguredConditions(){
            List<EmailAlertConfigurator> cListToReturn = new List<EmailAlertConfigurator>();
            EmailAlertConfigurator conf;


            conf = new EmailAlertConfigurator();
            conf.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_OVERDUE;
            conf.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_DUE_LATE;
            conf.recipientFields = new List<String>{'OwnerId'};
            conf.REPLACEMENT_FIELDS.put('{DueDate}' , 'Due_Date__c');
            cListToReturn.add(conf);

            return cListToReturn;
        }
     }
    
    public class QualityEvent_AfterDue extends AbstractAfterDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.QUALITY_EVENT_API_NAME;
        }
    }

    public class Cause_Investigation_AfterDue extends AbstractAfterDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CAUSE_INVESTIGATION_API_NAME;
        }
    }

    public class CAPA_AfterDue extends AbstractAfterDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CAPA_API_NAME;
        }

        public virtual override String getWhereClause(){
            return 'WHERE CMPL123_WF_Status__c = \'Effectiveness Check\' AND Effectiveness_Check_Due_Date__c < TODAY';
        }

        public virtual override List<EmailAlertConfigurator> getConfiguredConditions(){
            List<EmailAlertConfigurator> cListToReturn = new List<EmailAlertConfigurator>();
            EmailAlertConfigurator conf;


            conf = new EmailAlertConfigurator();
            conf.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_OVERDUE;
            conf.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_DUE_LATE;
            conf.recipientFields = new List<String>{'Effectiveness_Check_Owner__c'};
            conf.REPLACEMENT_FIELDS = new Map<String , String>{
                '{Name}' => 'Name',
                '{Title}' => 'Title__c',
                '{Action_Performed_By}' => 'WF_Action_Performed_By_Text__c',
                '{action}' => 'CMPL123_WF_Action__c',
                '{DueDate}' => 'Effectiveness_Check_Due_Date__c'
            };
            cListToReturn.add(conf);

            return cListToReturn;
        }       
    }


    public class CAPA_Action_AfterDue extends AbstractAfterDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CAPA_ACTION_API_NAME;
        }

        public virtual override List<EmailAlertConfigurator> getConfiguredConditions(){
            List<EmailAlertConfigurator> cListToReturn = new List<EmailAlertConfigurator>();
            EmailAlertConfigurator conf;


            conf = new EmailAlertConfigurator();
            conf.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_OVERDUE;
            conf.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_DUE_LATE;
            conf.recipientFields = new List<String>{'Assigned_To__c'};
            conf.REPLACEMENT_FIELDS.put('{DueDate}' , 'Due_Date__c');
            cListToReturn.add(conf);

            return cListToReturn;
        }

        public virtual override String getWhereClause(){
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Implementation\') AND Due_Date__c < TODAY';
        }
    }



    public class Correction_AfterDue extends AbstractAfterDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CORRECTION_API_NAME;
        }

        public virtual override String getWhereClause(){
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Implementation\') AND Due_Date__c < TODAY';
        }
    }

    public class QMS_Task_AfterDue extends AbstractAfterDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.QMS_TASKS_API_NAME;
        }

        public virtual override String getWhereClause(){
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Implementation\') AND Due_Date__c < TODAY';
        }
    }
}