trigger AgreementTrigger on International_Agreement__c (before insert, before update) {

    AgreementTriggerHandler handler = new AgreementTriggerHandler();
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
            handler.OnBeforeInsert(trigger.New);
        }
        else{
             handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
    }        
}