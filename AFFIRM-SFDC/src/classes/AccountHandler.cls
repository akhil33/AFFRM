/**
 * Created by Akhil on 2022-04-07.
 */

public inherited sharing class AccountHandler extends TriggerHandler{
	private Map<String, List<SObject>> domainNamesToSortedRecords = new Map<String, List<SObject>>();

	public override void beforeInsert(List<SObject> records){
		AccountState.setRecordsForStateGeneration(records);
		new AccountDomain().beforeInsert(records);

		initRecords(records);
	}

	public override void afterInsert(List<SObject> records){
		AccountState.setRecordsForStateGeneration(records);
		new AccountDomain().afterInsert(records);

		initRecords(records);

	}

	public override void beforeUpdate(List<SObject> records, Map<Id, SObject> oldRecords){
		AccountState.setRecordsForStateGeneration(records, oldRecords);
		new AccountDomain().beforeUpdate(records, (Map<Id, Account>) oldRecords);

		initRecords(records);

	}

	public override void afterUpdate(List<SObject> records, Map<Id, SObject> oldRecords){
		AccountState.setRecordsForStateGeneration(records, oldRecords);
		new AccountDomain().afterUpdate(records, (Map<Id, Account>) oldRecords);

		initRecords(records);

	}

	public override void beforeDelete(List<SObject> records, Map<Id, SObject> oldRecords){
		new AccountDomain().beforeDelete(records, (Map<Id, Account>) oldRecords);

		initRecords(records);

	}

	public override void afterDelete(List<SObject> records, Map<Id, SObject> oldRecords){
		new AccountDomain().afterDelete(records, (Map<Id, Account>) oldRecords);

		initRecords(records);

	}

	public override void afterUndelete(List<SObject> records){
		new AccountDomain().afterUndelete(records);

		initRecords(records);

	}

	// initRecords does the real work. Here we split the records based on whatever criteria we want. ß
	private void initRecords(List<SObject> records){
		domainNamesToSortedRecords.put(SystemConstants.Domain.AccountAll, new List<SObject>());

		for(SObject record : records){
			domainNamesToSortedRecords.get(SystemConstants.Domain.AccountAll).add(record);
		}
	}
}