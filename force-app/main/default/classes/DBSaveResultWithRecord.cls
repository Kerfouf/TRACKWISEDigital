/*
 * Created on Mon Jan 11 2021
 *
 * Copyright (c) 2021 Sparta Systems
 * Author: Shaun Vallejo
 * 
 * Container for a single save operation containing the save result and SObject.
 */

public with sharing class DBSaveResultWithRecord {

    /**
     * Object involved in save operation.
     */
    public SObject obj{get;set;}

    /**
     * Result of the save attempt.
     */
    public Database.SaveResult result{get;set;}

    public DBSaveResultWithRecord() {}

    public DBSaveResultWithRecord(SObject obj, Database.SaveResult result) {
        this.obj = obj;
        this.result = result;
    }
}