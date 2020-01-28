/*


*/
trigger InteractionTrigger on Interaction__c (before insert, before update, after insert, after update, after delete) {

    if(System.Label.RunInteractionTrigger == 'true'){
        InteractionTriggerHandler handler = new InteractionTriggerHandler();
        
        if(Trigger.isInsert) {
            if(Trigger.isBefore) {
                handler.OnBeforeInsert(trigger.New);
            }
            
            else
            {
                handler.OnAfterInsert(trigger.New);
            }
        }
        else if(Trigger.isUpdate) {
            if(Trigger.isBefore) {
                handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
            }
            else
            {
                handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
            }
        }
        if(Trigger.isDelete){
            handler.OnAfterDelete(trigger.Old,Trigger.OldMap);
        }
  
    }
}