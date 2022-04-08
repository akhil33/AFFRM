/**
 * Created by akhilreddy on 2021-08-25.
 */

public inherited sharing class StateSeeder {
    public static void process(IStateAssignor sObjectState){
        doProcessing(sObjectState);
    }

    private static void doProcessing(IStateAssignor sObjectState){
        if (Trigger.isBefore) {
            if(Trigger.isInsert){
                sObjectState.setRecordsForStateGeneration(Trigger.new);
            }
            else if(Trigger.isUpdate){
                sObjectState.setRecordsForStateGeneration(Trigger.new, Trigger.oldMap);
            }
            else{ //Trigger.isDelete{
                sObjectState.setRecordsForStateGeneration(Trigger.old, Trigger.oldMap);
            }

        } else if (Trigger.isAfter) {
            if(Trigger.isInsert){
                sObjectState.setRecordsForStateGeneration(Trigger.new);
            }
            else if(Trigger.isUpdate){
                sObjectState.setRecordsForStateGeneration(Trigger.new, Trigger.oldMap);
            }
            else if(Trigger.isDelete){
                sObjectState.setRecordsForStateGeneration(Trigger.old, Trigger.oldMap);
            }
            else{ //Trigger.isUndelete{
                sObjectState.setRecordsForStateGeneration(Trigger.new);
            }
        }
        if(Trigger.isDelete){
            sObjectState.setRecordsForStateGeneration(Trigger.old, Trigger.oldMap);
        }else{
            sObjectState.setRecordsForStateGeneration(Trigger.new, Trigger.oldMap);
        }
    }
}