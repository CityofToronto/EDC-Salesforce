public with sharing class EmailMessageTriggerHandler {
    public static void CreateCaseContact(List<EmailMessage> mailMessages) {

        //This method is used for creating contact if email sender does not exist.

        //EmailMessage is only available for organizations that use Email-to-Case or Enhanced Email, which is automatically enabled for most customers.

        List<Id> caseIds = new List<String>();
        Map<Id,EmailMessage> emailMessageMap = new Map<Id,EmailMessage>();
        Map<String,List<EmailMessage>> emailMessageEmailMap = new Map<String,List<EmailMessage>>();
        
        for (EmailMessage em : mailMessages) {
            if (String.isNotEmpty(em.parentId)) {
                caseIds.add(em.parentId);
                if (!emailMessagemap.containsKey(em.parentId)) {
                    emailMessageMap.put(em.parentId,em);
                }
                
                List<EmailMessage> ems = new List<EmailMessage>();
                if (emailMessageEmailMap.containsKey(em.fromAddress.toUpperCase())) {
                    ems=emailMessageEmailMap.get(em.fromAddress.toUpperCase());
                }
    
                ems.add(em);
                emailMessageEmailMap.put(em.fromAddress.toUpperCase(),ems);
    
            }
        }
        
        system.debug('caseIds:' + caseIds);
        if (caseIds.size() == 0) {
            return;
        }
        
        Map<Id,Case> caseMap = new Map<Id,case>([SELECT Id FROM Case WHERE accountId ='' AND Id IN : caseIds]);
        system.debug('caseMap:' + caseMap);
            
        if (caseMap.size() == 0) {
            return;
        }
    
        List<String> emailList = new List<String>();
        for (Case c : caseMap.values()) {
            emailList.add(emailMessageMap.get(c.Id).fromAddress);
        }
                
                
        List<Contact> contacts = [SELECT Id,AccountId,email FROM Contact WHERE email IN :emailList];
        
        system.debug('contacts:' + contacts);
    
        for (contact c : contacts) {
            for (integer i =0;i<emailList.size();i++) {
                if (emaillist[i] == c.email) {
                    emailList.remove(i);
                    break;
                }
            }
        }
    
        system.debug('emailList:' + emailList);
    
        if (emailList.size() == 0) {
            return;
        }
    
        Account acc = [SELECT Id FROM Account WHERE Name = 'Leads Account' Limit 1];
    
        List<Contact> newContacts = new List<Contact>();
        for (string s : emailList){
            for (emailMessage em : emailMessageEmailMap.get(s.toUpperCase())) {
                Contact c = new Contact();
                c.email = em.fromAddress;
                string fromName = em.fromName;
    
                if (String.isNotEmpty(fromName)) {
                    if (fromName.contains(',')) {
                        List<String> names = fromName.split(',');
                        c.LastName = names[0];
                        if (names.size() > 1) {
                            c.firstName = names[1];
                        }
                    } else if (fromName.contains(' ')){
                        List<String> names = fromName.split(' ');
                        c.LastName = names[names.size()-1];
                        if (names.size() > 1) {
                            c.firstName = names[0];
                        }
    
                    } else{
                        c.lastName = fromName;
                    }
                    
                } else {
                    c.lastName ='No Name';
                }
    
                c.accountId = acc.Id;
                newContacts.add(c);
            }
        }
    
        system.debug('newContacts:' + newContacts);
    
        insert newContacts;
    
        system.debug('newContacts:' + newContacts);
    
        
        Map<string,Contact> contactEmailmap = new Map<String,Contact>();
        
        for (contact c : [SELECT Id,email,accountId FROM Contact WHERE email IN :emailList]) {
            contactEmailmap.put(c.email.toUpperCase(),c);
        }
    
        
        List<Case> cases = new List<Case>();
    
        for (String s : emailMessageEmailMap.keySet()) {
            if (contactEmailmap.containsKey(s)) {
                for (EmailMessage em : emailMessageEmailMap.get(s)) {
                    Case c = new Case();
                    c.Id = em.parentId;
                    c.contactId = contactEmailmap.get(s).Id;
                    c.accountId = contactEmailmap.get(s).accountId;
                    cases.add(c);
    
                    system.debug('c:' + c);
    
                }
            }
        }
    
        update cases;
    }
}