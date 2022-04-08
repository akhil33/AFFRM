/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 04-08-2022
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class LWCDemo {
   @AuraEnabled
   public static List<Account> retrieveAccountList(){
       try {
        return [select id,name from account limit 5];
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }


   @AuraEnabled
   public static Account retrieveAccountRecord(String accountId){
       try {
        return [select id,name,industry,type,owner.name,owner.SmallPhotoUrl from account where id=:accountId];
       } catch (Exception e) {
           throw new AuraHandledException(e.getMessage());
       }
   }
    
}