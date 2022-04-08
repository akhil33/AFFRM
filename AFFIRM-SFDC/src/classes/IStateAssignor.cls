/**
 * Created by akhilreddy on 2021-08-25.
 */

public interface IStateAssignor {

    /**
     * @description : The implementation of the State Assignor, this should return list of Sobjects in the scope
     * @TriggerContexts: beforeInsert, afterInsert, afterUndelete
     */
    void setRecordsForStateGeneration(List<SObject> records);

    /**
     * The implementation of the State Assignor, this should return list of Sobjects in the scope
     * @TriggerContexts: beforeUpdate, afterUpdate, beforeDelete, afterDelete
     */
    void setRecordsForStateGeneration(List<SObject> records, Map<Id, SObject> oldRecords);
}