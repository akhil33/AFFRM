/**
 * Created by Akhil.
 * This class was created to generate testing and sandbox data using default values for required fields.
 * This was created to replace the testOrgnization class to put some order and logic to data creation.
 */

public with sharing class DataGenerator {



    /**
     * @author Akhil
     * @return Account: Account Obj
     */
    public static Account createAccount()
    {
        Account dgAccount = new Account(
                Name = 'Test Account',
                Industry = 'Adult',
                BillingCountry = 'Canada',
                BillingState = 'ON',
                AnnualRevenue = 25000
        );
        return dgAccount;
    }


    /**
     * @author Akhil
     * @param dgAccount: Account Obj
     * @return : Contact Obj
     */
    public static Contact createContact()
    {
        Contact dgContact =    new Contact(
                LastName='Test'
                ,LeadSource = 'Contact Us'
                ,Email = Util.randomStringGenerator(25) + '@testify.com'
        );
        return dgContact;
    }

    /**
     * @author Akhil
     * @param dgAccount: Account Obj
     * @return : Contact Obj
     */
    public static Contact createContact(Account dgAccount)
    {
        Contact dgContact =    createContact();
        dgContact.Account = dgAccount;
        dgContact.AccountId = dgAccount.Id;
        return dgContact;
    }
}