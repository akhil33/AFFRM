/**
 * Created by reddy on 2022-04-07.
 */
@IsTest
private class ContactServiceTest {
    public static String testClassName = 'ContactServiceTest';
    public static DataGeneratorData dgd;

    /**
    * @Author Akhil Reddy
    * @Date 2022-04-06
    * @Testing ContactService.testSetIndustry
    * @Description populate Account_Industry__c
    */
    public class testSetIndustry extends TestifyTestClass{
        Contact oContact;
        protected override void describeTest() {
            testDescribe.setUniqueId(testClassName + '.testSetIndustry');
            testDescribe.setClassName(testClassName);
            testDescribe.setBatchSize(2);
            testDescribe.setUsingDml(false);
        }
        protected override void testSetup() {

            dgd = new DataGeneratorData();
            dgd.generateAccount(1);
            dgd.accounts[0].Industry =  'Test Industry';

            dgd.contacts.add(DataGenerator.createContact(dgd.accounts[0]));

            DataState.uow = new fflib_SObjectUnitOfWork(
                    new List<SObjectType>{
                            Account.SObjectType,
                            Contact.SObjectType
                    }
            );
            DataState.registerObjects(ContactState_Account.ACCOUNT_ID_TO_ACCOUNT_KEY, dgd.accounts);


        }
        protected override void runTest() {
            ContactState.setRecordsForStateGeneration(dgd.contacts);
            ContactService.setIndustry(dgd.contacts, new Map<Id,Contact>());
        }
        protected override void runAssertions() {
            Account existingAccount = (Account) DataState.getObject(ContactState_Account.ACCOUNT_ID_TO_ACCOUNT_KEY, dgd.contacts[0].AccountId);
            System.assertEquals(existingAccount.Industry, dgd.contacts[0].Account_Industry__c);
        }
    }
    @IsTest
    private static void testSetIndustry(){
        new testSetIndustry();
    }
}