/*


*/
trigger AccountTrigger on Account(before insert, before update) {

    AccountTriggerHandler handler = new AccountTriggerHandler();
    
    if(Trigger.isInsert) {
        if(Trigger.isBefore) {
            handler.OnBeforeInsert(trigger.New);
        }
       
    }
    else if(Trigger.isUpdate) {
        if(Trigger.isBefore) {
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }    
}