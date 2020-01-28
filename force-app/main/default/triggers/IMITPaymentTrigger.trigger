trigger IMITPaymentTrigger on IMIT_Payment__c (after Update) {
    
    IMITPaymentTriggerHandler handler = new IMITPaymentTriggerHandler();
    if(Trigger.isAfter && Trigger.isUpdate) {
       handler.OnAfterupdate(trigger.New,trigger.OldMap);
    }

}