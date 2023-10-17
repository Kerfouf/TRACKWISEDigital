public class Schedule_BeforeDueEmailAlerts  extends Schedule_AbstractEmailAlert implements Schedulable {
    
    private static final List<String> OBJECT_API_NAMES_TO_PROCEED = new List<String>{
        Constants.QUALITY_EVENT_API_NAME,
        Constants.CAUSE_INVESTIGATION_API_NAME,
        Constants.CAPA_API_NAME,
        Constants.CAPA_ACTION_API_NAME,
        Constants.CORRECTION_API_NAME,
        Constants.QMS_TASKS_API_NAME
    };

    public void execute(SchedulableContext SC) {
        execute(); 
    }

    public override List<String> getObjectApiNames_To_Proceed(){
        return OBJECT_API_NAMES_TO_PROCEED;
    }

    public override All_Objects_Workflow_Email_Notif_Conf.SchedduledEmailAlertConfiguration configFactory(String apiName){
        if(apiName == Constants.QUALITY_EVENT_API_NAME){
            return new QualityEvent_BeforeDue();
        }
        if(apiName == Constants.CAUSE_INVESTIGATION_API_NAME){
            return new Cause_Investigation_BeforeDue();
        }
        if(apiName == Constants.CAPA_API_NAME){
            return new CAPA_BeforeDue();
        }
        if(apiName == Constants.CAPA_ACTION_API_NAME){
            return new CAPA_Action_BeforeDue();
        }
        if(apiName == Constants.CORRECTION_API_NAME){
            return new Correction_BeforeDue();
        }
        if(apiName == Constants.QMS_TASKS_API_NAME){
            return new QMS_Task_BeforeDue();
        }
        return null;
    }
 

    public abstract class AbstractBeforeDueAlertConfig extends All_Objects_Workflow_Email_Notif_Conf.SchedduledEmailAlertConfiguration{
        public virtual override String getWhereClause(){
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Evaluation\') AND Due_Date__c = NEXT_N_DAYS:7 AND Due_Date__c != NEXT_N_DAYS:6';
        }
        
        public virtual override List<EmailAlertConfigurator> getConfiguredConditions(){
            List<EmailAlertConfigurator> cListToReturn = new List<EmailAlertConfigurator>();
            EmailAlertConfigurator conf;


            conf = new EmailAlertConfigurator();
            conf.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_LATE;
            conf.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_DUE_SOON;
            conf.recipientFields = new List<String>{'OwnerId'};
            conf.REPLACEMENT_FIELDS.put('{DueDate}' , 'Due_Date__c');
            cListToReturn.add(conf);

            return cListToReturn;
        }
     }
    
    public class QualityEvent_BeforeDue extends AbstractBeforeDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.QUALITY_EVENT_API_NAME;
        }
    }

    public class Cause_Investigation_BeforeDue extends AbstractBeforeDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CAUSE_INVESTIGATION_API_NAME;
        }
    }

    public class CAPA_BeforeDue extends AbstractBeforeDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CAPA_API_NAME;
        }

        public virtual override String getWhereClause(){
            return 'WHERE CMPL123_WF_Status__c = \'Effectiveness Check\' AND Effectiveness_Check_Due_Date__c = NEXT_N_DAYS:7 AND Effectiveness_Check_Due_Date__c != NEXT_N_DAYS:6';
        }

        public virtual override List<EmailAlertConfigurator> getConfiguredConditions(){
            List<EmailAlertConfigurator> cListToReturn = new List<EmailAlertConfigurator>();
            EmailAlertConfigurator conf;


            conf = new EmailAlertConfigurator();
            conf.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_LATE;
            conf.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_DUE_SOON;
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


    public class CAPA_Action_BeforeDue extends AbstractBeforeDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CAPA_ACTION_API_NAME;
        }

        public virtual override List<EmailAlertConfigurator> getConfiguredConditions(){
            List<EmailAlertConfigurator> cListToReturn = new List<EmailAlertConfigurator>();
            EmailAlertConfigurator conf;


            conf = new EmailAlertConfigurator();
            conf.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_LATE;
            conf.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_DUE_SOON;
            conf.recipientFields = new List<String>{'Assigned_To__c'};
            conf.REPLACEMENT_FIELDS.put('{DueDate}' , 'Due_Date__c');
            cListToReturn.add(conf);

            return cListToReturn;
        }

        public virtual override String getWhereClause(){
            Date filterDate = Date.today().addDays(7);
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Implementation\') AND Due_Date__c = NEXT_N_DAYS:7 AND Due_Date__c != NEXT_N_DAYS:6';
        }
    }



    public class Correction_BeforeDue extends AbstractBeforeDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.CORRECTION_API_NAME;
        }

        public virtual override String getWhereClause(){
            Date filterDate = Date.today().addDays(7);
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Implementation\') AND Due_Date__c = NEXT_N_DAYS:7 AND Due_Date__c != NEXT_N_DAYS:6';
        }
    }

    public class QMS_Task_BeforeDue extends AbstractBeforeDueAlertConfig{
        public override String getObjectAPIName() {
            return Constants.QMS_TASKS_API_NAME;
        }

        public virtual override String getWhereClause(){
            Date filterDate = Date.today().addDays(7);
            return 'WHERE (CMPL123_WF_Status__c = \'Initiated\' OR CMPL123_WF_Status__c = \'Implementation\') AND Due_Date__c = NEXT_N_DAYS:7 AND Due_Date__c != NEXT_N_DAYS:6';
        }
    }

}