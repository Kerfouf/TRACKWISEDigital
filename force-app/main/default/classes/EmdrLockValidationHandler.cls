/**
 * Emdr records should not be edited by any user than then utility 
 * used by the application to interact with the FDA gateway. 
 * In the event of an update by any other user, throw an error
 * */
public class EmdrLockValidationHandler {
    /** 
     * Modifier to identify whether the current user is the FDA Gateway
     */
    public static final String FDA_GATEWAY_MODIFIER ='Gateway User';
    
    /**Pending Submission State for which the record must be locked */
    public static final String EMDR_STATE ='Submission In Progress';
    
    public static final String EMDR_LOCK_ERROR =
        'EMDR records can only be edited by the FDA Gateway User in '+EMDR_STATE+ ' Status';
    
    
     private String currentUser;
    
    public void validateUpdate(final CMPL123CME__EMDR__c emdrRecord) {
        if(!currentUserIsGateway() && isLockedState(emdrRecord)) {
            emdrRecord.addError(EMDR_LOCK_ERROR);
        }   
    }
    
    public void validateAll(final List<CMPL123CME__EMDR__c> emdrRecord) {
        for(Integer i = 0;i< emdrRecord.size();i ++) {
            validateUpdate(emdrRecord.get(i));
        }
    }
    
    private boolean currentUserIsGateway() {
        String userProfile = UserInfo.getProfileId();
        String profileName = [SELECT Id,Name FROM Profile WHERE Id =: userProfile].Name;
        return profileName.contains(FDA_GATEWAY_MODIFIER);
    }
    
    private boolean isLockedState(final CMPL123CME__EMDR__c emdrRecord) {
        return emdrRecord.CMPL123CME__CMPL123_WF_Status__c ==EMDR_STATE;
    }
}