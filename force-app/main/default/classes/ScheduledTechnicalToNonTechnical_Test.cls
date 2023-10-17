@isTest
public class ScheduledTechnicalToNonTechnical_Test {
@isTest
public static void myScheduletest(){
    Test.startTest();
    ScheduledTechnicalToNonTechnicalApexJob Technical= new ScheduledTechnicalToNonTechnicalApexJob();
    System.schedule('Technical_NonTechnicals', '0 0 * * * ?',  Technical);
   // System.schedule('Technical_NonTechnicals', '0 10 * * * ?', Technical);
    Technical.execute(null);
    Test.stopTest();
 }
}