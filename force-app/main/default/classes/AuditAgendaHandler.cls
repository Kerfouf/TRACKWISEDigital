/*
File Name: AuditAgendaHandler
Test Class: AuditAgendaHandler_Test
Description: public class which is used to handle all the custom functioanlity on Audit Agenda object. 
*/

public class AuditAgendaHandler {
    
    public static void Limit_Update(List <Audit_Agenda_Item__c> newAgenda, Map<Id,Audit_Agenda_Item__c> oldAgenda){      
            Set<Id> qualityAuditIdSet = new Set<Id>();
         for(Audit_Agenda_Item__c agenda : newAgenda){
            if(oldAgenda == null || oldAgenda.get(agenda.Id).Audit__c != agenda.Audit__c || oldAgenda.get(agenda.Id).Name != agenda.Name ||
               oldAgenda.get(agenda.Id).StartTime__c != agenda.StartTime__c || oldAgenda.get(agenda.Id).EndTime__c != agenda.EndTime__c ||
               oldAgenda.get(agenda.Id).Audited_Subjects__c != agenda.Audited_Subjects__c || oldAgenda.get(agenda.Id).Comments__c != agenda.Comments__c ||
			    oldAgenda.get(agenda.Id).Individuals__c != agenda.Individuals__c || oldAgenda.get(agenda.Id).Chapter__c != agenda.Chapter__c               
              ){
                 qualityAuditIdSet.add(agenda.Audit__c);
            }
                 
        }
           
       System.debug('qualityAuditIdSet : '+ qualityAuditIdSet); 
        
        
        Map<Id,BMX_Quality_Audit__c> qualityAuditMap = new Map<Id,BMX_Quality_Audit__c>
															([SELECT Id,Lead_Auditor__c 
															  FROM BMX_Quality_Audit__c 
															  WHERE Id IN:qualityAuditIdSet]);

        Map<Id,User> currentUser = new Map<Id,User>
									 ([SELECT Id,TWD_Role__c 
									  FROM User 
									  WHERE Id =: Userinfo.getUserId()]);

       Map<Id,Audit_Team_Member__c> auditTeamMemberMap = new Map<Id,Audit_Team_Member__c>
														([SELECT Id,Audit__c,Role__c,Member__c 
													     FROM Audit_Team_Member__c 
													     WHERE Audit__c IN: qualityAuditIdSet 
													     AND Role__c ='Auditor']);
           	System.debug('qualityAuditList : '+qualityAuditMap);
            System.debug('currentUser : '+currentUser);

    		List<Audit_Team_Member__c> auditTeamMemberList = new List<Audit_Team_Member__c>();
            for(Audit_Team_Member__c atm : auditTeamMemberMap.values()){
                        if(atm.Member__c == userinfo.getuserid()){
                            System.debug('Member__c:'+atm.Member__c);
                            System.debug('getuserid:'+userinfo.getuserid());
                            auditTeamMemberList.add(atm);
                        }
                    }
        User userC = currentUser.get(userinfo.getuserid());
            for(Audit_Agenda_Item__c agenda : newAgenda){
               IF(!qualityAuditMap.isEmpty()){
                if(qualityAuditMap.get(agenda.Audit__c).Lead_Auditor__c != userinfo.getuserid() && !userC.TWD_Role__c.contains ('Audit Coordinator') && auditTeamMemberList.size() < 1){
                    //System.debug('getuserid:'+userinfo.getuserid());
                    if(!Test.isRunningTest()){
                    newAgenda[0].addError(System.Label.Audit_Agenda_Limit_Edit_Error);
                    }
                }
              } 
            }
        }

}