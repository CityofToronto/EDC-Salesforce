public class OnlineRegTriggerActions{
    
    public static void upsertClientFollowUpForOnlineReg(List<Online_Registration__c> newOnlineRegistrationList,Map<Id,Online_Registration__c> oldOnlineRegistrationMap){
        Set<String> contactSet = new Set<String>(); 
        Map<String,Client_FollowUp__c> ContClientFollowMap = new Map<String,Client_FollowUp__c>();
        List<Client_FollowUp__c> clientFollowUpUpdateList = new List<Client_FollowUp__c>();
        List<Client_FollowUp__c> clientFollowUpInsertList = new List<Client_FollowUp__c>();
        Set<String> accountSet = new Set<String>();
        
        for(Online_Registration__c oreg : newOnlineRegistrationList){
            if(oreg.Contact__c!=null)
            contactSet.add(oreg.Contact__c);
            accountSet.add(oreg.Account__c);
        }
        Map<Id,Account> accountMap = new Map<Id,Account>();
        if(accountSet!=null && accountSet.size()>0){
            accountMap = new Map<Id,Account>([SELECT Id, Account_Type__c FROM Account WHERE ID IN: accountSet]);
        }
        List<Client_FollowUp__c> clientFollowUpList = [SELECT Account__c, Contact__c, Engagement_Type__c,Workflow_Session__c ,Interaction__c, Online_Registration__c, Event__c, Survey_Start_Date__c,Initial_Survey_Completed__c,Initial_Survey_Stage__c  FROM Client_FollowUp__c WHERE Contact__c IN: contactSet AND (Initial_Survey_Completed__c = false OR Initial_Survey_Stage__c != 'Unresponsive')];
        if(clientFollowUpList.size()>0){
            for(Client_FollowUp__c cfollow : clientFollowUpList){
                ContClientFollowMap.put(cfollow.Contact__c,cfollow);
            }
        }
        if(AvoidRecursion.isFirstRun()){ 
            for(Online_Registration__c oregToUpdate: newOnlineRegistrationList){
                if(accountMap!=null && accountMap.containsKey(oregToUpdate.Account__c) && accountMap.get(oregToUpdate.Account__c).Account_Type__c == 'Business Client'){
                    if(ContClientFollowMap.keySet().size() > 0){
                    for(Client_FollowUp__c cfollowup :  ContClientFollowMap.Values()){
                            if(ContClientFollowMap.containsKey(oregToUpdate.Contact__c) && oregToUpdate.Contact__c == cfollowup.contact__c){
                                cfollowup.Online_Registration__c = oregToUpdate.Id;
                                if(cfollowup.Engagement_Type__c==null){
                                    cfollowup.Engagement_Type__c= 'Online Registration';
                                }else if(cfollowup.Engagement_Type__c!=null && !cfollowup.Engagement_Type__c.contains('Online Registration')){
                                        cfollowup.Engagement_Type__c+= ';Online Registration';
                                }
                                if(cfollowup.Survey_Start_Date__c!=null && cfollowup.Survey_Start_Date__c<oregToUpdate.CreatedDate.date()){
                                    cfollowup.Workflow_Session__c = 'Online Registration';
                                    cfollowup.Survey_Start_Date__c = oregToUpdate.CreatedDate.date();
                                }
                               clientFollowUpUpdateList.add(cfollowup);  
                            }
                        }
                    }
                    else{
                        Client_FollowUp__c cFolloUpNew = new Client_FollowUp__c();
                        cFolloUpNew.Online_Registration__c = oregToUpdate.Id;
                        cFolloUpNew.Contact__c = oregToUpdate.Contact__c;
                        cFolloUpNew.Account__c = oregToUpdate.Account__c;
                         cFolloUpNew.Survey_Start_Date__c = oregToUpdate.CreatedDate.date();
                        cFolloUpNew.Workflow_Session__c = 'Online Registration';
                        cFolloUpNew.Engagement_Type__c= 'Online Registration';
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
                System.debug('Error occurred in upsertClientFollowUpForOnlineRegistration: ' + ex.getMessage());
            }
        }
    }
    
}