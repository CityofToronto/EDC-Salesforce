trigger FinancialIncentiveTrigger on Financial_Incentive__c (before insert,before Update, after Insert,after Update) {
  FinancialIncentiveTriggerHandler handler = new FinancialIncentiveTriggerHandler ();
  if(System.Label.RunFinIncentiveTrigger== 'true'){
      if(Trigger.isBefore && Trigger.isInsert) {
            handler.OnBeforeInsert(trigger.New);
       }
       if(Trigger.isBefore && Trigger.isUpdate) {
           handler.OnBeforeUpdate(trigger.New,trigger.OldMap);
       }
       if(Trigger.isAfter && Trigger.isInsert) {
           handler.OnAfterInsert(trigger.New);
       }
    }    
}