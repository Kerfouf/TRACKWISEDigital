/*
* Created on Thu Dec 23, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class SPS_DmlTest {
    
    @IsTest
    static void testInsert(){
        
        SPS_Dml dml = new SPS_Dml();
        dml.setOnFailureCallback(new TestDBSaveFailureCallback());
        dml.setOnSuccessCallback(new TestDBSuccessCallback());

        fflib_ISObjectUnitOfWork uow = CrmComplaintIntegrationApplication.unitOfWork.newInstance(
            new List<SObjectType> { Account.SObjectType }, 
            dml
        );

        uow.registerNew(new Account(Name='Test Account'));
        
        Test.startTest();
        uow.commitWork();
        Test.stopTest();
    }

    public class TestDBSuccessCallback implements DBSuccessCallback {
        public void callbackOnSuccess(List<DBSaveResultWithRecord> failures) {
            return;
        }
    }

    public class TestDBSaveFailureCallback implements DBSaveFailureCallback {
        public void callBackOnFailure(List<DBSaveResultWithRecord> failures) {
            return;
        }
    }
}