/**
 * Created by reddy on 2022-04-07.
 */

trigger ContactTrigger on Contact (
        before insert, before update, before delete,
        after insert, after update, after delete, after undelete)
{
    if (Utility.IsTriggerEnabled('ContactTrigger') && ContactService.triggerContextCtrl) {
        //State Layer initiation
        DataState.uow = new fflib_SObjectUnitOfWork(
                new List<SObjectType> {
                        Contact.SObjectType,
                        Account.SObjectType
                }
        );
        StateSeeder.process(new ContactState());

        //Business Layer Initiation
        Dispatcher.process(Contact.SObjectType, new ContactHandler());

        //DML Layer initiation
        DataState.uow.commitWork();
    }
}