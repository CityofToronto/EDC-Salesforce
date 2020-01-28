trigger OnlineRegistrationTrigger on Online_Registration__c (after insert, after update) {

    OnlineRegistrationTriggerHandler handler = new OnlineRegistrationTriggerHandler();
    
    if(Trigger.isInsert) {
        if(Trigger.isAfter) {
            handler.OnAfterInsert(trigger.New);
        }
    }
    else if(Trigger.isUpdate) {
        if(Trigger.isAfter) {
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }
  
}