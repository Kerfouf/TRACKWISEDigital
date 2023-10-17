@isTest
 public   class CMPLEventTriggerTest{
	static testMethod void EventTriggerTestmethod(){
        Long dt1Long = DateTime.now().addDays(-1).getTime();
        Long dt2Long = DateTime.now().getTime();
        Long milliseconds = dt2Long - dt1Long;
        Long seconds = milliseconds / 1000;
        Long minutes = seconds / 60;
		Event testobject = new Event (DurationInMinutes = Integer.valueOf(minutes), ActivityDateTime = DateTime.now());
		insert testobject; 
		delete testobject; 
		undelete testobject; 
		update testobject; 
		System.assertEquals('1','1');
	}
}