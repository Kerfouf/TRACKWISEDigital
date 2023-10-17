public with sharing class QualityAuditsMoveAuditsScheduleHelper {
    public static final String  TASK_VALUE_INTERNAL = 'MoveAuditScheduleToExecutedInternal';
    public static final String  TASK_VALUE_EXTERNAL = 'MoveAuditScheduleToExecutedExternal';
    
     public static void qualityAuditStatusChange(Map<Id, BMX_Quality_Audit__c> oldQualityAudit, Map<Id, BMX_Quality_Audit__c> newQualityAudit){        
        Set<Id> setIdQAuditSch = new Set<Id>();
       
        For(BMX_Quality_Audit__c qAud : newQualityAudit.values()){
            if((oldQualityAudit.get(qAud.Id).CMPL123_WF_Status__c != Label.Status_Report_Approved && qAud.CMPL123_WF_Status__c == Label.Status_Report_Approved)||
               (oldQualityAudit.get(qAud.Id).CMPL123_WF_Status__c != Label.Status_Closed_Cancelled && qAud.CMPL123_WF_Status__c == Label.Status_Closed_Cancelled)||
               (oldQualityAudit.get(qAud.Id).CMPL123_WF_Status__c != Label.Status_Closed_Done && qAud.CMPL123_WF_Status__c == Label.Status_Closed_Done)
              ){                 
                setIdQAuditSch.add(qAud.Audit_Schedule__c);
            }
        }
        System.debug('setIdQAuditSch : ' + setIdQAuditSch);
        moveAuditSchedule(setIdQAuditSch);

    }

    public static void moveAuditSchedule(Set<Id> IdSetQAudit_Schedule) {
   
    Map<Id,List<BMX_Quality_Audit__c>> mapAuditScheIdToListQAudit = new Map<Id,List<BMX_Quality_Audit__c>>(); 
    Map<Id,List<BMX_Quality_Audit__c>> mapIdToListQAuditTrue = new Map<Id,List<BMX_Quality_Audit__c>>();
    List<Id> listIdScheduleTrue = new List<Id>();
    List<BMX_Audits_Schedule__c> listSchedToUpdate = new List <BMX_Audits_Schedule__c>();
    
    
    //Get Parent Audit Schedule From IdSetQAudit_Schedule
    List<BMX_Audits_Schedule__c> listParentQAudit = [SELECT Id,RecordType.DeveloperName,CMPL123Task_Key_Value__c,CMPL123_WF_Status__c 
                                                     FROM BMX_Audits_Schedule__c 
                                                     WHERE Id IN:IdSetQAudit_Schedule];

    List<BMX_Quality_Audit__c> listAuditsInParent = [SELECT Id,Audit_Schedule__c,RecordType.DeveloperName,CMPL123_WF_Status__c,CMPL123Task_Key_Value__c 
                                                     FROM BMX_Quality_Audit__c 
                                                     WHERE Audit_Schedule__c IN:listParentQAudit];
 

   For(BMX_Quality_Audit__c qAudit : listAuditsInParent){
     If(!mapAuditScheIdToListQAudit.containsKey(qAudit.Audit_Schedule__c)){
        mapAuditScheIdToListQAudit.put(qAudit.Audit_Schedule__c,new List<BMX_Quality_Audit__c>());
     }
     mapAuditScheIdToListQAudit.get(qAudit.Audit_Schedule__c).add(qAudit);

   }
	 System.debug('mapAuditScheIdToListQAudit : ' + mapAuditScheIdToListQAudit);
  
  Integer count = 1; //For Triggered Audit already in status
   IF(!mapAuditScheIdToListQAudit.isEmpty()){      
     for(Id auditScheId : mapAuditScheIdToListQAudit.keySet()){
        for(BMX_Quality_Audit__c qAud : mapAuditScheIdToListQAudit.get(auditScheId)){
            if(qAud.CMPL123_WF_Status__c == Label.Status_Report_Approved || qAud.CMPL123_WF_Status__c == Label.Status_Closed_Cancelled ||  
                qAud.CMPL123_WF_Status__c == Label.Status_Closed_Done){ 
                  count ++;
               }             
       }
                  
       If(count == mapAuditScheIdToListQAudit.get(auditScheId).size()){
           listIdScheduleTrue.add(auditScheId);
       }
       
    If(listIdScheduleTrue.size()>0){  
     System.debug('IN IF IdSchedTrue');
     for(BMX_Audits_Schedule__c audSch : listParentQAudit){  
       if(audSch.RecordType.DeveloperName == Label.Internal_Record_Type && 
              audSch.CMPL123_WF_Status__c == Label.Status_Audit_Schedule_Implementation){
         	 	audSch.CMPL123Task_Key_Value__c = TASK_VALUE_INTERNAL;
       }
       else if(audSch.RecordType.DeveloperName == Label.External_Record_Type && 
               	   audSch.CMPL123_WF_Status__c == Label.Status_Audit_Schedule_Implementation){
          			 audSch.CMPL123Task_Key_Value__c = TASK_VALUE_EXTERNAL;
       }
       listSchedToUpdate.add(audSch);
     }
     }                         
   }
 }  
   System.debug('listSchedToUpdate : ' + listSchedToUpdate);
        
   If (listSchedToUpdate.size()>0){
       update listSchedToUpdate;
    }
        

  }

}