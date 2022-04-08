/**
 * Created by reddy on 2022-04-08.
 */

public with sharing class AccountsListPOCController {
    @AuraEnabled(Cacheable=true)
    public static List<Account> retrieveAccountRecords(){
        List<Account> accList = [
                SELECT
                        Id, Name, Phone, Industry, Description
                FROM
                        Account
                ORDER BY CreatedDate DESC LIMIT 5];
        return accList;
    }

    @AuraEnabled
    public static Account retrieveAccountRecord(String accountId){
        try {
            return [
                    SELECT
                            Id, Name, Industry, Type, Owner.Name, Owner.SmallPhotoUrl
                    FROM
                            Account
                    WHERE
                            Id=:accountId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}