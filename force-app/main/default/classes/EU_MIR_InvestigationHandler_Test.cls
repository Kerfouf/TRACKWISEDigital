/*
File Name: EU_MIR_InvestigationHandler_Test
Author: cognizant technology solutions
Description: This test class used to get the code coverage for EU_MIR_InvestigationHandler.

*/

@isTest 
public class EU_MIR_InvestigationHandler_Test {
    public static testmethod void testInvestigationHandler() 
	{
      // User initialization
        Profile p = [select id from profile where name='Standard User'];

        User u = new User(alias = 'utest', email='utest@email.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='utest123@email.com');
		insert u;
		
		
		CMPL123CME__Complaint__c cmplnt = new CMPL123CME__Complaint__c();
		insert cmplnt;
        
        CMPL123CME__Investigation__c Invest=new CMPL123CME__Investigation__c();
        Invest.Name='TWD TestInvestigation';
        Invest.CMPL123CME__Complaint__c=cmplnt.Id;
        invest.CMPL123_WF_Status__c='Open';
        Insert Invest;
		
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
		
        Insert eu;
		
	
		
        
    }
    public static testmethod void EUMIRInitalToFollowup(){
        
        CMPL123CME__Complaint__c cmplnts = new CMPL123CME__Complaint__c();
		insert cmplnts;
        
        CMPL123CME__Investigation__c Invest=new CMPL123CME__Investigation__c();
        Invest.Name='TWD TestInvestigation';
        Invest.CMPL123CME__Complaint__c=cmplnts.Id;
        invest.CMPL123_WF_Status__c='Open';
        Insert Invest;
        
        CMPL123CME__EU_MIR__c eu= new CMPL123CME__EU_MIR__c();
		eu.CMPL123CME__Complaint__c=cmplnts.Id;
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
        eu.CMPL123_WF_Status__c='Open';
		eu.Title__c='Test Followup';
		
        Insert eu;
        
        
        eu.CMPL123_WF_Status__c='Closed-Submitted';
        update eu;
        //Create new follow up record in new EU MIR
                
        CMPL123CME__EU_MIR__c eu_mir= new CMPL123CME__EU_MIR__c();
		eu_mir.CMPL123CME__Complaint__c=cmplnts.Id;
		eu_mir.CMPL123CME__Type_Of_Report__c='Follow up';
		eu_mir.CMPL123CME__Author_Address_Complement__c='My Address';
		eu_mir.CMPL123CME__Author_City_Name__c='Marcy- l’Etoile';
		eu_mir.CMPL123CME__Author_Contact_First_Name__c='Sophie';
		eu_mir.CMPL123CME__Author_Contact_Last_Name__c='BOBIN-DUBREUX';
		eu_mir.CMPL123CME__Author_Country__c='France';
		eu_mir.CMPL123CME__Author_E_mail__c='sophie.bobin-dubreux@biomerieux.com';
		eu_mir.CMPL123CME__Author_Phone__c='+(33) 4 78 87 70 66';
		eu_mir.CMPL123CME__Author_Postcode__c='69280';
		eu_mir.CMPL123CME__Author_Single_Registration_Number_SRN__c='64';
		eu_mir.CMPL123CME__Author_Street_Number__c='12345';
		eu_mir.CMPL123CME__Author_Street__c='Allée Louis Pasteur';
		eu_mir.CMPL123CME__Basic_UDI_DI__c='UDI deviceEudamed';
		eu_mir.CMPL123CME__Classification_Of_Incident__c='Test';
		eu_mir.CMPL123CME__Current_Device_Location_Other__c='Testing Device';
		eu_mir.CMPL123CME__Current_Device_Location__c='Healthcare facility/carer';
		eu_mir.CMPL123CME__Date_Of_Incident_From__c=system.today()+10;
		eu_mir.CMPL123CME__Date_Of_Incident_To__c=System.today()+20;
		eu_mir.CMPL123CME__Description_Of_Device_Nomenclature_Text__c='Description of device/Nomenclature text';
		eu_mir.CMPL123CME__Device_Usage__c='Initial use';
		eu_mir.CMPL123CME__Date_Of_Submission__c=System.today()+5;
		eu_mir.CMPL123CME__Initial_Actions_Taken_By_Manufacturer__c='List down further investigations pla';
		eu_mir.CMPL123CME__Initial_Reporter_Contact_First_Name__c='Sophie';
		eu_mir.CMPL123CME__Initial_Reporter_Contact_Last_Name__c='BOBIN-DUBREUX';
		eu_mir.CMPL123CME__Manufact_City_Name__c='Marcy- l’Etoile';
		eu_mir.CMPL123CME__Manufact_Contact_First_Name__c='Sophie';
		eu_mir.CMPL123CME__Manufact_Contact_Last_Name__c='BOBIN-DUBREUX';
		eu_mir.CMPL123CME__Manufact_Country__c='France';
		eu_mir.CMPL123CME__Manufact_E_Mail__c='sophie.bobin-dubreux@biomerieux.com';
		eu_mir.CMPL123CME__Manufact_Organisation_Name__c='bioMérieux SA';
		eu_mir.CMPL123CME__Manufact_Phone__c='123456789';
		eu_mir.CMPL123CME__Manufact_Postcode__c='69280';
		eu_mir.CMPL123CME__Manufact_Single_Registration_Number_SRN__c='64';
		eu_mir.CMPL123CME__Manufact_Street_Number__c='110';
		eu_mir.CMPL123CME__Manufact_Street__c='Allée Louis Pasteur';
		eu_mir.CMPL123CME__Manufacturer_S_FSCA_Reference_Number__c='53543';
		eu_mir.CMPL123CME__Manufacturer_S_Reference_Number__c='23432424';
		eu_mir.CMPL123CME__Medical_Device_Nomenclature_Code__c='wwww';
		eu_mir.CMPL123CME__Medical_Device_Terminology_Other__c='test';
		eu_mir.CMPL123CME__Medical_Device_Terminology__c='EMDN';
		eu_mir.CMPL123CME__NCA_S_Local_FSCA_Reference_Number__c='233535';
		eu_mir.CMPL123CME__NCA_S_Local_Reference_Number__c='32234234';
		eu_mir.CMPL123CME__Org_Name_Of_Authorised_Representative__c='bioMérieux SA';
		eu_mir.CMPL123CME__Patient_Remedial_Action__c='Test';
		eu_mir.CMPL123CME__Periodic_Summary_Report_PSR_ID__c='Testing';
		eu_mir.CMPL123CME__Please_Indicate_The_Date__c= 'First declaration of conformity';
		eu_mir.CMPL123CME__Preliminary_Results_And_Conclusions__c='List down further investigations pla';
		eu_mir.CMPL123CME__Recipient_Name_Of_NCA__c='[ANSM] - Agence nationale deuits de santé';
		eu_mir.CMPL123CME__Reference_Number_By_Manufacturer__c='CN-014146';
		eu_mir.CMPL123CME__Reference_Number_By_NCA__c='Reference number by N';
		eu_mir.CMPL123CME__Registered_Commercial_Name_Of_Company__c='bioMérieux SA';
		eu_mir.CMPL123CME__Role_Of_Initial_Reporter__c='Healthcare professional';
		eu_mir.CMPL123CME__Specify_Other_Submitter__c='Testing';
		eu_mir.CMPL123CME__Submitter_City_Name__c='Craponne';
		eu_mir.CMPL123CME__Submitter_Contact_First_Name__c='Sophie';
		eu_mir.CMPL123CME__Submitter_Contact_Last_Name__c='BOBIN-DUBREUX';
		eu_mir.CMPL123CME__Submitter_Country__c='France';
		eu_mir.CMPL123CME__Submitter_E_Mail__c='sophie.bobin-dubreux@biomerieux.com';
		eu_mir.CMPL123CME__Submitter_Of_Report__c='Manufacturer';
		eu_mir.CMPL123CME__Submitter_Phone__c='12347';
		eu_mir.CMPL123CME__Submitter_Postcode__c='69280';
		eu_mir.CMPL123CME__Submitter_Street_Number__c='110';
		eu_mir.CMPL123CME__Submitter_Street__c='Allée Louis Pasteur';
		eu_mir.BMX_Due_Date__c=System.today()+10;
		eu_mir.CMPL123CME__Date_Of_Submission__c=system.today()+5;
		eu_mir.CMPL123CME__UDI_DI__c='UDI device identifier/Eudamed';
		eu_mir.CMPL123CME__UDI_PI__c='UDI device identifier/Eudamed';
		eu_mir.CMPL123CME__Unit_Of_Use_UDI_DI__c='UDI device identifier/Eudamed';
		eu_mir.CMPL123CME__Years_At_Time_Of_Incident__c=10;
        eu_mir.CMPL123_WF_Status__c='Open';
		eu_mir.Title__c='Test Followup';
        
        Insert eu_mir;
        
        eu_mir.CMPL123_WF_Status__c='Closed-Submitted';
        Update eu_mir;
        
        CMPL123CME__EU_MIR_Code__c Code=new CMPL123CME__EU_MIR_Code__c();
        code.CMPL123CME__Name__c='Testing of Device';
        code.Name='B02';
        code.CMPL123CME__Code_Type__c='B-Investigation Type Code';
        code.CMPL123CME__Inactive__c=FALSE;
        Insert code;
        
            
        CMPL123CME__EU_MIR_Code_Choices__c Codech=new CMPL123CME__EU_MIR_Code_Choices__c();
        Codech.Name='B-Investigation Type Code - Choice1 - B02';
        Codech.CMPL123CME__Choice__c='Choice 1';
        Codech.CMPL123CME__Related_EU_MIR__c=eu_mir.Id;
        Codech.CMPL123CME__Related_EU_MIR_Code__c=Code.Id;
        Insert Codech;
        
        
    }
    
  
}