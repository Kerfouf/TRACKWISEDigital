/*
 * **************************************************************
 * implemenation of the fflib_SObjectUnitOfWork.IDML in order to provide a way
 * to call Database.update with the allOrNone flag set to false and a way to 
 * retrieve the saveResults
 *  Supplying a callback is optional, so if only failures are needed, only supply that callback. 
 * Author: Sam Hart, sam.hart@spartasystems.com
 * Copyright (c) 2020 Sparta Systems, Inc. 
 * **************************************************************
 */
public with sharing class SPS_Dml implements SaveResultReportingIDML {

    private DBSuccessCallback successCallback;


    private DBSaveFailureCallback failureCallback;

    private Database.SaveResult[] saveRes = new List<Database.SaveResult>();

    public Database.SaveResult[] getLastSaveResult(){
        return this.saveRes;
    }

    public void dmlInsert(List<SObject> objList)
    {
        this.saveRes = Database.insert(objList, false);
        System.debug('inserting object list:');
        System.debug(objList);
        System.debug('save result:');
        System.debug(this.saveRes);

        if(this.doCallbacks()) {
            this.handleCallbacks(objList, saveRes);
        }

    }

    public void dmlUpdate(List<SObject> objList){
        this.saveRes = Database.update(objList, false);
        System.debug('updating object list:');
        System.debug(objList);
        System.debug('save result:');
        System.debug(this.saveRes);

        if(this.doCallbacks()) {
            this.handleCallbacks(objList, saveRes);
        }
    }

    public void dmlDelete(List<SObject> objList)
    {
        delete objList;

    }
    public void eventPublish(List<SObject> objList)
    {
        EventBus.publish(objList);
    }
    public void emptyRecycleBin(List<SObject> objList)
    {
        if (objList.isEmpty())
        {
            return;
        }

        Database.emptyRecycleBin(objList);
    }

    public void setOnSuccessCallback(DBSuccessCallback callback) {
        this.successCallback = callback;
    }

    public void setOnFailureCallback(DBSaveFailureCallback callback) {
        this.failureCallback = callback;
    }

    private Boolean doCallbacks() {
        return this.failureCallback != null || this.successCallback !=null;
    }

    private void handleCallbacks(List<SObject> obj, Database.SaveResult[] results) {
        List<DBSaveResultWithRecord> success = new List<DBSaveResultWithRecord>();
        List<DBSaveResultWithRecord> failure = new List<DBSaveResultWithRecord>();

        for(Integer i = 0; i< results.size(); i++) {
            Database.SaveResult r = results[i];
            SObject o = obj[i];
            DBSaveResultWithRecord result = new DBSaveResultWithRecord(o,r);
            if(r.isSuccess()) {
                success.add(result);
            } else {
                failure.add(result);
            }
        }

        if(this.successCallback != null && success.size() > 0) {
            this.successCallback.callbackOnSuccess(success);
        }

        if(this.failureCallback != null && failure.size() > 0) {
            this.failureCallback.callBackOnFailure(failure);
        }
    }
}