/*
* Created on Wed Dec 15, 2021
*
* Copyright (c) 2021 Sparta Systems
* Author: Brian Lavin
* 
*/

@IsTest
public with sharing class ErrorLogTriggerTest {
    @IsTest
    static void testInsert(){
        
        Error_Log__c log = (Error_Log__c) SmartFactory.createSObject(
            'Error_Log__c'
        );

        insert log;        
    }
}