trigger CampaignTrigger on Campaign (before insert, before update) {
    
    CampaignTriggerHandler handler = new CampaignTriggerHandler();
    if(Trigger.isInsert) {
        if(Trigger.isBefore) {
            handler.OnBeforeInsert(trigger.New);
        }
        /*
        else
        {
            handler.OnAfterInsert(trigger.New);
        }
        */
    }
    else if(Trigger.isUpdate) {
        if(Trigger.isBefore) {
            handler.OnBeforeUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        /*
        else
        {
            handler.OnAfterUpdate(trigger.New ,trigger.Old,Trigger.NewMap,Trigger.OldMap);
        }
        */
    }
}