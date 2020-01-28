public class IMITPaymentTriggerHandler {
    public void OnAfterupdate(List<IMIT_Payment__c> newIMITPayment, Map<ID, IMIT_Payment__c> oldIMITPaymentMap) {
        system.debug('IMITPaymentTrigger On After Update ');
        IMITPaymentTriggerActions.lockCompletedRecords(newIMITPayment,oldIMITPaymentMap);
    }
}