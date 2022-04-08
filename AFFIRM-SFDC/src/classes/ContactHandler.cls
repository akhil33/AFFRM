/**
 * Created by reddy on 2022-04-07.
 */

public inherited sharing class ContactHandler extends TriggerHandler{
    private Map<String, List<SObject>> domainNamesToSortedRecords = new Map<String, List<SObject>>();

    public override void beforeInsert(List<SObject> records){
        ContactState.setRecordsForStateGeneration(records);
        new ContactDomain().beforeInsert(records);

        initRecords(records);
    }

    public override void afterInsert(List<SObject> records){
        ContactState.setRecordsForStateGeneration(records);
        new ContactDomain().afterInsert(records);

        initRecords(records);

    }

    public override void beforeUpdate(List<SObject> records, Map<Id, SObject> oldRecords){
        ContactState.setRecordsForStateGeneration(records, oldRecords);
        // run domain common service functions
        new ContactDomain().beforeUpdate(records, (Map<Id, Contact>) oldRecords);

        initRecords(records);
        // run domain based service functions
    }

    public override void afterUpdate(List<SObject> records, Map<Id, SObject> oldRecords){
        ContactState.setRecordsForStateGeneration(records, oldRecords);
        new ContactDomain().afterUpdate(records, (Map<Id, Contact>) oldRecords);

        initRecords(records);

    }

    public override void beforeDelete(List<SObject> records, Map<Id, SObject> oldRecords){
        new ContactDomain().beforeDelete(records, (Map<Id, Contact>) oldRecords);

        initRecords(records);

    }

    public override void afterDelete(List<SObject> records, Map<Id, SObject> oldRecords){
        new ContactDomain().afterDelete(records, (Map<Id, Contact>) oldRecords);

        initRecords(records);

    }

    public override void afterUndelete(List<SObject> records){
        new ContactDomain().afterUndelete(records);
        initRecords(records);

    }

    // initRecords does the real work. Here we split the records based on whatever criteria we want. like segregating based on record types or business process
    private void initRecords(List<SObject> records){
        domainNamesToSortedRecords.put(SystemConstants.Domain.ContactAll, new List<SObject>());

        for(SObject record : records){
            domainNamesToSortedRecords.get(SystemConstants.Domain.ContactAll).add(record);
        }
    }
}