public class CampaignTriggerActions{
    public static void updateCampaignMemberRecordType(List<Campaign> newCampaignList,Map<Id,Campaign> oldCampaignMap){
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE (SobjectType = 'CampaignMember' OR SobjectType = 'Campaign')]){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        Set<String> projectTypeSet = new Set<String>{'Business Start Up','Business Expansion','Online Training'};
        for(Campaign camp: newCampaignList){
            system.debug('camp++'+camp);
            if(camp.RecordTypeId == recTypeNameIDMap.get('Events') && (projectTypeSet.contains(camp.Program_Sub_Type__c) || camp.Event_Type__c=='Networking Events'))
                camp.CampaignMemberRecordTypeId = recTypeNameIDMap.get('Business_Training_Campaign_Member');
            if(camp.RecordTypeId == recTypeNameIDMap.get('Events') && camp.Program_Sub_Type__c=='International Events' )
                camp.CampaignMemberRecordTypeId = recTypeNameIDMap.get('International_Program_Member');
            if(camp.RecordTypeId == recTypeNameIDMap.get('Projects') && camp.Project_Type__c=='International Project' && camp.International_Project_Type__c=='Outbound Mission' )
                camp.CampaignMemberRecordTypeId = recTypeNameIDMap.get('Mission_Campaign_Member');
        }    
        //Below Logic for updating related Campaign Member Record Survey Start Date
        Map<String,Campaign> camMap = new Map<String,Campaign>(); 
        List<CampaignMember> camMemList = new List<CampaignMember>();
        for(Campaign camp: newCampaignList){
            if(((camp.EndDate!=null && oldCampaignMap!=null && camp.EndDate!=oldCampaignMap.get(camp.Id).EndDate) || (camp.EndDate!=null && oldCampaignMap==null) || (camp.Status!=null && camp.Status=='Completed' && oldCampaignMap!=null && camp.Status!=oldCampaignMap.get(camp.Id).Status) || (camp.Status!=null && camp.Status=='Completed' && oldCampaignMap==null)) && camp.RecordTypeId != recTypeNameIDMap.get('Group_Management') && camp.RecordTypeId != recTypeNameIDMap.get('Investment_Activity')){
                camMap.put(camp.Id,camp); 
            }
        }
        system.debug('camMap+++'+camMap);
        for(CampaignMember camMem: [SELECT Id, Survey_Start_Date__c, CampaignId, Campaign.Program_Sub_Type__c FROM CampaignMember WHERE CampaignId IN: camMap.keySet() AND Campaign.Program_Sub_Type__c!='Online Training']){
            system.debug('camMem+++'+camMem);
            if(camMem.Survey_Start_Date__c!= camMap.get(camMem.CampaignId).EndDate || camMap.get(camMem.CampaignId).Status == 'Completed'){
                camMem.Survey_Start_Date__c = camMap.get(camMem.CampaignId).EndDate;
                if(camMap.get(camMem.CampaignId).Status == 'Completed'){
                    camMem.Initiative_Status__c = 'Completed';
                }   
                camMemList.add(camMem);                 
            }
        }
        if(camMemList!=null){
            Database.update(camMemList);
        }
    }
    public static void updateCampaignActiveCheck(List<Campaign> newCampaignList){
        for(Campaign camp: newCampaignList){
            if(camp.IsActive== false)
            camp.IsActive= true;
        }
    }
}