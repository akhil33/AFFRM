/**
 * Created by reddy on 2022-04-07.
 */

public inherited sharing class ContactService {
    public static Boolean triggerContextCtrl= true;
    /**
    * @author Akhil
    * @date Apr 04 2022
    * @description populate Industry from Account to Contact on insert and update
    **/
    public static void setIndustry(List<Contact> records,Map<Id, Contact> oldRecords) {
        List<Contact> changedContacts;
        if(oldRecords.size() == 0){
            changedContacts = records;
        }
        if(changedContacts.size() == 0){
            return;
        }
        for(Contact record:changedContacts){
            Account existingAccount = (Account) DataState.getObject(ContactState_Account.ACCOUNT_ID_TO_ACCOUNT_KEY, record.AccountId);
            if(String.isNotBlank(existingAccount.Industry)){
                record.Account_Industry__c = existingAccount.Industry;
            }
        }
    }
}