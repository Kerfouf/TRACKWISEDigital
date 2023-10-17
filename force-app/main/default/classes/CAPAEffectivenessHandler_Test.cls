@IsTest public class CAPAEffectivenessHandler_Test {
     @IsTest public static void testCAPAEffectivenessHandlerNegative () {
       
         // User initialization
         Profile p = [select id from profile where name='Standard User'];
         
         User testUserCAPA1 = new User(alias = 'utest', email='utest@email.com',
                           emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
                           localesidkey='en_US', profileid = p.Id, country='United States',
                           timezonesidkey='America/Los_Angeles', username='utestCAPA1@email.com');
         insert testUserCAPA1;
       
         //Devices
         CMPL123__Device__c device = new CMPL123__Device__c();
         device.Name = '123Test';
         try{
         insert device;
         }
         catch(Exception ex)
         {
             system.debug(ex);
         }
         
         //CAPA Object
         CMPL123QMS__CAPA__c capaObj = new CMPL123QMS__CAPA__c();
         capaObj.CMPL123QMS__CAPA_Type__c = 'Corrective Action';
         capaObj.Description__c = 'UTest';
         capaObj.Short_Description__c = 'UTest';
         capaObj.Date_Initiated__c = Date.today();
         capaObj.Device__c = device.id;
         capaObj.Device_Problem__c = 'Yes';
         capaObj.Health_Risk__c ='Yes';
         capaObj.Business_Risk__c ='High';
         capaObj.Probability_Measure__c = 'Low';
         capaObj.Actual_Risk_Rating__c = 'Low';
         capaObj.Compliance_Risk__c = 'High';
         capaObj.Severity_Measure__c ='High';
         capaObj.Risk_Category__c = 'Low';
         capaObj.Investigation_Required__c = 'Yes';
         capaObj.CAPA_Owner__c = testUserCAPA1.id;
         capaObj.Action_Plan__c ='To Test!';
         //capaObj.CMPL123_WF_Status__c = 'Closed - CAPA';
         insert capaObj;
         
         // CAPA_Effectiveness_Check__c Object
         CAPA_Effectiveness_Check__c capaEffObj = new CAPA_Effectiveness_Check__c();
         capaEffObj.CAPA__c = capaObj.id;
         
         insert capaEffObj;
         update capaEffObj;
         delete capaEffObj;
         undelete capaEffObj;
             
         
        }
        
        @IsTest(SeeAllData=true)  public static void testCAPAEffectivenessHandlerPositive () {
       
        // User initialization
        Profile p = [select id from profile where name='Standard User'];

        User testUserCAPA2 = new User(alias = 'utest', email='utest@email.com',
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id, country='United States',
            timezonesidkey='America/Los_Angeles', username='utestCAPA2@email.com');
        insert testUserCAPA2;
         //Devices
        
        CMPL123__Device__c device = new CMPL123__Device__c();
        device.Name = 'ABCDTEST2';
        insert device;
         
            //CAPA Object
            CMPL123QMS__CAPA__c capaObj = new CMPL123QMS__CAPA__c();
            capaObj.CMPL123QMS__CAPA_Type__c = 'Corrective Action';
            capaObj.Description__c = 'UTest';
            capaObj.Short_Description__c = 'UTest';
            capaObj.Date_Initiated__c = Date.today();
            capaObj.Device__c = device.id;
            capaObj.Device_Problem__c = 'Yes';
            capaObj.Health_Risk__c ='Yes';
            capaObj.Business_Risk__c ='High';
            capaObj.Probability_Measure__c = 'Low';
            capaObj.Actual_Risk_Rating__c = 'Low';
            capaObj.Compliance_Risk__c = 'High';
            capaObj.Severity_Measure__c ='High';
            capaObj.Risk_Category__c = 'Low';
            capaObj.Investigation_Required__c = 'Yes';
            capaObj.CAPA_Owner__c = testUserCAPA2.id;
            capaObj.Action_Plan__c ='To Test!';
            try{
            insert capaObj;
            }
            catch(Exception ex)
            {
                system.debug(ex);
            }
            // CAPA_Effectiveness_Check__c Object
            CAPA_Effectiveness_Check__c capaEffObj = new CAPA_Effectiveness_Check__c();
            capaEffObj.CAPA__c = capaObj.id;
            insert capaEffObj;
        
            //create a task for the user
            //Task newTask = new Task(Subject='Complete Survey for Transaction');
            
            Change_Control_Plan__c changeCntrlRec = new Change_Control_Plan__c(Change_Control_Plan_Approved__c = true);
            insert changeCntrlRec;
            
            List<Task> taskList = new List<Task>();
            Task newTask = new Task(Subject = 'Call',
                                    Description = 'Survey Transaction',
                                    Priority = 'Normal', 
                                    Status = 'In Progress', 
                                    IsReminderSet = true, 
                                    whatId = changeCntrlRec.Id,
                                    ReminderDateTime = System.now()+1); 
            try{
                insert newTask;
            }
            catch(Exception ex){
                            system.debug('In the + method ' + ex);
            }
            
            taskList.add(newTask);
            TaskPreventionHandler.preventTaskAddAndDelete(taskList,'insert');
            TaskPreventionHandler.preventTaskAddAndDelete(taskList,'delete');
        }

}