trigger EmailMessageTrigger on EmailMessage (after insert) {

    if (trigger.isAfter && trigger.isInsert)
    {
        try {
            EmailMessageTriggerHandler.CreateCaseContact(trigger.new);
        } catch (Exception ex) {
            System.debug('Error:' + ex.getMessage());
        }

    }

}