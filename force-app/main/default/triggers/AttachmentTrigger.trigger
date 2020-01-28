trigger AttachmentTrigger on Attachment (after insert) {
    AttachmentTriggerHandler handler = new AttachmentTriggerHandler();
    if(Trigger.isInsert) {
            if(Trigger.isAfter) {
                try {
                    handler.OnAfterInsert(trigger.New);
                } catch (System.Exception ex) {
                    system.debug('Attachment After Insert Trigger Error:' + ex.getMessage());
                }
            }
    }
}