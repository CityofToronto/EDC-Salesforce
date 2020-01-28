public class AgreementTriggerHandler {
    public void OnBeforeInsert(List<International_Agreement__c> newAgreement) {
        system.debug('Agreement Trigger On Before Insert');
        AgreementTriggerActions.validateAccountRelationOnAgreement(newAgreement);
        AgreementTriggerActions.updateAgreementOwnerOnAgreement(newAgreement);
    }
    public void OnBeforeUpdate(List<International_Agreement__c> newAgreement, List<International_Agreement__c> oldAgreement, Map<ID, International_Agreement__c> newAgreementMap , Map<ID, International_Agreement__c> oldAgreementMap) {
        system.debug('AgreementTrigger On Before Update ');
        AgreementTriggerActions.validateAccountRelationOnAgreement(newAgreement);
        AgreementTriggerActions.updateAgreementOwnerOnAgreement(newAgreement);
    }
}