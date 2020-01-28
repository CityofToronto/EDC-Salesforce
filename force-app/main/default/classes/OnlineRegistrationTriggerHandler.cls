public class OnlineRegistrationTriggerHandler {
    public void OnAfterInsert(List<Online_Registration__c > newOnlineRegistration) {
        system.debug('Online Registration Trigger On After Insert');
        OnlineRegTriggerActions.upsertClientFollowUpForOnlineReg(newOnlineRegistration,null);
    }
    
    public void OnAfterUpdate(List<Online_Registration__c> newOnlineRegistration, List<Online_Registration__c> oldInteraction, Map<ID, Online_Registration__c> newOnlineRegistrationMap , Map<ID, Online_Registration__c > oldOnlineRegistrationMap) {
        system.debug('Online Registration Trigger On After Update ');
        OnlineRegTriggerActions.upsertClientFollowUpForOnlineReg(newOnlineRegistration,oldOnlineRegistrationMap);
    }
}