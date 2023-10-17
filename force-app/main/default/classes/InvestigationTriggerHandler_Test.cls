/*************************************************************
File Name: EU_MIR_InvestigationHandler_Test
Author: cognizant technology solutions 
Description: This test class used to get the code coverage for InvestigationTriggerHandler.
***************************************************************/
@isTest
public class InvestigationTriggerHandler_Test 
{
    
    public static testmethod void mytest()
    {
    
        try{
        Profile p = [select id from profile where name='Standard User'];
    
        User u = new User(alias = 'utest', email='utest@email.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='utest123@email.com');
        insert u;
    
    
        CMPL123CME__Complaint__c cmplnt = new CMPL123CME__Complaint__c();
        insert cmplnt;
        
        List<CMPL123CME__EU_MIR__c> emirlist=new List<CMPL123CME__EU_MIR__c>();
        
        CMPL123CME__EU_MIR__c eu= new CMPL123CME__EU_MIR__c();
        eu.CMPL123CME__Complaint__c=cmplnt.Id;
        eu.CMPL123CME__Type_Of_Report__c='Initial';
        eu.CMPL123CME__Author_Address_Complement__c='My Address';
        eu.CMPL123CME__Author_City_Name__c='Marcy- l’Etoile';
        eu.CMPL123CME__Author_Contact_First_Name__c='Sophie';
        eu.CMPL123CME__Author_Contact_Last_Name__c='BOBIN-DUBREUX';
        eu.CMPL123CME__Author_Country__c='France';
        eu.CMPL123CME__Author_E_mail__c='sophie.bobin-dubreux@biomerieux.com';
        eu.CMPL123CME__Author_Phone__c='+(33) 4 78 87 70 66';
        eu.CMPL123CME__Author_Postcode__c='69280';
        eu.CMPL123CME__Author_Single_Registration_Number_SRN__c='64';
        eu.CMPL123CME__Author_Street_Number__c='12345';
        eu.CMPL123CME__Author_Street__c='Allée Louis Pasteur';
        eu.CMPL123CME__Basic_UDI_DI__c='UDI deviceEudamed';
        eu.CMPL123CME__Classification_Of_Incident__c='Test';
        eu.CMPL123CME__Current_Device_Location_Other__c='Testing Device';
        eu.CMPL123CME__Current_Device_Location__c='Healthcare facility/carer';
        eu.CMPL123CME__Date_Of_Incident_From__c=system.today()+10;
        eu.CMPL123CME__Date_Of_Incident_To__c=System.today()+20;
        eu.CMPL123CME__Description_Of_Device_Nomenclature_Text__c='Description of device/Nomenclature text';
        eu.CMPL123CME__Device_Usage__c='Initial use';
        eu.CMPL123CME__Date_Of_Submission__c=System.today()+5;
        eu.CMPL123CME__Initial_Actions_Taken_By_Manufacturer__c='List down further investigations pla';
        eu.CMPL123CME__Initial_Reporter_Contact_First_Name__c='Sophie';
        eu.CMPL123CME__Initial_Reporter_Contact_Last_Name__c='BOBIN-DUBREUX';
        eu.CMPL123CME__Manufact_City_Name__c='Marcy- l’Etoile';
        eu.CMPL123CME__Manufact_Contact_First_Name__c='Sophie';
        eu.CMPL123CME__Manufact_Contact_Last_Name__c='BOBIN-DUBREUX';
        eu.CMPL123CME__Manufact_Country__c='France';
        eu.CMPL123CME__Manufact_E_Mail__c='sophie.bobin-dubreux@biomerieux.com';
        eu.CMPL123CME__Manufact_Organisation_Name__c='bioMérieux SA';
        eu.CMPL123CME__Manufact_Phone__c='123456789';
        eu.CMPL123CME__Manufact_Postcode__c='69280';
        eu.CMPL123CME__Manufact_Single_Registration_Number_SRN__c='64';
        eu.CMPL123CME__Manufact_Street_Number__c='110';
        eu.CMPL123CME__Manufact_Street__c='Allée Louis Pasteur';
        eu.CMPL123CME__Manufacturer_S_FSCA_Reference_Number__c='53543';
        eu.CMPL123CME__Manufacturer_S_Reference_Number__c='23432424';
        eu.CMPL123CME__Medical_Device_Nomenclature_Code__c='wwww';
        eu.CMPL123CME__Medical_Device_Terminology_Other__c='test';
        eu.CMPL123CME__Medical_Device_Terminology__c='EMDN';
        eu.CMPL123CME__NCA_S_Local_FSCA_Reference_Number__c='233535';
        eu.CMPL123CME__NCA_S_Local_Reference_Number__c='32234234';
        eu.CMPL123CME__Org_Name_Of_Authorised_Representative__c='bioMérieux SA';
        eu.CMPL123CME__Patient_Remedial_Action__c='Test';
        eu.CMPL123CME__Periodic_Summary_Report_PSR_ID__c='Testing';
        eu.CMPL123CME__Please_Indicate_The_Date__c= 'First declaration of conformity';
        eu.CMPL123CME__Preliminary_Results_And_Conclusions__c='List down further investigations pla';
        eu.CMPL123CME__Recipient_Name_Of_NCA__c='[ANSM] - Agence nationale deuits de santé';
        eu.CMPL123CME__Reference_Number_By_Manufacturer__c='CN-014146';
        eu.CMPL123CME__Reference_Number_By_NCA__c='Reference number by N';
        eu.CMPL123CME__Registered_Commercial_Name_Of_Company__c='bioMérieux SA';
        eu.CMPL123CME__Role_Of_Initial_Reporter__c='Healthcare professional';
        eu.CMPL123CME__Specify_Other_Submitter__c='Testing';
        eu.CMPL123CME__Submitter_City_Name__c='Craponne';
        eu.CMPL123CME__Submitter_Contact_First_Name__c='Sophie';
        eu.CMPL123CME__Submitter_Contact_Last_Name__c='BOBIN-DUBREUX';
        eu.CMPL123CME__Submitter_Country__c='France';
        eu.CMPL123CME__Submitter_E_Mail__c='sophie.bobin-dubreux@biomerieux.com';
        eu.CMPL123CME__Submitter_Of_Report__c='Manufacturer';
        eu.CMPL123CME__Submitter_Phone__c='12347';
        eu.CMPL123CME__Submitter_Postcode__c='69280';
        eu.CMPL123CME__Submitter_Street_Number__c='110';
        eu.CMPL123CME__Submitter_Street__c='Allée Louis Pasteur';
        eu.BMX_Due_Date__c=System.today()+10;
        eu.CMPL123CME__Date_Of_Submission__c=system.today()+5;
        eu.CMPL123CME__UDI_DI__c='UDI device identifier/Eudamed';
        eu.CMPL123CME__UDI_PI__c='UDI device identifier/Eudamed';
        eu.CMPL123CME__Unit_Of_Use_UDI_DI__c='UDI device identifier/Eudamed';
        eu.CMPL123CME__Years_At_Time_Of_Incident__c=10;        
        eu.Title__c='Test Followup';
        eu.CMPL123_WF_Status__c='Opened';
        emirlist.add(eu);
        
        Insert emirlist;
        
        CMPL123CME__Investigation__c Invest=new CMPL123CME__Investigation__c();
        Invest.Name='TWD TestInvestigation';
        Invest.CMPL123CME__Complaint__c=cmplnt.Id;
        invest.CMPL123_WF_Status__c='Opened';
        Insert Invest;
        
        
        
        
        }
        Catch(Exception e){
            System.debug('Error Messages on EUMIR...'+e.getMessage());
        }
        
        
    
        
        
    }

}