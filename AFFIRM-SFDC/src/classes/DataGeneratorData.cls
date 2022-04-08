

public with sharing class DataGeneratorData {
    public List<Account> accounts {
        get {
            if (accounts == null) {
                accounts = new List<Account>();
            }
            return accounts;
        }
        set {
            if (accounts.size() > 0) {
                Map<Id, Account> mapAccounts = new Map<Id, Account>();
                mapAccounts.putAll(value);
                mapAccounts.putAll(accounts);
                accounts = mapAccounts.values();
            } else {
                accounts = new List<Account>();
                accounts.addAll(value);
            }
        }
    }


    public void generateAccount(Integer numAccounts){
        generateAccount(numAccounts,'');
    }

    public void generateAccount(Integer numAccounts, String accountDeveloperRecordTypeName){
        for(Integer i = 0; i < numAccounts; i++)
        {
            Account dgdAccount = DataGenerator.createAccount();
            dgdAccount.Name = dgdAccount.Name + ' ' + i;
            dgdAccount.Id = Util.generateRandomId(Account.SObjectType);
            accounts.add(dgdAccount);
        }
    }

    public List<Contact> contacts {
        get {
            if (contacts == null) {
                contacts = new List<Contact>();
            }
            return contacts;
        }
        set {
            if (contacts.size() > 0) {
                Map<Id, Contact> mapAccounts = new Map<Id, Contact>();
                mapAccounts.putAll(value);
                mapAccounts.putAll(contacts);
                contacts = mapAccounts.values();
            } else {
                contacts = new List<Contact>();
                contacts.addAll(value);
            }
        }
    }
    public void generateContacts(Integer numContacts){
        for(Integer i = 0; i < numContacts; i++)
        {
            Contact dgdContact = DataGenerator.createContact();
            dgdContact.Id = Util.generateRandomId(Contact.SObjectType);
            contacts.add(dgdContact);
        }
    }

}