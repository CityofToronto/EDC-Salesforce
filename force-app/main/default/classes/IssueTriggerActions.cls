public class IssueTriggerActions 
{
    public static void updateAssignedToOnIssue( List<Issue__c> newIssueList){
        List<Issue__c> issueListToUpdate = [SELECT Id, Assigned_To__c, CreatedById FROM Issue__c Where Id IN: newIssueList];
        for(Issue__c iss: issueListToUpdate ){
            if(iss.Assigned_To__c==null){
                iss.Assigned_To__c = iss.createdbyId;
            }
        }
        if(newIssueList.size()>0){
            update issueListToUpdate ;
        }     
    }
    public static void validateAccountRelationOnIssue( List<Issue__c> newIssueList){
        Map<Id, Set<String>> accountToRelatedContacts = new Map<Id, Set<String>>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> contIdSet = new Set<Id>();
        Set<Id> personAccountIdSet = new Set<Id>();
        Set<Id> busAccountIdSet = new Set<Id>();
        Set<Id> personContIdSet = new Set<Id>();
        Set<Id> busContIdSet = new Set<Id>();
         
        for(Issue__c issueRec: newIssueList){
            accIdSet.add(issueRec.Account__c);
            contIdSet.add(issueRec.Contact__c);
        }
        if(accIdSet!=null){
            for(Account acc: [SELECT ID,Name,IsPersonAccount From Account WHERE ID IN:accIdSet]){
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
            for(Issue__c issueRecVal: newIssueList){
                system.debug('++issueRecVal++'+issueRecVal);
                if(issueRecVal.Account__c!=null && issueRecVal.Contact__c!=null && busAccountIdSet.contains(issueRecVal.Account__c) && busContIdSet.contains(issueRecVal.Contact__c) && (!accountToRelatedContacts.containsKey(issueRecVal.Account__c) || (accountToRelatedContacts.containsKey(issueRecVal.Account__c) && !accountToRelatedContacts.get(issueRecVal.Account__c).contains(issueRecVal.Contact__c)))){
                    issueRecVal.adderror('Issue Account and Issue Contact are not related to each other');
                }
                else if(issueRecVal.Account__c!=null && issueRecVal.Contact__c!=null && ((personAccountIdSet.contains(issueRecVal.Account__c) && !personContIdSet.contains(issueRecVal.Contact__c)) || (!personAccountIdSet.contains(issueRecVal.Account__c) && personContIdSet.contains(issueRecVal.Contact__c)))){
                    issueRecVal.adderror('Same Person Account need to be specified for both Issue Account and Issue Contact ');
                }   
            }
        }
    }   
}