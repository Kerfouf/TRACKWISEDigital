public with sharing class Constants {
    
    /******************************* USERS **********************************/
    public static final String TWD_ROLE_QE_CAPA_PARTICIPANT = 'QE/CAPA Participant';

    public static final String TWD_ROLE_QE_CAPA_COORDINATOR = 'QE/CAPA Coordinator';

    public static final String BMX_TWD_USER_PROFILE_NAME = 'BMX TWD User';

    /******************************* CAPA **********************************/

    public static final String CAPA_WF_ACTION_CANCEL = 'Cancel';
    
    public static final String CAPA_STATUS_ACTIONS_IMPLEMENTATION = 'Actions Implementation';
    
    public static final String CAPA_STATUS_APPROVAL = 'Approval';

    public static final String CAPA_STATUS_QUALITY_APPROVAL = 'Quality Approval';
    
    public static final List<String> CAPA_APPROVAL_STATUSES_LIST = new List<String>{CAPA_STATUS_APPROVAL, CAPA_STATUS_QUALITY_APPROVAL};

    
    /** QUALITY EVENT*/

    public static final String QUALITY_EVENT_STATUS_PENDING_CLOSURE = 'Pending Closure';


    /** CAUSE INVESTIGATION*/
    public static final String CAUSE_INVESTIGATION_STATUS_PENDING_CLOSURE = 'Pending Closure';

    /**CAPA ACTIONS**/

    

    public static final String CAPA_ACTION_STATUS_CANCELED = 'Canceled';

    public static final String CAPA_ACTION_STATUS_INITIATED = 'Initiated';


    /* objects type*/
    public static final String QUALITY_EVENT_API_NAME = 'Quality_Event__c';
    public static final String CAUSE_INVESTIGATION_API_NAME = 'Cause_Investigation__c';
    public static final String CAPA_API_NAME = 'CMPL123QMS__CAPA__c';
    public static final String CAPA_ACTION_API_NAME = 'CAPA_Action__c';
    public static final String CORRECTION_API_NAME = 'Correction__c';
    public static final String EXTENSION_REQUEST_API_NAME = 'Extension_Request__c';
    public static final String RISK_FILE_REVIEW_API_NAME = 'Risk_File_Review__c';
    public static final String QMS_TASKS_API_NAME = 'QMS_Task__c';
    public static final String ADDENDUM_API_NAME = 'Addendum__c';
    
}