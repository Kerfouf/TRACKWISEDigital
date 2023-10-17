/*
 * Created on Mon Jan 11 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Shaun Vallejo
 * 
 * Represents a successful process of saved records. 
 */

public interface DBSuccessCallback {
    /**
     * When a database operation succeeds, call back with the successful results.
     * @param  result List of successful records.
     */
    void callbackOnSuccess(List<DBSaveResultWithRecord> result);
}