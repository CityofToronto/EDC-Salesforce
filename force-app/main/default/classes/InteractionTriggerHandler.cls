public class InteractionTriggerHandler {
    public void OnBeforeInsert(List<Interaction__c > newInteraction) {
        system.debug('Interaction Trigger On Before Insert');
        InteractionTriggerActions.validateAccContRelation(newInteraction,null);
        
    }
    public void OnAfterInsert(List<Interaction__c > newInteraction) {
        system.debug('Interaction Trigger On After Insert');
        InteractionTriggerActions.upsertClientFollowUpForInteraction(newInteraction,null);
        InteractionTriggerActions.updateInterCountOnAccount(newInteraction,null);
    }
    public void OnBeforeUpdate(List<Interaction__c> newInteraction, List<Interaction__c> oldInteraction, Map<ID, Interaction__c> newInteractionMap , Map<ID, Interaction__c> oldInteractionMap) {
        system.debug('Interaction Trigger On Before Update ');
        InteractionTriggerActions.validateAccContRelation(newInteraction,oldInteractionMap);
        
    }
    public void OnAfterUpdate(List<Interaction__c> newInteraction, List<Interaction__c> oldInteraction, Map<ID, Interaction__c> newInteractionMap , Map<ID, Interaction__c > oldInteractionMap) {
        system.debug('Interaction Trigger On After Update ');
        InteractionTriggerActions.upsertClientFollowUpForInteraction(newInteraction,oldInteractionMap);
        InteractionTriggerActions.updateInterCountOnAccount(newInteraction,oldInteractionMap);
        InteractionTriggerActions.createEventForConfirmedConsultation(newInteraction,oldInteractionMap);
    }
    public void OnAfterDelete(List<Interaction__c> oldInteraction, Map<ID, Interaction__c > oldInteractionMap) {
        system.debug('Interaction Trigger On After Delete');
        InteractionTriggerActions.updateInterCountOnAccount(oldInteraction,oldInteractionMap);
    }
}