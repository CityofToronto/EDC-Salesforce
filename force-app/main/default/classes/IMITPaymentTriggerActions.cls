public class IMITPaymentTriggerActions{
    public static void lockCompletedRecords( List<IMIT_Payment__c> newIMITPaymentList, Map<ID, IMIT_Payment__c> oldIMITPaymentMap){
        List<IMIT_Payment__c> lstIMITLock = new List<IMIT_Payment__c>();
        for(IMIT_Payment__c imPay: newIMITPaymentList){
            system.debug('++imPay++'+imPay);
            if ((imPay.Payment_Status__c == 'Compliance Approved' && oldIMITPaymentMap.get(imPay.Id).Payment_Status__c != 'Compliance Approved')||(imPay.Payment_Status__c == 'Terminated' && oldIMITPaymentMap.get(imPay.Id).Payment_Status__c != 'Terminated')){ 
                lstIMITLock.add(imPay); 
            }
            system.debug('++lstIMITLock++'+lstIMITLock);
            if(lstIMITLock.size()>0 && lstIMITLock!=null){
                // Lock the accounts
                Approval.LockResult[] lrList = Approval.lock(lstIMITLock, false);
                // Iterate through each returned result
                for(Approval.LockResult lr : lrList) {
                    if (lr.isSuccess()) {
                        // Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully locked Financial Incentive with ID: ' + lr.getId());
                    }
                    else{
                        // Operation failed, so get all errors                
                        for(Database.Error err : lr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Financial Incentive fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
    
    }
}