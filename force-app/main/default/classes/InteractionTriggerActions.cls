public class InteractionTriggerActions{
    public static void validateAccContRelation(List<Interaction__c> newInteractionList,Map<Id,Interaction__c> oldInteractionMap){
        Map<Id, Set<String>> accountToRelatedContacts = new Map<Id, Set<String>>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> contIdSet = new Set<Id>();
        Set<Id> personAccountIdSet = new Set<Id>();
        Set<Id> busAccountIdSet = new Set<Id>();
        Set<Id> personContIdSet = new Set<Id>();
        Set<Id> busContIdSet = new Set<Id>();
        
        Map<Id,Account> accNewMap ;
        Map<Id,Contact> contNewMap;
        
        for(Interaction__c intr: newInteractionList){
            accIdSet.add(intr.Account__c);
            contIdSet.add(intr.Contact__c);
        }
        system.debug('++contIdSet++'+contIdSet);
        system.debug('++accIdSet++'+accIdSet);
        if(accIdSet!=null){
            for(Account acc: [SELECT ID,Name,IsPersonAccount From Account WHERE ID IN:accIdSet]){
                system.debug('++acc++'+acc);
                system.debug('++ac.IsPersonAccount++'+acc.IsPersonAccount);
                if(acc.IsPersonAccount)
                personAccountIdSet.add(acc.Id);
                if(!acc.IsPersonAccount)
                busAccountIdSet.add(acc.Id);
            }
        }   
        if(contIdSet!=null){
        for(Contact con: [SELECT ID,LastName,IsPersonAccount From Contact WHERE ID IN:contIdSet]){
                if(con.IsPersonAccount)
                personContIdSet.add(con.Id);
                if(!con.IsPersonAccount)
                busContIdSet.add(con.Id);
            }
        }
        if(busAccountIdSet!=null || busContIdSet!=null){
            for(AccountContactRelation accCon: [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE AccountId IN: busAccountIdSet OR ContactId IN: busContIdSet]){
                if(!accountToRelatedContacts.containsKey(accCon.AccountId)){
                    accountToRelatedContacts.put(accCon.AccountId, new Set<String>{accCon.ContactId});
                    system.debug('++accountToRelatedContactsinside++'+accountToRelatedContacts);
                }else{
                    accountToRelatedContacts.get(accCon.AccountId).add(accCon.ContactId);
                }
            }
            system.debug('++accountToRelatedContacts++'+accountToRelatedContacts);
            system.debug('++busContIdSet++'+busContIdSet);
            system.debug('++personContIdSet++'+personContIdSet);
            system.debug('++personAccountIdSet++'+personAccountIdSet);
            system.debug('++busAccountIdSet++'+busAccountIdSet);
            for(Interaction__c intrCheck: newInteractionList){
                system.debug('++intrCheck++'+intrCheck);
                if(intrCheck.Account__c!=null && intrCheck.Contact__c!=null && busAccountIdSet.contains(intrCheck.Account__c) && busContIdSet.contains(intrCheck.Contact__c) && (!accountToRelatedContacts.containsKey(intrCheck.Account__c) || (accountToRelatedContacts.containsKey(intrCheck.Account__c) && !accountToRelatedContacts.get(intrCheck.Account__c).contains(intrCheck.Contact__c)))){
                    intrCheck.adderror('Account and Contact are not related to each other');
                }
                else if(intrCheck.Account__c!=null && intrCheck.Contact__c!=null && ((personAccountIdSet.contains(intrCheck.Account__c) && !personContIdSet.contains(intrCheck.Contact__c)) || (!personAccountIdSet.contains(intrCheck.Account__c) && personContIdSet.contains(intrCheck.Contact__c)))){
                    intrCheck.adderror('Same Person Account need to be specified for both Account and Contact ');
                }   
            }
        }
        // Below logic to update Interaction record type associated to Person Account
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Interaction__c']){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        
        Map<Id,Account> personAccountMap = new Map<Id,Account>([SELECT Id, Name, IsPersonAccount FROM Account WHERE ID IN:accIdSet]);
        for(Interaction__c  intr: newInteractionList){
            if(personAccountMap!=null && personAccountMap.containsKey(intr.Account__c) && personAccountMap.get(intr.Account__c).IsPersonAccount && intr.RecordTypeId==recTypeNameIDMap.get('Company_Intelligence'))
                intr.RecordTypeId = recTypeNameIDMap.get('Company_Intelligence_Person_Account');
            else if(personAccountMap!=null && personAccountMap.containsKey(intr.Account__c) && personAccountMap.get(intr.Account__c).IsPersonAccount && intr.RecordTypeId==recTypeNameIDMap.get('Consultation'))
                intr.RecordTypeId = recTypeNameIDMap.get('Consultation_Person_Account');
        }
        //Below Logic to update Survey Start Date
        for(Interaction__c intr: newInteractionList){
            if(intr.Meeting_Date__c!=null){
                intr.Survey_Start_Date__c = intr.Meeting_Date__c;   
            }
            else if(intr.Meeting_Date__c==null && intr.Follow_Up_Consultation_Type__c != 'Follow-Up for Online clients')
                intr.Survey_Start_Date__c = intr.Date_of_Contact__c;
            system.debug('intr.Survey_Start_Date__c++'+intr.Survey_Start_Date__c);
        }
        
        //Below Logic to update new User field for email Notificaiton
        for(Interaction__c intr: newInteractionList){
            if(intr.Advisor_Lookup__c!=null){
                intr.User_to_Notify__c = intr.Advisor_Lookup__c;   
            }
            else if(oldInteractionMap==null && UserInfo.getUserId()!='0051N0000078NiC'){
                 intr.User_to_Notify__c = UserInfo.getUserId();
            }
        }
    }
    public static void upsertClientFollowUpForInteraction(List<Interaction__c> newInteractionList,Map<Id,Interaction__c> oldInteractionMap){
        Set<String> contactSet = new Set<String>(); 
        Set<String> accountSet = new Set<String>(); 
        Map<String,Client_FollowUp__c> ContClientFollowMap = new Map<String,Client_FollowUp__c>();
        List<Client_FollowUp__c> clientFollowUpUpdateList = new List<Client_FollowUp__c>();
        List<Client_FollowUp__c> clientFollowUpInsertList = new List<Client_FollowUp__c>();
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        Set<String> purposeofInteractionSet = new Set<String>{'Attraction - Investment Attraction (Foreign)**','Attraction - Investment Attraction (Local & National)**','Business Development - Expansion Assistance**','Business Development - Export Assistance**','Business Development - Import Assistance**','Business Development - Location Assistance**','Business Development - Market Development**','Business Development - Startup Assistance**','Business Development - Workforce Development**','City - Building Permit**','City - Planning Issue (OP & ZBL)**','City - Preliminary Project Review**','City - Property Standards**','City - Property Taxes**','City - Regulatory**','Regulatory - Federal**','Regulatory - Provincial**','Utility - Electric**','Utility - Gas**','Utility - Water**'};
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Interaction__c' ]){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        for(Interaction__c intr : newInteractionList){
            if(intr.Contact__c!=null)
            contactSet.add(intr.Contact__c);
            accountSet.add(intr.Account__c);
        }
        system.debug('contactSet+++11'+contactSet);
        List<Client_FollowUp__c> clientFollowUpList = [SELECT Account__c, Contact__c, Engagement_Type__c,Workflow_Session__c , Interaction__c, Online_Registration__c, Event__c, Survey_Start_Date__c,Initial_Survey_Completed__c,Initial_Survey_Stage__c FROM Client_FollowUp__c WHERE Contact__c IN: contactSet AND Initial_Survey_Stage__c != 'Responded' AND Initial_Survey_Stage__c != 'Unresponsive'];
        system.debug('clientFollowUpList+++11'+clientFollowUpList);
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, Account_Type__c FROM Account WHERE ID IN: accountSet]);
        if(clientFollowUpList.size()>0){
            for(Client_FollowUp__c cfollow : clientFollowUpList){
                ContClientFollowMap.put(cfollow.Contact__c,cfollow);
            }
        }
        system.debug('ContClientFollowMap+++11'+ContClientFollowMap);
        if(AvoidRecursion.isFirstRun()){   
            for(Interaction__c intToUpdate: newInteractionList){
            List<String> tmpString = new List<String>();
            boolean allowBusOutcome = false; 
                if(intToUpdate.Survey_Start_Date__c!=null && accountMap!=null && accountMap.containsKey(intToUpdate.Account__c) && accountMap.get(intToUpdate.Account__c).Account_Type__c == 'Business Client'){
                    if(ContClientFollowMap.keySet().size() > 0){
                        for(Client_FollowUp__c cfollowup :  ContClientFollowMap.Values()){
                            if(ContClientFollowMap.containsKey(intToUpdate.Contact__c) && intToUpdate.Contact__c == cfollowup.contact__c){
                                system.debug('Inside+++12121'+cfollowup);
                                if((intToUpdate.RecordTypeId == recTypeNameIDMap.get('Consultation_Person_Account') || intToUpdate.RecordTypeId == recTypeNameIDMap.get('Consultation')) && ((intToUpdate.Follow_Up_Consultation_Type__c =='Follow-Up for Online clients' && intToUpdate.Advisor_Lookup__c  !=null && intToUpdate.Meeting_Date__c!=null && intToUpdate.Location__c!=null && trigger.isUpdate && intToUpdate.Meeting_Status__c=='Completed') || (((intToUpdate.Follow_Up_Consultation_Type__c =='Follow-Up for Walk in clients' && intToUpdate.Meeting_Date__c!=null) ||(intToUpdate.Follow_Up_Consultation_Type__c !='Follow-Up for Walk in clients' && intToUpdate.Follow_Up_Consultation_Type__c !='Follow-Up for Online clients' && intToUpdate.Date_of_Contact__c!=null)) && trigger.isInsert))){
                                    cfollowup.Interaction__c = intToUpdate.Id;
                                    if(cfollowup.Engagement_Type__c==null){
                                        cfollowup.Engagement_Type__c= 'Consultation Interaction';
                                    }else{
                                        if(!cfollowup.Engagement_Type__c.contains('Consultation Interaction'))
                                        cfollowup.Engagement_Type__c+= ';Consultation Interaction';
                                    }
                                    if(cfollowup.Survey_Start_Date__c!=null && cfollowup.Survey_Start_Date__c<intToUpdate.Survey_Start_Date__c){
                                        cfollowup.Workflow_Session__c = 'Consultation Interaction';
                                        cfollowup.Survey_Start_Date__c = intToUpdate.Survey_Start_Date__c;
                                    }
                                }
                                else if(intToUpdate.RecordTypeId == recTypeNameIDMap.get('Company_Intelligence_Person_Account') || intToUpdate.RecordTypeId == recTypeNameIDMap.get('Company_Intelligence') && trigger.isInsert){
                                    system.debug('Inside+++11');
                                    if(intToUpdate.Purpose_of_the_Interaction__c!=null){
                                        tmpString.addAll(intToUpdate.Purpose_of_the_Interaction__c.split(';'));
                                        system.debug('tmpString222+++'+tmpString);
                                        for(integer i=0;i<tmpString.size();i++){
                                            system.debug('tmpString3333+++'+tmpString);
                                            if(purposeofInteractionSet.contains(tmpString[i])){
                                                system.debug('tmpString3333+++'+tmpString);
                                            //if(purposeofInteractionSet.contains(tmpString[i]) && accountMap!=null && accountMap.containsKey(intToUpdate.Account__c) && accountMap.get(intToUpdate.Account__c).Account_Type__c == 'Business Client')
                                            allowBusOutcome =true;
                                            }
                                        }
                                    }
                                    if(allowBusOutcome){  
                                        system.debug('allowBusOutcome+++'+allowBusOutcome);                                 
                                        cfollowup.Interaction__c= intToUpdate.Id;
                                        if(cfollowup.Engagement_Type__c==null){
                                            cfollowup.Engagement_Type__c= 'Company Intelligence Interaction';
                                        }else{
                                            if(!cfollowup.Engagement_Type__c.contains('Company Intelligence Interaction'))
                                            cfollowup.Engagement_Type__c+= ';Company Intelligence Interaction';
                                        }
                                        system.debug('cfollowup.Survey_Start_Date__c+++'+cfollowup.Survey_Start_Date__c);
                                        system.debug('intToUpdate.Survey_Start_Date__c+++'+intToUpdate.Survey_Start_Date__c);                                           
                                        if(cfollowup.Survey_Start_Date__c!=null && cfollowup.Survey_Start_Date__c<intToUpdate.Survey_Start_Date__c){
                                            cfollowup.Workflow_Session__c = 'Company Intelligence Interaction';
                                            cfollowup.Survey_Start_Date__c = intToUpdate.Survey_Start_Date__c;
                                        }
                                    }
                                }
                                system.debug('clientFollowUpUpdateList+++11'+clientFollowUpUpdateList);
                                clientFollowUpUpdateList.add(cfollowup);  
                            }
                        }
                    }
                    else{
                        Client_FollowUp__c cFolloUpNew = new Client_FollowUp__c();
                        system.debug('cFolloUpNew+++11'+cFolloUpNew);
                            
                        if((intToUpdate.RecordTypeId == recTypeNameIDMap.get('Consultation_Person_Account') || intToUpdate.RecordTypeId == recTypeNameIDMap.get('Consultation')) && ((intToUpdate.Follow_Up_Consultation_Type__c =='Follow-Up for Online clients' && intToUpdate.Advisor_Lookup__c  !=null && intToUpdate.Meeting_Date__c!=null && intToUpdate.Location__c!=null && trigger.isUpdate && intToUpdate.Meeting_Status__c=='Completed' && intToUpdate.Meeting_Status__c!=oldInteractionMap.get(intToUpdate.Id).Meeting_Status__c) || (((intToUpdate.Follow_Up_Consultation_Type__c =='Follow-Up for Walk in clients' && intToUpdate.Meeting_Date__c!=null) ||(intToUpdate.Follow_Up_Consultation_Type__c !='Follow-Up for Walk in clients' && intToUpdate.Follow_Up_Consultation_Type__c !='Follow-Up for Online clients' && intToUpdate.Date_of_Contact__c!=null)) && trigger.isInsert))){
                            
                            cFolloUpNew.Interaction__c = intToUpdate.Id;
                            cFolloUpNew.Contact__c = intToUpdate.Contact__c;
                            cFolloUpNew.Account__c = intToUpdate.Account__c;
                            cFolloUpNew.Workflow_Session__c = 'Consultation Interaction';
                            cFolloUpNew.Engagement_Type__c = 'Consultation Interaction';
                            cFolloUpNew.Survey_Start_Date__c = intToUpdate.Survey_Start_Date__c;
                            clientFollowUpInsertList.add(cFolloUpNew);
                        
                        }
                        else if(intToUpdate.RecordTypeId == recTypeNameIDMap.get('Company_Intelligence_Person_Account') || intToUpdate.RecordTypeId == recTypeNameIDMap.get('Company_Intelligence') && trigger.isInsert){
                            if(intToUpdate.Purpose_of_the_Interaction__c!=null){
                                tmpString.addAll(intToUpdate.Purpose_of_the_Interaction__c.split(';'));
                                system.debug('tmpString+++'+tmpString);
                                for(integer i=0;i<tmpString.size();i++){
                                    //if(purposeofInteractionSet.contains(tmpString[i]) && accountMap!=null && accountMap.containsKey(intToUpdate.Account__c) && accountMap.get(intToUpdate.Account__c).Account_Type__c == 'Business Client')
                                    system.debug('purposeofInteractionSet+++11'+purposeofInteractionSet);
                                    if(purposeofInteractionSet.contains(tmpString[i])){
                                    system.debug('purposeofInteractionSet+++22'+purposeofInteractionSet);
                                    allowBusOutcome =true;
                                    }
                                }
                            }
                            if(allowBusOutcome){
                                cFolloUpNew.Contact__c = intToUpdate.Contact__c;
                                cFolloUpNew.Account__c = intToUpdate.Account__c;                                
                                cFolloUpNew.Interaction__c= intToUpdate.Id;
                                cFolloUpNew.Workflow_Session__c = 'Company Intelligence Interaction ';
                                cFolloUpNew.Engagement_Type__c= 'Company Intelligence Interaction';
                                cFolloUpNew.Survey_Start_Date__c = intToUpdate.Survey_Start_Date__c;
                            }
                            clientFollowUpInsertList.add(cFolloUpNew);
                        }
                        system.debug('clientFollowUpInsertList+++11'+clientFollowUpInsertList);
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
                System.debug('Error occurred in upsertClientFollowUpForInteraction: ' + ex.getMessage());
            }
        }
    }
    public static void createEventForConfirmedConsultation(List<Interaction__c> newInteractionList,Map<Id,Interaction__c> oldInteractionMap){
        List<Event> eventList = new List<Event> ();
        system.debug('Inside Event Method');
        
        for(Interaction__c inter : [SELECT Id, Meeting_Status__c, MeetingTime__c, Meeting_Date__c, Location__c, Account__c, Account__r.Name,Advisor_Lookup__c, Contact__c, Contact__r.Name  FROM Interaction__c WHERE ID IN: newInteractionList]) {
            if(inter.Meeting_Status__c == 'Confirmed' && inter.Contact__c!=null && inter.Location__c!=null && inter.Advisor_Lookup__c!=null && inter.Account__c!=null && oldInteractionMap!=null && inter.Meeting_Status__c!=oldInteractionMap.get(inter.Id).Meeting_Status__c) {
                String dt = Datetime.newInstance(inter.Meeting_Date__c.year(), inter.Meeting_Date__c.month(), inter.Meeting_Date__c.day()).format('dd/MM/yyyy');
                List<String> timeParts = inter.MeetingTime__c.split('-');
                system.debug('timeParts+++'+timeParts);
                
                Event ev = new Event();
                ev.ownerId=inter.Advisor_Lookup__c;
                ev.StartDateTime = DateTime.parse(dt + ' ' + timeParts[0].left(6).trim().replace(' ', ':')+' '+timeParts[0].trim().right(2));
                system.debug('eventList111+++'+ev.StartDateTime);
                ev.EndDateTime = DateTime.parse(dt + ' ' + timeParts[1].left(6).trim().replace(' ', ':')+' '+timeParts[1].trim().right(2));
                system.debug('eventList222++'+ev.EndDateTime);
                ev.Location = inter.Location__c;
                ev.ShowAs = 'Busy';
                ev.WhatID = inter.Id;
                ev.WhoId= inter.Contact__c;
                ev.Subject = 'Consultation Follow-up for: ' + inter.Account__r.Name + ' with '+inter.Contact__r.Name;
                eventList.add(ev);    
            }   
        }
        system.debug('eventList+++'+eventList);   
        //Below logic to delete any event assoicated with an Interaction and it has been Cancelled by Client
        Set<String> interIdSet = new Set<String> ();
        List<Event> eventListDelete = new List<Event>();
        if(trigger.isUpdate){
            for(Interaction__c intera: newInteractionList){
                if((intera.Meeting_Status__c == 'Cancelled by Advisor' || intera.Meeting_Status__c == 'Cancelled by Client')&& oldInteractionMap!=null && intera.Meeting_Status__c!=oldInteractionMap.get(intera.Id).Meeting_Status__c){
                    interIdSet.add(intera.Id);
                }
            }
            for(Event ev: [SELECT Id, WhatID, Subject FROM Event WHERE Subject like 'Consultation Follow-up for:%' AND WhatID IN: interIdSet]){
                eventListDelete.add(ev);
            }
        }
        system.debug('eventList+++'+eventList);
        system.debug('eventList+++'+eventList);
        try{
            if(eventList.size() > 0) {
                Database.insert(eventList);
            }
            if(eventListDelete.size() > 0) {
                Database.delete(eventListDelete);
            }
        }   
        catch (Exception  ex){
            System.debug('Error occurred in createEventForConfirmedConsultation: ' + ex.getMessage());
       }
        
    }
    public static void updateInterCountOnAccount(List<Interaction__c> newInteractionList,Map<Id,Interaction__c> oldInteractionMap){
        Set<Id> accountIds = new Set<Id>();
        List<Account> accountsToUpdate = new List<Account>();
        
        if(Trigger.isInsert){
            for(Interaction__c item : newInteractionList){
                accountIds.add(item.Account__c);
            }
        }
        if(Trigger.isUpdate){
            for(Interaction__c item : newInteractionList){
                if(oldInteractionMap!=null && item.Account__c!=oldInteractionMap.get(item.Id).Account__c){
                    accountIds.add(item.Account__c);
                    accountIds.add(oldInteractionMap.get(item.Id).Account__c);
                }
            }   
        }
        if(Trigger.isDelete){
            for (Interaction__c item : oldInteractionMap.values())
                accountIds.add(item.Account__c);
                system.debug('accountIds+++'+accountIds);
        }

        // get a map of the Account with the number of Interaction
        Map<Id,Account> accountMap = new Map<Id,Account>([SELECT Id, Related_Child_Interactions__c FROM Account WHERE Id IN :accountIds]);

        // query the Account and the related Interactions and add the size of the Interaction to the Account's Related Interaction Count
        for (Account acc : [SELECT Id, Name, Related_Child_Interactions__c,(SELECT id from Interactions__r) FROM Account WHERE Id IN :accountIds]){
            accountMap.get(acc.Id).Related_Child_Interactions__c = acc.Interactions__r.size();
            // add the Account in the map to a list so we can update it
            accountsToUpdate.add(accountMap.get(acc.Id));
        }

        update accountsToUpdate;
    
            
    }
}