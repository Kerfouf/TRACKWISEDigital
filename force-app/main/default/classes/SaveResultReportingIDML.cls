/*
 * Created on Mon Jan 11 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Shaun Vallejo
 * 
 * Extension to the the fflib_SObjectUnitOfWork.IDML to allow for partial success and failure.
 * Uses a callback pattern to notify of success and failures to allow for greater modularity in how to handle success/failures
 */

public interface SaveResultReportingIDML extends fflib_SObjectUnitOfWork.IDML {
    /**
     * Call Back on success
     * @param  - Callback to register
     */
    void setOnSuccessCallback(DBSuccessCallback callback);

    /**
     * Call back on failure.
     * @param  callback callback to register
     */
    void setOnFailureCallback(DBSaveFailureCallback callback);
}