@IsTest
public with sharing class DBSaveResultWithRecordTest {
    @IsTest
    static void constructorTest(){
        Account a = (Account)SmartFactory.createSObject('Account');
        Database.SaveResult result = Database.insert(a);
        new DBSaveResultWithRecord(a, result);
    }
}