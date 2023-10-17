public class Investchildupdate 
{   

    /**Wrapper for the child update called from a Process Builder*/
    public class InvestWrapper{
        @InvocableVariable
        public Id ParentId;
    }

    /**Method called from a Process Builder*/
    @InvocableMethod
    public static void doProcessActions(List<InvestWrapper> InvestList) 
    {
        //BatchInvestChildupdate.execute(InvestList);
    }
    

    /* Update the children base on parent */
    public static void updateChidrenFields(Map<Id, CMPL123CME__Investigation__c> newRecords){
        if(System.isBatch() || System.isQueueable()){
            return;
        }
        UpdateChildInvestigationJob job = new UpdateChildInvestigationJob(newRecords);
        Database.executeBatch(job);
    }

    /**Send the mail depending on status */
    public static void sendMailsIfNeeded(Map<Id, CMPL123CME__Investigation__c> oldRecords , Map<Id, CMPL123CME__Investigation__c> newRecords){
        if(System.isQueueable()){
            return;
        }
        Set<Id> closedDoneRecords = new Set<Id>();
        for(Id investId : newRecords.keySet()){
            CMPL123CME__Investigation__c newLoopInvest = newRecords.get(investId);
            CMPL123CME__Investigation__c oldLoopInvest = oldRecords.get(investId);

            Boolean statusChanged = oldLoopInvest.CMPL123_WF_Status__c != newLoopInvest.CMPL123_WF_Status__c;
            Boolean statusIsClosed = newLoopInvest.CMPL123_WF_Status__c == 'Closed - Done' || newLoopInvest.CMPL123_WF_Status__c == 'Closed - Canceled';
            Boolean sendMail = statusChanged && statusIsClosed;
            
            if(sendMail){
                closedDoneRecords.add(investId);
            }
        }
        if(!Helper.isEmpty(closedDoneRecords)){
            Queueable job = new SendTaskMails(closedDoneRecords);
            System.enqueueJob(job);
        }
        
    }

    public class SendTaskMails implements Queueable{
        private Set<Id> newRecords;
        
        public SendTaskMails(Set<Id> newRecords){
            this.newRecords = newRecords;
        }


        public void execute(QueueableContext context){

            EmailTemplate emailTemplate =   [SELECT
                                                Id
                                            FROM
                                                EmailTemplate
                                            WHERE
                                                Name = 'Close_Invest_NOTIF_TPL'
            ];

            List<Messaging.SingleEmailMessage> mailsToSendList = new List<Messaging.SingleEmailMessage>();
            
            for(Task relatedTask : [SELECT OwnerId, WhatId FROM Task WHERE WhatId IN : newRecords]){
                Messaging.SingleEmailMessage emailToSend = Messaging.renderStoredEmailTemplate(emailTemplate.Id, relatedTask.OwnerId , relatedTask.WhatId);
                emailToSend.setSenderDisplayName('bioMerieux TWD');
                emailToSend.setReplyTo('no-reply@no-reply.biomerieux.com');
                emailToSend.setUseSignature(false);
                emailToSend.setBccSender(false);
                emailToSend.setSaveAsActivity(false);
                mailsToSendList.add(emailToSend);
            }
            Messaging.sendEmail(mailsToSendList, false);
        }
    }
}