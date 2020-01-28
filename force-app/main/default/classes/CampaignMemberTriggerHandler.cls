public class CampaignMemberTriggerHandler {

    public void OnBeforeInsert(List<CampaignMember > newInteraction) {
        system.debug('Campaign Member Trigger On Before Insert');
        CampaignMemberTriggerActions.updateSurveyStartDateAndMemberType(newInteraction);
        
    }
    public void OnAfterInsert(List<CampaignMember > newCampaignMember) {
        system.debug('Campaign Member  Trigger On After Insert');
        CampaignMemberTriggerActions.upsertClientFollowUpForCampaignMember(newCampaignMember,null);
    }
    public void OnBeforeUpdate(List<CampaignMember > newInteraction, List<CampaignMember > oldInteraction, Map<ID, CampaignMember > newInteractionMap , Map<ID, CampaignMember > oldInteractionMap) {
        system.debug('Campaign Member Trigger On Before Update ');
    }
    public void OnAfterUpdate(List<CampaignMember> newCampaignMember, List<CampaignMember> oldInteraction, Map<ID, CampaignMember> newOnlineRegistrationMap , Map<ID, CampaignMember > oldCampaignMemberMap) {
        system.debug('Campaign Member Trigger On After Update ');
        CampaignMemberTriggerActions.upsertClientFollowUpForCampaignMember(newCampaignMember,oldCampaignMemberMap);
    }
}