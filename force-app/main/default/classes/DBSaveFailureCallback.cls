/**
 * Callback interface to handle Partial Save failures.
 * @author Shaun Vallejo
 */
public interface DBSaveFailureCallback {

  /**
   * When encountering a partial save error, call back with the 
   * partial errors
   * @param  failures - all failed records.
   */
  void callBackOnFailure(List<DBSaveResultWithRecord> failures);
}