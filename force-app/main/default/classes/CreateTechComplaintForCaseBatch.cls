global class CreateTechComplaintForCaseBatch implements Database.Batchable <sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //String query='SELECT Id,BMX_Case_External__r.Type__c,BMX_Case_External__r.Status__c,BMX_Investigation__c FROM CMPL123CME__Complaint__c WHERE BMX_CaseNumber__c != null AND (NOT CMPL123CME__CMPL123_WF_Status__c Like \'Closed%\') ';
        String query='SELECT Id,ExternalId,TWComplaintNumber_c__c,TWComplaintState_c__c,Type__c,CaseNumber__c FROM Case__x WHERE TWComplaintNumber_c__c!=NULL AND Type__c!=\'TechnicalComplaint\' AND TWComplaintNumber_c__c Like \'%CN%\' AND LastModifiedDate__c = TODAY';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Case__x> scope ) {
        performBatchActions(scope);

    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
    @TestVisible
    private void performBatchActions(Case__x[] scope){
		//List<CMPL123CME__Investigation__c> investigationList = new list<CMPL123CME__Investigation__c>();
        System.debug('Scope info:::MS::'+scope.size());
        
        List<CMPL123CME__Complaint__c> cmpListUpdate= new List<CMPL123CME__Complaint__c>();
        Set<Id> CaseSetIds=new Set<Id>();
        for(Case__x caids:scope){
             CaseSetIds.add(caids.ExternalId);
        }
        for(CMPL123CME__Complaint__c cmp:[SELECT Id,BMX_Case_External__c,CMPL123CME__CMPL123_WF_Status__c,CMPL123Task_Key_Value__c,BMX_Case_External__r.Type__c,BMX_Case_External__r.Status__c FROM CMPL123CME__Complaint__c WHERE BMX_Case_External__c IN:CaseSetIds AND CMPL123CME__CMPL123_WF_Status__c!='Closed - Canceled']){
                                             
            if(cmp.CMPL123CME__CMPL123_WF_Status__c=='Opened'){
                cmp.CMPL123Task_Key_Value__c='CANCELOPENCOMPLAINT';
            }
            cmp.CMPL123CME__CMPL123_WF_Status__c='Closed - Canceled'; 
            cmp.BMX_Case_Type__c=cmp.BMX_Case_External__r.Type__c;
            cmpListUpdate.add(cmp);
        }
        System.debug('Complents List:::MS::'+cmpListUpdate.size());
        if(!cmpListUpdate.isEmpty()){
            Database.update(cmpListUpdate,false);           
            
        }
    }
    
}