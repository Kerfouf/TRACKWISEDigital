public class BMX_StaticUtil {
    public static Boolean firstCheck = true;
    /**
* Determines whether a record is currently in a workflow update
*/
    public static Boolean isRecordInUpdate(SObject oldVal,SObject newVal,String statusName) {
        return  !(oldVal.get(statusName) == newVal.get(statusName));
    }
    
    public static Boolean isRun() {
        if(firstCheck) {
            firstCheck = false;
            return true;
        }
        return false;
    }
}