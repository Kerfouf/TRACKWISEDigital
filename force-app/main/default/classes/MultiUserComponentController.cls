public with sharing class MultiUserComponentController {
    
    @AuraEnabled(cacheable=true)
    public static List<User> retrieveFullListOfUsers(String filterTerm, List<Id> alreadySelectedUsers){
        String filterParam = filterTerm + '%';        
        List<User> listToReturn = [SELECT 
                                        Id,
                                        Name
                                   FROM
                                        User
                                   WHERE
                                        (
                                        FirstName LIKE :filterParam
                                        OR
                                        LastName LIKE :filterParam
                                        OR
                                        Id IN :alreadySelectedUsers
                                        )
                                        AND
                                        TWD_Role__c INCLUDES (:Constants.TWD_ROLE_QE_CAPA_PARTICIPANT)
                                        AND
                                        IsActive = true
                                    ORDER BY
                                        Name asc
                                    ];
        return listToReturn;
    }

    @AuraEnabled(cacheable=true)
    public static List<User> retrieveAlreadySelectedUsers(String currentTargetObject, Id currentTargetObjectRecordId){
        JunctionObjectManager manager = junctionObjectManagerFactory(currentTargetObject);
        return manager.retrieveListOfAlreadySelectedUsers(currentTargetObjectRecordId);
    }

    @AuraEnabled
    public static void deleteRecords(String currentTargetObject, Id currentTargetObjectRecordId,  List<Id> listOfRemovedUsers){
        JunctionObjectManager manager = junctionObjectManagerFactory(currentTargetObject);
        manager.deleteRecords(currentTargetObjectRecordId, listOfRemovedUsers);
    }

    @AuraEnabled
    public static void createRecords(String currentTargetObject, Id currentTargetObjectRecordId,  List<Id> listOfCreatedUsers){
        JunctionObjectManager manager = junctionObjectManagerFactory(currentTargetObject);
        manager.createRecords(currentTargetObjectRecordId, listOfCreatedUsers);
    }

    @AuraEnabled(cacheable = false)
    public static Boolean isComponentNeedToBeLocked(String currentTargetObject, Id currentTargetObjectRecordId){
        JunctionObjectManager manager = junctionObjectManagerFactory(currentTargetObject);
        return manager.isReadOnly(currentTargetObjectRecordId, currentTargetObject);
    }

    private static JunctionObjectManager junctionObjectManagerFactory(String currentTargetObject){
        JunctionObjectManager manager = null;
        if(currentTargetObject == 'Quality_Event__c'){
            manager = new QualityEventContributorsManager();
        }
        if(currentTargetObject == 'Cause_Investigation__c'){
            manager = new CauseInvestigationContributorsManager();
        }

        // For other junction objects, add here the Manager implementation you have created bu Overrinding the JunctionObjectManager class

        return manager;
    }

    

    /**
     * 
     * This is an abstraction to manipulate the Junction objects between users and other objects
     * 
    */
    public abstract class JunctionObjectManager{
        public void deleteRecords(Id currentTargetObjectRecordId,  List<Id> listOfRemovedUsers){
            List<Sobject> objectsToDelete = retieveListOfObjectsToDelete(currentTargetObjectRecordId, listOfRemovedUsers);
            delete objectsToDelete;
        }
        public abstract List<Sobject> retieveListOfObjectsToDelete(Id currentTargetObjectRecordId,  List<Id> listOfCreatedUsers);


        public void createRecords(Id currentTargetObjectRecordId,  List<Id> listOfCreatedUsers){
            List<SObject> objectsToCreate = new List<SObject>();
            for(Id loopUserId : listOfCreatedUsers){
                SObject objectToAddInList = createObject(currentTargetObjectRecordId, loopUserId);
                objectsToCreate.add(objectToAddInList);
            }
            insert objectsToCreate;
        }

        public Boolean isReadOnly(Id currentObjectId , String objectApiName){
            String status = retrieveMasterObjectCurrentStatus(currentObjectId);
            return lockedInMasterObjectSteps(objectApiName , status);
        }

        private Boolean lockedInMasterObjectSteps(String objectApiName , String currentStatus){
            // Get the steps

            // Filter by the rule (must me the one for the current target object ID and active)
            // Filter by the name
            
            List<CMPL123__WF_Step__c> steps = [
                                                SELECT
                                                    Id,
                                                    CMPL123__Is_Related_Lists_Locked__c,
                                                    CMPL123__Object_Related_List_Relationship__c
                                                FROM
                                                    CMPL123__WF_Step__c
                                                WHERE
                                                    CMPL123__WF_Rule__r.CMPL123__Target_Object__c = :objectApiName
                                                    AND
                                                    CMPL123__WF_Rule__r.CMPL123__Is_Active__c = true
                                                    AND
                                                    CMPL123__End_Status__r.Name = :currentStatus
            ];
            for(CMPL123__WF_Step__c loopStep : steps){
                Boolean allChildrenAreLocked = loopStep.CMPL123__Is_Related_Lists_Locked__c;
                Boolean currentObjectIsPartOfLockedLists = loopStep.CMPL123__Object_Related_List_Relationship__c != null && loopStep.CMPL123__Object_Related_List_Relationship__c.contains(junctionObjectAPIName());
                if(allChildrenAreLocked || currentObjectIsPartOfLockedLists){
                    return true;
                }
            }
            return false;
        }

        public abstract SObject createObject(Id currentTargetObjectRecordId, Id userId);

        public abstract List<User> retrieveListOfAlreadySelectedUsers(Id currentTargetObjectRecordId);

        public abstract String retrieveMasterObjectCurrentStatus(Id idOfObject);

        public abstract String junctionObjectAPIName();
    }

    /*
    *   This class is the implementation of the Manager to Handle link between Quality Event and Users by managing Quality_Event_Contributor__c
    *
    */
    public class QualityEventContributorsManager extends JunctionObjectManager{
        public override List<Sobject> retieveListOfObjectsToDelete(Id currentTargetObjectRecordId,  List<Id> listOfRemovedUsers){
            return [SELECT
                        Id
                    FROM
                        Quality_Event_Contributor__c
                    WHERE
                        Contributor_Of_Quality_Event__c = : currentTargetObjectRecordId
                        AND Contributor_User__c IN : listOfRemovedUsers];
        }

        public override SObject createObject(Id currentTargetObjectRecordId,  Id idOfUser){
            Quality_Event_Contributor__c junctionObjectToReturn = new Quality_Event_Contributor__c();
            junctionObjectToReturn.Contributor_Of_Quality_Event__c = currentTargetObjectRecordId;
            junctionObjectToReturn.Contributor_User__c = idOfUser;
            return junctionObjectToReturn;
        }

        public override List<User> retrieveListOfAlreadySelectedUsers(Id currentTargetObjectRecordId){
            return [Select Id, Name from User where Id in (Select Contributor_User__c FROM Quality_Event_Contributor__c WHERE Contributor_Of_Quality_Event__c = :currentTargetObjectRecordId)];
        }

        public override String retrieveMasterObjectCurrentStatus(Id idOfObject){
            Quality_Event__c masterObject = [SELECT Id, CMPL123_WF_Status__c FROM Quality_Event__c WHERE Id = :idOfObject];
            return masterObject.CMPL123_WF_Status__c;
        }

        public override String junctionObjectAPIName(){
            return 'Quality_Event_Contributor__c';
        }

    }


    public class CauseInvestigationContributorsManager extends JunctionObjectManager{
        public override List<Sobject> retieveListOfObjectsToDelete(Id currentTargetObjectRecordId,  List<Id> listOfRemovedUsers){
            return [SELECT
                        Id
                    FROM
                        Cause_Investigation_Contributor__c
                    WHERE
                        Contributor_Of_Cause_Investigation__c = : currentTargetObjectRecordId
                        AND Contributor_User__c IN : listOfRemovedUsers];
        }

        public override SObject createObject(Id currentTargetObjectRecordId,  Id idOfUser){
            Cause_Investigation_Contributor__c junctionObjectToReturn = new Cause_Investigation_Contributor__c();
            junctionObjectToReturn.Contributor_Of_Cause_Investigation__c = currentTargetObjectRecordId;
            junctionObjectToReturn.Contributor_User__c = idOfUser;
            return junctionObjectToReturn;
        }

        public override List<User> retrieveListOfAlreadySelectedUsers(Id currentTargetObjectRecordId){
            return [Select Id, Name from User where Id in (Select Contributor_User__c FROM Cause_Investigation_Contributor__c WHERE Contributor_Of_Cause_Investigation__c = :currentTargetObjectRecordId)];
        }

        public override String retrieveMasterObjectCurrentStatus(Id idOfObject){
            Cause_Investigation__c masterObject = [SELECT Id, CMPL123_WF_Status__c FROM Cause_Investigation__c WHERE Id = :idOfObject];
            return masterObject.CMPL123_WF_Status__c;
        }

        public override String junctionObjectAPIName(){
            return 'Cause_Investigation_Contributor__c';
        }

    }





















    

}