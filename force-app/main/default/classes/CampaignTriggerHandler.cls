public class CampaignTriggerHandler {
    public void OnBeforeInsert(List<Campaign> newCampaignList) {
        system.debug('Campaign Trigger On Before Insert');
        CampaignTriggerActions.updateCampaignMemberRecordType(newCampaignList,null);
        CampaignTriggerActions.updateCampaignActiveCheck(newCampaignList);
        
    }
    /*
     public void OnAfterInsert(List<Campaign> newCampaignList) {
        system.debug('Campaign Trigger On Before Insert');
      //  CampaignTriggerActions.updateCampaignMemberRecordType(newCampaignList,null);
        
    }
    */
    public void OnBeforeUpdate(List<Campaign> newCampaignList, List<Campaign> oldCampaign, Map<ID, Campaign> newCampaignMap, Map<ID, Campaign> oldCampaignMap) {
        system.debug('Campaign Trigger On Before Update ');
        CampaignTriggerActions.updateCampaignMemberRecordType(newCampaignList,oldCampaignMap);
        
    }
    /*
    public void OnAfterUpdate(List<Campaign> newCampaignList, List<Campaign> oldCampaign, Map<ID, Campaign> newCampaignMap, Map<ID, Campaign> oldCampaignMap) {
        system.debug('Campaign Trigger On Before Update ');
        //CampaignTriggerActions.updateCampaignMemberRecordType(newCampaignList,oldCampaignMap);
        
    }
    */
}