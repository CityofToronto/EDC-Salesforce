trigger CampaignMemberTrigger on CampaignMember (after insert, after update, before insert, before update) {
    
    CampaignMemberTriggerHandler handler = new CampaignMemberTriggerHandler();
    
    if(Trigger.isInsert) {
        if(Trigger.isAfter) {
            handler.OnAfterInsert(trigger.New);
        }else{
             handler.OnBeforeInsert(trigger.New);
        }
    }
    else if(Trigger.isUpdate) {
        if(Trigger.isAfter) {
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }else{
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);        
        }    
    }
}