/**
 * Created by reddy on 2022-04-07.
 */

public with sharing class ContactDomain {
    public void beforeInsert(List<Contact> records){
        ContactService.setIndustry(records, new Map<Id,Contact>());
    }

    public void afterInsert(List<Contact> records){

    }

    public void beforeUpdate(List<Contact> records, Map<Id, Contact> oldRecords){
        ContactService.setIndustry(records, new Map<Id,Contact>());
    }

    public void afterUpdate(List<Contact> records, Map<Id, Contact> oldRecords){

    }

    public void beforeDelete(List<Contact> records, Map<Id, Contact> oldRecords){

    }

    public void afterDelete(List<Contact> records, Map<Id, Contact> oldRecords){

    }

    public void afterUndelete(List<Contact> records){

    }
}