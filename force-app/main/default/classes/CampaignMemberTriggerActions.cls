public class CampaignMemberTriggerActions{
    
    public static void updateSurveyStartDateAndMemberType(List<CampaignMember> newCampaignMemberList){
        Set<String> campIdSet = new Set<String>();
        for(CampaignMember campMem: newCampaignMemberList){
            campIdSet.add(campMem.CampaignId);
        }
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Campaign' ]){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        
        Map<Id,Campaign> campMap = new Map<Id,Campaign>([Select Id, RecordTypeId, EndDate,Group_Management_Type__c,Project_Type__c, Event_Type__c,Program_Sub_Type__c,International_Project_Type__c FROM Campaign WHERE Id IN: campIdSet]);
        system.debug('campMap +++'+campMap);
        
        for(CampaignMember updCampMem: newCampaignMemberList){
            system.debug('inside+++'+campMap);
            if(campMap.size()>0 && campMap.containsKey(updCampMem.CampaignId) && campMap.get(updCampMem.CampaignId).EndDate !=null && campMap.get(updCampMem.CampaignId).Program_Sub_Type__c != 'Online Training')
            updCampMem.Survey_Start_Date__c = campMap.get(updCampMem.CampaignId).EndDate;
            if(campMap.size()>0 && campMap.containsKey(updCampMem.CampaignId) && campMap.get(updCampMem.CampaignId).Program_Sub_Type__c != null && campMap.get(updCampMem.CampaignId).Program_Sub_Type__c == 'Online Training')
            updCampMem.Survey_Start_Date__c = date.today();
        
            if(campMap.size()>0 && campMap.get(updCampMem.CampaignId).Event_Type__c!= null && updCampMem.Member_Role__c==null){
                updCampMem.Member_Type__c = campMap.get(updCampMem.CampaignId).Event_Type__c;
                updCampMem.Member_Role__c = 'Stakeholder - Attendee';
            }
            if(campMap.size()>0 && campMap.get(updCampMem.CampaignId).Project_Type__c!= null && updCampMem.Member_Role__c==null){
                updCampMem.Member_Type__c = campMap.get(updCampMem.CampaignId).Project_Type__c; 
                if(campMap.get(updCampMem.CampaignId).International_Project_Type__c!= null && campMap.get(updCampMem.CampaignId).International_Project_Type__c == 'Outbound Mission' )
                updCampMem.Member_Role__c = 'Stakeholder - Delegate (Outbound)';                
                if(campMap.get(updCampMem.CampaignId).International_Project_Type__c!= null && campMap.get(updCampMem.CampaignId).International_Project_Type__c == 'Inbound Mission' )
                updCampMem.Member_Role__c = 'Stakeholder - Delegate (Inbound)';     
            }   
            if(campMap.size()>0 && campMap.get(updCampMem.CampaignId).Group_Management_Type__c!= null && updCampMem.Member_Role__c==null){
                updCampMem.Member_Type__c = campMap.get(updCampMem.CampaignId).Group_Management_Type__c;
                updCampMem.Member_Role__c = 'Stakeholder - Business Community';     
            }
            if(campMap.size()>0 && recTypeNameIDMap!=null && campMap.get(updCampMem.CampaignId).RecordTypeId== recTypeNameIDMap.get('Investment_Activity') && updCampMem.Member_Role__c==null){
                updCampMem.Member_Type__c = 'Investment Activity'; 
                updCampMem.Member_Role__c = 'Stakeholder - Investment Target';
            }
        }
    }
    public static void upsertClientFollowUpForCampaignMember(List<CampaignMember> newCampaignMemberList,Map<Id,CampaignMember> oldCampaignMemberMap){
        Set<String> contactIdSet = new Set<String>(); 
        //Set<String> campIdSet = new Set<String>(); 
        Map<String,Client_FollowUp__c> ContClientFollowMap = new Map<String,Client_FollowUp__c>();
        List<Client_FollowUp__c> clientFollowUpUpdateList = new List<Client_FollowUp__c>();
        List<Client_FollowUp__c> clientFollowUpInsertList = new List<Client_FollowUp__c>();
        Set<String> projectTypeSet = new Set<String>{'Business Start Up','Business Expansion'};
        Set<String> accountSet = new Set<String>(); 
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Campaign' ]){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        system.debug('++recTypeNameIDMap++'+recTypeNameIDMap);
        
        List<CampaignMember> camMemList = new List<CampaignMember>([SELECT Id, CampaignId,Campaign.RecordTypeId,ContactId, Campaign.EndDate,Campaign.Program_Sub_Type__c, Direct_Account_ID__c,Survey_Start_Date__c FROM CampaignMember WHERE (ID IN: newCampaignMemberList AND Campaign.RecordTypeId=: recTypeNameIDMap.get('Events') AND Member_Role__c = 'Stakeholder - Attendee' AND ((Campaign.Program_Sub_Type__c IN: projectTypeSet AND Initiative_Status__c = 'Completed') OR (Campaign.Program_Sub_Type__c = 'Online Training')) AND Related_Contact_Account_Type__c = 'Business Client' AND Contact.HasOptedOutOfEmail=false)]);
        system.debug('camMemList'+camMemList);
        for(CampaignMember campMem : camMemList){
            if(campMem.ContactId!=null){
                contactIdSet.add(campMem.ContactId);
                accountSet.add(campMem.Direct_Account_ID__c);
            }
        }
        system.debug('++contactIdSet++'+contactIdSet);
        List<Client_FollowUp__c> clientFollowUpList = [SELECT Account__c, Contact__c, Interaction__c, Engagement_Type__c,Workflow_Session__c , Online_Registration__c, Event__c,Survey_Start_Date__c,Initial_Survey_Completed__c,Initial_Survey_Stage__c FROM Client_FollowUp__c WHERE Contact__c IN: contactIdSet AND (Initial_Survey_Completed__c = false OR Initial_Survey_Stage__c != 'Unresponsive')];
        Map<Id,Account> accountMap = new Map<Id,Account>();
        if(accountSet!=null && accountSet.size()>0){
            accountMap = new Map<Id,Account>([SELECT Id, Account_Type__c FROM Account WHERE ID IN: accountSet]);
        }
        
        if(clientFollowUpList.size()>0){
            for(Client_FollowUp__c cfollow : clientFollowUpList){
                ContClientFollowMap.put(cfollow.Contact__c,cfollow);
            }
        }
        system.debug('++ContClientFollowMap++'+ContClientFollowMap);
        if(AvoidRecursion.isFirstRun()){ 
            for(CampaignMember campMemUpdate: camMemList){
                if(accountMap!=null && accountMap.containsKey(campMemUpdate.Direct_Account_ID__c) && accountMap.get(campMemUpdate.Direct_Account_ID__c).Account_Type__c == 'Business Client'){
                    if(ContClientFollowMap.keySet().size() > 0){
                        for(Client_FollowUp__c cfollowup :  ContClientFollowMap.Values()){
                             system.debug('++cfollowup ++'+cfollowup );
                            if(ContClientFollowMap.containsKey(campMemUpdate.ContactId) && campMemUpdate.ContactId == cfollowup.contact__c && campMemUpdate.Campaign.RecordTypeId == recTypeNameIDMap.get('Events') && (campMemUpdate.Campaign.Program_Sub_Type__c == 'Business Start Up' ||campMemUpdate.Campaign.Program_Sub_Type__c == 'Business Expansion'||campMemUpdate.Campaign.Program_Sub_Type__c == 'Online Training')){
                                system.debug('++cfollowup++'+cfollowup);
                                cfollowup.Event__c = campMemUpdate.CampaignId;
                                if(campMemUpdate.Campaign.Program_Sub_Type__c == 'Business Start Up'){
                                    if(cfollowup.Engagement_Type__c==null){
                                        cfollowup.Engagement_Type__c= 'Business Start Up Event';
                                    }else if(cfollowup.Engagement_Type__c!=null && !cfollowup.Engagement_Type__c.contains('Business Start Up Event')){
                                        cfollowup.Engagement_Type__c+= ';Business Start Up Event';
                                    }
                                    if((cfollowup.Survey_Start_Date__c!=null && cfollowup.Survey_Start_Date__c<campMemUpdate.Campaign.EndDate)||(cfollowup.Survey_Start_Date__c ==null)){
                                        cFollowUp.Workflow_Session__c = 'Business Start Up Event';
                                        cfollowup.Survey_Start_Date__c = campMemUpdate.Campaign.EndDate;
                                    }
                                }else if(campMemUpdate.Campaign.Program_Sub_Type__c == 'Online Training'){
                                    if(cfollowup.Engagement_Type__c==null){
                                        cfollowup.Engagement_Type__c= 'Online Training';
                                    }else if(cfollowup.Engagement_Type__c!=null && !cfollowup.Engagement_Type__c.contains('Online Training')){
                                        cfollowup.Engagement_Type__c+= ';Online Training';
                                    }
                                    if((cfollowup.Survey_Start_Date__c!=null && cfollowup.Survey_Start_Date__c<campMemUpdate.Survey_Start_Date__c.addDays(7)) ||(cfollowup.Survey_Start_Date__c ==null)){
                                        cFollowUp.Workflow_Session__c = 'Online Training';
                                        cfollowup.Survey_Start_Date__c = campMemUpdate.Survey_Start_Date__c.addDays(7);
                                    }   
                                }
                                else{
                                    if(cfollowup.Engagement_Type__c==null){
                                        cfollowup.Engagement_Type__c= 'Business Expansion Event';
                                     }else if(cfollowup.Engagement_Type__c!=null && !cfollowup.Engagement_Type__c.contains('Business Expansion Event')){
                                        cfollowup.Engagement_Type__c+= ';Business Expansion Event';
                                    }
                                    if((cfollowup.Survey_Start_Date__c!=null && cfollowup.Survey_Start_Date__c<campMemUpdate.Campaign.EndDate) || (cfollowup.Survey_Start_Date__c ==null)){
                                        cFollowUp.Workflow_Session__c = 'Business Expansion Event';
                                        cfollowup.Survey_Start_Date__c = campMemUpdate.Campaign.EndDate;
                                    }
                                }
                            }
                            clientFollowUpUpdateList.add(cfollowup);  
                        }
                    }
                    else{
                        Client_FollowUp__c cFolloUpNew = new Client_FollowUp__c();
                        if(campMemUpdate.Campaign.RecordTypeId == recTypeNameIDMap.get('Events')){
                            if(campMemUpdate.Campaign.Program_Sub_Type__c == 'Business Start Up' || campMemUpdate.Campaign.Program_Sub_Type__c == 'Business Expansion' || campMemUpdate.Campaign.Program_Sub_Type__c == 'Online Training' ){
                                cFolloUpNew.Contact__c = campMemUpdate.ContactId;
                                cFolloUpNew.Event__c = campMemUpdate.CampaignId;
                                cFolloUpNew.Account__c = campMemUpdate.Direct_Account_ID__c;
                                if(campMemUpdate.Campaign.Program_Sub_Type__c == 'Online Training')
                                    cFolloUpNew.Survey_Start_Date__c = campMemUpdate.Survey_Start_Date__c.addDays(7);
                                else
                                    cFolloUpNew.Survey_Start_Date__c = campMemUpdate.Campaign.EndDate;
                                if(campMemUpdate.Campaign.Program_Sub_Type__c == 'Business Start Up'){
                                    cFolloUpNew.Workflow_Session__c = 'Business Start Up Event';
                                    cFolloUpNew.Engagement_Type__c= 'Business Start Up Event';
                                }
                                else if(campMemUpdate.Campaign.Program_Sub_Type__c == 'Online Training'){
                                    cFolloUpNew.Workflow_Session__c = 'Online Training';
                                    cFolloUpNew.Engagement_Type__c= 'Online Training';
                                }else{
                                    cFolloUpNew.Workflow_Session__c = 'Business Expansion Event';
                                    cFolloUpNew.Engagement_Type__c= 'Business Expansion Event';
                                }   
                            }
                        }   
                        clientFollowUpInsertList.add(cFolloUpNew);
                    }
                }   
            }
            try{
                if(clientFollowUpUpdateList.size() > 0) {
                    Database.update(clientFollowUpUpdateList);
                }
                if(clientFollowUpInsertList.size() > 0) {
                    Database.insert(clientFollowUpInsertList);
                }
            }
            catch (Exception ex){
                System.debug('Error occurred in upsertClientFollowUpForCampaignMember: ' + ex.getMessage());
            }
        }   
    }
}