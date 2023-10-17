public with sharing class All_Objects_Workflow_Email_Notif_Conf {
    
    public enum COMPARISON_TYPE  {STRICT, CONTAINS}

    public with sharing abstract class GenericEmailAlertConfigurator {        

        public abstract List<WorkflowEmailAlertConfigurator> getConfiguredConditions();        
    }
    
    public virtual with sharing class EmailAlertConfigurator{

        public String EmailSubjectValue;
                
        public String EmailBodyLabelValue;

        public List<String> recipientFields;

        public Map<String , String> REPLACEMENT_FIELDS = new Map<String , String>{
            '{Name}' => 'Name',
            '{Title}' => 'Title__c',
            '{Action_Performed_By}' => 'WF_Action_Performed_By_Text__c',
            '{action}' => 'CMPL123_WF_Action__c'
        };

        /**Returns a Map of Stakeholder => Record field to be replaced by
         * You may override this method if for a specific object you need extra mapping
        */
        public virtual Map<String , String> getFieldsReplacementMapping(){
            return REPLACEMENT_FIELDS;
        }
    }

    public abstract class SchedduledEmailAlertConfiguration  {
        
        public String generateSOQLQuery(){
            String soql = 'SELECT ';
            
            // Append field names to extract users
            for (EmailAlertConfigurator conf : getConfiguredConditions()){
                for(String field : conf.recipientFields){                    
                    soql += field;
                    soql += ',';
                }
            }
            // Append field name for replacement
            Set<String> replacementFieldToIncludeInSelectClause = new Set<String>();
            for(EmailAlertConfigurator conf : getConfiguredConditions()){
                replacementFieldToIncludeInSelectClause.addAll(conf.getFieldsReplacementMapping().values());
            }

            for(String field : replacementFieldToIncludeInSelectClause){
                soql += field;
                soql += ',';
            }
            soql = soql.removeEnd(',');
            soql += ' FROM ';
            soql += getObjectAPIName();
            soql += ' '+ getWhereClause();
            return soql;
        }
        
        public abstract String getObjectAPIName();

        public abstract List<EmailAlertConfigurator> getConfiguredConditions();

        public abstract String getWhereClause();
    }

    
    public with sharing class WorkflowEmailAlertConfigurator extends EmailAlertConfigurator{

        public COMPARISON_TYPE comparisonToapply;

        public Map<String , List<String>> fieldToExpectedValues;
    }


    /***********************************BELOW IS THE CONFIGURATION OF EMAIL ALERTS**********************************************/

    public class Capa_Action_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();

            // Send actions for implementation
            WorkflowEmailAlertConfigurator conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'Assigned_To__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'Send Action(s) for Implementation' }
            };            
            toReturn.add(conditionToAdd);
            
            // Status changed to Approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'Additional_Approval_1_By__c', 'Additional_Approval_2_By__c','Additional_Approval_3_By__c','Additional_Approval_4_By__c','Additional_Approval_5_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Approval' }
            };            
            toReturn.add(conditionToAdd);


            // Status changed to QA Approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'QA_Approval_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Quality Approval' }
            };            
            toReturn.add(conditionToAdd);

            // Status changed to Reject
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'Assigned_To__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
            };            
            toReturn.add(conditionToAdd);
            
            return toReturn;
        }
    }

    public class Capa_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;

            // Initiation complete
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                'CMPL123_WF_Action__c' =>  new List<String>{'Initiation Complete' }
            };            
            toReturn.add(conditionToAdd);


             // Sent approval
             conditionToAdd = new WorkflowEmailAlertConfigurator();
             conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
             conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
             conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
             conditionToAdd.recipientFields = new List<String>{'Additional_Approval_1_By__c', 'Additional_Approval_2_By__c','Additional_Approval_3_By__c','Additional_Approval_4_By__c', 'Lead_Auditor_Approval_By__c'};
             conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Approval' }
             };            
             toReturn.add(conditionToAdd);

             // Status changed to QA Approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'QA_Approval_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Quality Approval' }
            };            
            toReturn.add(conditionToAdd);


            // Send to Effectiveness Check
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'Effectiveness_Check_Owner__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'Send to Effectiveness Check' }
            };            
            toReturn.add(conditionToAdd);

            // Send to Effectiveness Check
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'QA_E_Check_Approval_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Effectiveness Check Approval' }
            };            
            toReturn.add(conditionToAdd);


            // Status changed to Reject
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
            };
            toReturn.add(conditionToAdd);

            return toReturn;
        }
    }


    public class Cause_Investigation_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;
            // IMPLEMENTED WITH FLOWS

            return toReturn;
        }
    }

    public class Correction_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;

             // Initiation complete
             conditionToAdd = new WorkflowEmailAlertConfigurator();
             conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
             conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
             conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
             conditionToAdd.recipientFields = new List<String>{'OwnerId'};
             conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'Initiation Complete'}
             };            
             toReturn.add(conditionToAdd);

             // Sent approval
             conditionToAdd = new WorkflowEmailAlertConfigurator();
             conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
             conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
             conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
             conditionToAdd.recipientFields = new List<String>{'Additional_Approval_1_By__c', 'Additional_Approval_2_By__c','Additional_Approval_3_By__c','Additional_Approval_4_By__c','Additional_Approval_5_By__c'};
             conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Approval'}
             };            
             toReturn.add(conditionToAdd);

             // Status changed to QA Approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'QA_Approval_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Quality Approval'}
            };
            toReturn.add(conditionToAdd);

            // Status changed to Reject
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
            };            
            toReturn.add(conditionToAdd);            

            return toReturn;
        }
    }

    public class Extension_Request_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;

            // Sent approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'Additional_Approval_1_By__c', 'Additional_Approval_2_By__c','Additional_Approval_3_By__c','Additional_Approval_4_By__c','Additional_Approval_5_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Approval' }
            };            
            toReturn.add(conditionToAdd);

            // Status changed to QA Approval
           conditionToAdd = new WorkflowEmailAlertConfigurator();
           conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
           conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
           conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
           conditionToAdd.recipientFields = new List<String>{'QA_Approval_By__c'};
           conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'QA Approval'}
           };
           toReturn.add(conditionToAdd);

           // Status changed to Reject
           conditionToAdd = new WorkflowEmailAlertConfigurator();
           conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
           conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
           conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
           conditionToAdd.recipientFields = new List<String>{'OwnerId'};
           conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
           };            
           toReturn.add(conditionToAdd);


           return toReturn;
        }
    }

    public class RiskFileReview_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;
            
            // Initiation complete
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'Initiation Complete'}
            }; 
            toReturn.add(conditionToAdd);
            
            // Sent approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'Additional_Approval_1_By__c', 'Additional_Approval_2_By__c','Additional_Approval_3_By__c','Additional_Approval_4_By__c','Additional_Approval_5_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Approval'}
            };            
            toReturn.add(conditionToAdd);


            // Status changed to QA Approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'QA_Approval_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Quality Approval'}
            };
            toReturn.add(conditionToAdd);

             // Status changed to Reject
             conditionToAdd = new WorkflowEmailAlertConfigurator();
             conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
             conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
             conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
             conditionToAdd.recipientFields = new List<String>{'OwnerId'};
             conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
            };            
            toReturn.add(conditionToAdd);
            

             return toReturn;
        }
    }

    public class QMS_Tasks_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;

            // Initiation complete
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'Initiation Complete'}
            }; 
            toReturn.add(conditionToAdd);

            // Sent approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'Additional_Approval_1_By__c', 'Additional_Approval_2_By__c','Additional_Approval_3_By__c','Additional_Approval_4_By__c','Additional_Approval_5_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'Approval' }
            };            
            toReturn.add(conditionToAdd);

            // Status changed to QA Approval
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.STRICT;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_APPROVAL;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_APPROVAL;
            conditionToAdd.recipientFields = new List<String>{'QA_Approval_By__c'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Status__c' =>  new List<String>{'QA Approval' }
            };
            toReturn.add(conditionToAdd);

            // Status changed to Reject
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
            };           
            toReturn.add(conditionToAdd);


            return toReturn;
        }
    }

    public class Addendum_EmailAlertConfigurator extends GenericEmailAlertConfigurator{
        public override List<WorkflowEmailAlertConfigurator> getConfiguredConditions(){
            List<WorkflowEmailAlertConfigurator> toReturn = new List<WorkflowEmailAlertConfigurator>();
            WorkflowEmailAlertConfigurator conditionToAdd;

            // Status changed to Reject
            conditionToAdd = new WorkflowEmailAlertConfigurator();
            conditionToAdd.comparisonToapply = COMPARISON_TYPE.CONTAINS;
            conditionToAdd.EmailBodyLabelValue = Label.LABEL_EMAIL_TPL_ACTION_PERF;
            conditionToAdd.EmailSubjectValue = Label.LABEL_EMAIL_SUBJECT_ACTION_PERFORMED;
            conditionToAdd.recipientFields = new List<String>{'OwnerId'};
            conditionToAdd.fieldToExpectedValues = new Map<String , List<String>>{
                 'CMPL123_WF_Action__c' =>  new List<String>{'reject','reopen','return','revise'}
            };             
            toReturn.add(conditionToAdd);

            return toReturn;
        }
    }
}