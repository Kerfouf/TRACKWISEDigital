public class CcRecordLockController {

    @AuraEnabled
    public static CMPL123QMS__Change_Control__c queryBaseCC(Id recordId){
          return [SELECT SystemModStamp FROM CMPL123QMS__Change_Control__c  WHERE Id = :recordId FOR UPDATE];
    }
    @AuraEnabled
    public static void queryCC(CMPL123QMS__Change_Control__c  record){ //you probably want to make this bulk safe for real use
    //do intensive processing here that might take a few seconds
    
    //a FOR UPDATE query locks the record, which will either wait for conflicting edits to commit, or timeout and throw an exception
    //it will not be possible for another request to have a pending write to this record without this request knowing about it!
    try{
    CMPL123QMS__Change_Control__c  lockedRecord = [SELECT SystemModStamp FROM CMPL123QMS__Change_Control__c  WHERE Id = :record.Id FOR UPDATE];
    if(lockedRecord.SystemModStamp == record.SystemModStamp){
    update record;
    }else{
    throw new AuraHandledException('Another request has modified this record, please reload the page and try again');
    }
    }catch(QueryException e){ //row lock timeout
    throw new AuraHandledException('This record is currently locked for editing by another request. Please wait a moment and try again');
    }
    
    }
}