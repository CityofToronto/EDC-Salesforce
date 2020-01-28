public class AgreementTriggerActions{
    public static void updateAgreementOwnerOnAgreement( List<International_Agreement__c> newAgreementList){
        
        Map<String,String> userIdMap =new Map<String,String>();
        List<User> userList = new List<User>([SELECT Id, Username, Name FROM User]);
        for(User us : [SELECT Id, Username, Name FROM User]){
            userIdMap.put(us.Name,us.Id);
        }
        
        Map<String,String> userContinentMap = new Map<String,String>();
        userContinentMap.put('Europe','Vanna Petropoulos');
        userContinentMap.put('North America','Connie Fusillo');
        userContinentMap.put('South America','Linda Fava');
        userContinentMap.put('Asia','Susana Vaz');
        
        Map<String,String> accContinentIdMap = new Map<String,String>();
        Set<String> accIdSet = new Set<String>();
        for(International_Agreement__c intAgg: newAgreementList){
                if(intAgg.Account_Name__c!=null)
                accIdSet.add(intAgg.Account_Name__c);
        }
        if(accIdSet.size()>0){
            for(Account acc: [SELECT Id,Physical_Continent__c FROM Account WHERE ID IN:accIdSet AND Physical_Continent__c!=null]){
                accContinentIdMap.put(acc.Id,acc.Physical_Continent__c);
            }
        }   
        for(International_Agreement__c aggr: newAgreementList ){
            if(aggr.Agreement_Owner__c==null && accContinentIdMap!=null && accContinentIdMap.containsKey(aggr.Account_Name__c)){
               aggr.Agreement_Owner__c = userIdMap.get(userContinentMap.get(accContinentIdMap.get(aggr.Account_Name__c)));
            
            }
        }
    }
    public static void validateAccountRelationOnAgreement( List<International_Agreement__c> newAgreementList){
        Map<Id, Set<String>> accountToRelatedContacts = new Map<Id, Set<String>>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> contIdSet = new Set<Id>();
        Set<Id> busAccountIdSet = new Set<Id>();
        Set<Id> busContIdSet = new Set<Id>();
         
        for(International_Agreement__c AgreementRec: newAgreementList){
            accIdSet.add(AgreementRec.Account_Name__c);
            contIdSet.add(AgreementRec.Contact_Name__c);
        }
        if(accIdSet!=null){
            for(Account acc: [SELECT ID,Name,IsPersonAccount From Account WHERE ID IN:accIdSet]){
                if(!acc.IsPersonAccount)
                busAccountIdSet.add(acc.Id);
            }
        }   
        if(contIdSet!=null){
        for(Contact con: [SELECT ID,LastName,IsPersonAccount From Contact WHERE ID IN:contIdSet]){
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
            for(International_Agreement__c AgreementRecVal: newAgreementList){
                system.debug('++AgreementRecVal++'+AgreementRecVal);
                if(AgreementRecVal.Account_Name__c!=null && AgreementRecVal.Contact_Name__c!=null && busAccountIdSet.contains(AgreementRecVal.Account_Name__c) && busContIdSet.contains(AgreementRecVal.Contact_Name__c) && (!accountToRelatedContacts.containsKey(AgreementRecVal.Account_Name__c) || (accountToRelatedContacts.containsKey(AgreementRecVal.Account_Name__c) && !accountToRelatedContacts.get(AgreementRecVal.Account_Name__c).contains(AgreementRecVal.Contact_Name__c)))){
                    AgreementRecVal.adderror('Agreement Account and Agreement Contact are not related to each other');
                }
            }
        }
    }   
}