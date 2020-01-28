public class FinancialIncentiveTriggerHandler {
    public void OnBeforeInsert(List<Financial_Incentive__c> newFinancialIncentive) {
        system.debug('FinancialIncentive Trigger On Before Insert');
        FinancialIncentiveTriggerActions.validateAccountRelationOnFinancialIncentive(newFinancialIncentive);
       // FinancialIncentiveTriggerActions.assignBIAAppLicationOwner(newFinancialIncentive);
        
    }

    public void OnBeforeUpdate(List<Financial_Incentive__c> newFinancialIncentive, Map<ID, Financial_Incentive__c> oldFinancialIncentiveMap) {
        system.debug('FinancialIncentiveTrigger On Before Update ');
        FinancialIncentiveTriggerActions.validateRejectionReason(newFinancialIncentive,oldFinancialIncentiveMap);
        FinancialIncentiveTriggerActions.validateAccountRelationOnFinancialIncentive(newFinancialIncentive);
    
    }
    
    public void OnAfterInsert(List<Financial_Incentive__c> newFinancialIncentive) {
        system.debug('FinancialIncentive Trigger On afterInsert');
        FinancialIncentiveTriggerActions.updateFinancialIncentiveNameCustom(newFinancialIncentive);
    }
  
}