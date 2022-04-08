/**
 * Created by Akhil on 2022-04-07.
 */
public with sharing class AccountState implements IStateAssignor{

	public static List<Account> records;
	public static Map<Id, Account> oldRecords;

	public static void setRecordsForStateGeneration(List<SObject> records, Map<Id, SObject> oldRecords){
		AccountState.records = (List<Account>) records;
		AccountState.oldRecords = (Map<Id, Account>) oldRecords;
		resetState();
	}


	public static void setRecordsForStateGeneration(List<Account> records){
		AccountState.records = records;
		resetState();
	}

	public static void setRecordsForStateGeneration(Set<Id> recordIds){
		AccountState.records = new List<Account>();
		for (Id recordId : recordIds) {
			Account a = new Account(Id = recordId);
			AccountState.records.add(a);
		}
	}

	public static void setRecordsForStateGeneration(List<Account> records, Map<Id, Account> oldRecords){
		AccountState.records = records;
		AccountState.oldRecords = oldRecords;
		resetState();
	}

	//This is used by the async service methods to pull data that may be needed to generate other state records, or for the async task
	public static List<Account> initAsyncRecords(Set<Id> recordIds){
		if(!Test.isRunningTest()){
			List<Account> asyncRecords = [SELECT Id
											FROM Account WHERE Id IN: recordIds];
			setRecordsForStateGeneration(asyncRecords, new Map<Id, Account>());
		}
		return records;
	}

	private static void resetState(){
		ContactState_Account accountState = new ContactState_Account();
		DataState.resetState(accountState.dataStateSearchKeys());
	}

	public static Set<Id> getAccountIds(){
		Set<Id> accountIds = new Set<Id>();
		if(records != null) {
			for(Account record: records) {
				if(String.isNotBlank(record.Id)){
					accountIds.add(record.Id);
				}
			}
		}
		return accountIds;
	}

}