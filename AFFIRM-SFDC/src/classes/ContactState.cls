/**
* Created by Akhil on 2022-04-07.
 */

public inherited sharing class ContactState implements IStateAssignor{

	public static List<Contact> records;
    public static Map<Id, Contact> oldRecords;
	private static List<Id> accountIds;

	public static void setRecordsForStateGeneration(List<SObject> records, Map<Id, SObject> oldRecords){
		ContactState.records = (List<Contact>) records;
		ContactState.oldRecords = (Map<Id, Contact>) oldRecords;

	}

	public static void setRecordsForStateGeneration(List<Contact> records){
        ContactState.records = records;

    }

	public static void setRecordsForStateGeneration(Set<Id> recordIds){
		ContactState.records = new List<Contact>();
		for (Id recordId : recordIds) {
			Contact c = new Contact(Id = recordId);
			ContactState.records.add(c);
		}
	}

	private static void resetState(){
        ContactState_Account accountState = new ContactState_Account();
        DataState.resetState(accountState.dataStateSearchKeys());
    }

	public static Set<Id> getRecordIdsToProcess() {
		Set<Id> contactIds = new Set<Id>();
		if(records != null) {
			for(Contact record: records) {
				if(record.Id != null){
					contactIds.add(record.Id);
				}
			}
		}
		return contactIds;
	}

	public static Set<Id> getAccounts() {
		Set<Id> accIds = new Set<Id>();

		if(records != null) {
			for (Contact record : records) {
				if(String.isNotBlank(record.AccountId)) {
					accIds.add(record.AccountId);
				}
			}
		}

		if(accountIds != null && accountIds.size() > 0)
		{
			accIds.addAll(accountIds);
		}
		return accIds;
	}



	/* Needed to leave this procedure as the calling procedures will pass Accounts OR contacts without specifying which */
	public static void initContacts(Set<Id> Ids){
		Set<Id> contactIds = new Set<Id>();
		accountIds = new List<Id>();
		if(records == null)
		{
			records = new List<Contact>();
		}
		if(oldRecords == null) {
			oldRecords = new Map<Id, Contact>();
		}

		for(Id i : Ids)
		{
			if (String.valueOf(i.getSobjectType()) == 'Account')
			{
				accountIds.add(i);
			}
			else if (String.valueOf(i.getSobjectType())== 'Contact')
			{
				contactIds.add(i);
			}
		}

		if(contactIds.size() > 0) {
			setRecordsForStateGeneration(contactIds);
		}
	}
}