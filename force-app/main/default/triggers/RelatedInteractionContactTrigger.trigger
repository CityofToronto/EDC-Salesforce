trigger RelatedInteractionContactTrigger  on Related_Interaction_Contact__c (before insert, before update) {
    if(System.Label.RunInteractionTrigger == 'true'){
        Set<Id> contactIdSet = new Set<Id>();
        Set<Id> accIdSet = new Set<Id>();
        for(Related_Interaction_Contact__c intr: trigger.new){
            contactIdSet.add(intr.Contact__c); 
            accIdSet.add(intr.AccountId__c);
        }
        system.debug('contactIdSet++'+contactIdSet);
        system.debug('accIdSet++'+accIdSet);
        Map<Id, Set<String>> accountToRelatedContacts = new Map<Id, Set<String>>();
        if(contactIdSet!=null || accIdSet!=null){
            for(AccountContactRelation accCon: [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE AccountId IN: accIdSet OR ContactId IN: contactIdSet]){
                if(!accountToRelatedContacts.containsKey(accCon.AccountId)){
                accountToRelatedContacts.put(accCon.AccountId, new Set<String>{accCon.ContactId});
                }else{
                 accountToRelatedContacts.get(accCon.AccountId).add(accCon.ContactId);
                }
            }
        }
        system.debug('accountToRelatedContacts++'+accountToRelatedContacts);
        for(Related_Interaction_Contact__c intrCheck: trigger.new){
            system.debug('accountToRelatedContacts.get(intrCheck.AccountId__c)++'+accountToRelatedContacts.get(intrCheck.AccountId__c));
        
            if(intrCheck.AccountId__c!=null && intrCheck.Contact__c!=null && 
            accountToRelatedContacts.containsKey(intrCheck.AccountId__c) && !accountToRelatedContacts.get(intrCheck.AccountId__c).contains(intrCheck.Contact__c))
            intrCheck.adderror('Account and Contact are not related to each other');
        }
    }    
}