public class QualityAuditCheckFindings {
        
     public static void QauditBeforeUpdate(Map<Id, BMX_Quality_Audit__c> oldQualityAudit, Map<Id, BMX_Quality_Audit__c> newQualityAudit){
        Set<Id> setAuditId = new Set<Id>();
        Id externalIdRecordType = Schema.SObjectType.BMX_Quality_Audit__c.getRecordTypeInfosByDeveloperName().get(Label.External_Record_Type).getRecordTypeId();
         For(BMX_Quality_Audit__c Qaudit : newQualityAudit.values()){
            if((oldQualityAudit.get(Qaudit.Id).CMPL123_WF_Action__c != Label.WF_Action_Report_Ready_Approval && Qaudit.CMPL123_WF_Action__c==Label.WF_Action_Report_Ready_Approval)
                && Qaudit.RecordTypeId == externalIdRecordType){
                setAuditId.add(Qaudit.Id);
            }
        }
        System.debug('setAuditId : ' + setAuditId);
        checkFindings(setAuditId,newQualityAudit.values());
        }
     
  public static void checkFindings(Set<Id> setQualityAuditId, list<BMX_Quality_Audit__c>newQualityAuditValues) {
   List<Audit_Finding__c> listFindingsBlankFields = new List<Audit_Finding__c>(); 
   List<String> findingNames = new List<String>();
   List<Audit_Finding__c> listRelatedFindings = [SELECT Id,Name,Parent_Audit__c,Distributor_Finding_Category__c, 
                                                 Scope__c, Action_Plan_Definition_Due_Date__c,Recordtype.Name 
                                                 FROM Audit_Finding__c 
                                                 WHERE Parent_Audit__c IN: setQualityAuditId
                                                 AND Recordtype.Name =: Label.External_Record_Type
                                                 ];
 
   IF(listRelatedFindings.size()>0){
     for(Audit_Finding__c finding : listRelatedFindings){
        if(finding.Action_Plan_Definition_Due_Date__c==null){   
          listFindingsBlankFields.add(finding);
            }
          if (finding.Scope__c== Label.Scope_Distributor_Value && String.isBlank(finding.Distributor_Finding_Category__c)){
              listFindingsBlankFields.add(finding);
         }
     }
   }
      If(listFindingsBlankFields.size() > 0){
            for(Audit_Finding__c find : listFindingsBlankFields){
                findingNames.add(find.Name);
            }
          newQualityAuditValues[0].addError(Label.error_Message_Mandatory_Fields_In_Finding+'\n'+'for Audit Findings:' + findingNames); 
        }
         
     }        
}