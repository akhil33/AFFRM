/**
 * Created by Akhil on 2022-04-07.
 */

public virtual class TriggerHandler {
	public virtual void beforeInsert(List<SObject> records){
	}
	public virtual void afterInsert(List<SObject> records){
	}
	public virtual void beforeUpdate(List<SObject> records, Map<Id, SObject> oldRecords){
	}
	public virtual void afterUpdate(List<SObject> records, Map<Id, SObject> oldRecords){
	}
	public virtual void beforeDelete(List<SObject> records, Map<Id, SObject> oldRecords){
	}
	public virtual void afterDelete(List<SObject> records, Map<Id, SObject> oldRecords){
	}
	public virtual void afterUndelete(List<SObject> records){
	}
	public virtual void runTriggerSwitchHandler(List<SObject> records, Map<Id, SObject> oldRecords){
	}
}