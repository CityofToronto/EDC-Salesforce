trigger IssueTrigger on Issue__c (before insert,after insert,before Update) {
   IssueTriggerHandler handler = new IssueTriggerHandler ();
   if(Trigger.isInsert) {
        if(Trigger.isBefore) {
            handler.OnBeforeInsert(trigger.New);
        }
        else{
            handler.OnAfterInsert(trigger.New);
        }
       
    }
    else if(Trigger.isUpdate) {
        if(Trigger.isBefore) {
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
}