

public inherited sharing class ContactState_Account implements IStateGenerator{
    public static final String ACCOUNT_ID_TO_ACCOUNT_KEY = 'ExistingAccountsById';
    public List<String> dataStateSearchKeys() {
        return new List<String>{
                ACCOUNT_ID_TO_ACCOUNT_KEY
        };
    }

    public void generateState() {
        DataState.registerObjectType(ACCOUNT_ID_TO_ACCOUNT_KEY);
        Set<Id> accIds = ContactState.getAccounts();
        List<Account> accounts = new List<Account>();

        for(Account existingAccount : [ SELECT
                                            Id, Industry
                                        FROM
                                                Account
                                        WHERE
                                           Id IN: accIds]){


            if(accIds.contains(existingAccount.Id)){
                accounts.add(existingAccount);
            }
        }

        if(!accounts.isEmpty()){
            DataState.registerObjects(ACCOUNT_ID_TO_ACCOUNT_KEY, accounts);
        }

    }

}