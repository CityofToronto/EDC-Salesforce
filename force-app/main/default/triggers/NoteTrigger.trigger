trigger NoteTrigger on Note (after insert) {
    NoteTriggerHandler handler = new NoteTriggerHandler();
    if(Trigger.isInsert) {
            if(Trigger.isAfter) {
                try {
                    handler.OnAfterInsert(trigger.New);
                } catch (System.Exception ex) {
                    system.debug('Note After Insert Trigger Error:' + ex.getMessage());
                }
            }
    }
}