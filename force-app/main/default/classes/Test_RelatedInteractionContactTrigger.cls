@isTest
private class Test_RelatedInteractionContactTrigger{
        
     static testMethod void createTestData(){
     
     RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        
        //Below code create list of Account records
        List<Account> accList = new List<Account>(); 
        for(Integer i=0;i<6;i++){
            Account acc = new Account();
            acc.Name='City Of Toronto';
            acc.BillingCountry = 'Canada';
            acc.ShippingCountry = 'Canada';
            acc.RecordTypeId = rt.Id;
            accList.add(acc);
        }
        
        insert accList ;
        
       //Below code create list of Contact records
        List<Contact> conList = new List<Contact>();
        for (Integer j=0;j<accList.size();j++) {
            Account acct = accList[j];            
            // For each account just inserted, add contacts
            for (Integer k=0;k<5;k++) {
                conList.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     Email='test@cityoftoronto.com'+k,
                                     AccountId=acct.Id));
            }
        }
        // Insert all contacts for all accounts
        insert conList;
        
        //Below code create list of Interaction records
        Date myDate = Date.newInstance(2015,10,17);
        List<Interaction__c > interList = new List<Interaction__c >();
        for (Integer k=0;k<4;k++) {
            interList.add(new Interaction__c (Contact__c = conList[0].Id,
                                              Account__c = accList[0].Id,
                                              Business_Status__c= 'Existing',
                                              Gender__c= 'Male',
                                              Meeting_Date__c = myDate, 
                                              Advisor__c = 'Vikas Jain',
                                              Meeting_Status__c ='Confirmed', 
                                              Meeting_Time__c ='1000',
                                              Location__c = 'City Hall'));
        }                                 
        insert interList;
        
        List<Related_Interaction_Contact__c > interContList = new List<Related_Interaction_Contact__c >();
        for (Integer k=0;k<4;k++) {
            interContList.add(new Related_Interaction_Contact__c (Contact__c = conList[0].Id,
                                              Interaction__c = interList[0].Id
                                              ));
        }                                 
         try{
            insert interContList;
         }
         catch (DMLException e) {
            
        }
    }
    static testMethod void createTestData2(){
        
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        
        Id RecordTypeIdConsInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Consultation').getRecordTypeId();
        Id RecordTypeIdComIntInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Company Intelligence').getRecordTypeId();
        //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(Name='City Of Toronto',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id));
        accList.add(new Account(FirstName='City Of Toronto ',LastName='Person Account', PersonEmail = 'city11@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        insert accList ;
        
        List<Interaction__c > interList = new List<Interaction__c >();
        interList.add(new Interaction__c(Contact__c = accList[0].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor__c= UserInfo.getUserId() ));
        interList.add(new Interaction__c(Contact__c = accList[1].Id, Account__c = accList[1].Id,RecordTypeId=RecordTypeIdConsInteraction));
        interList.add(new Interaction__c(Contact__c = accList[0].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Biz Development - Expansion Assistance'));
        interList.add(new Interaction__c(Contact__c = accList[1].Id, Account__c = accList[1].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Biz Development - Expansion Assistance'));
        
        Account accnt = new Account();
        accnt.Name='City Of Toronto Sample 12';
        accnt.BillingCountry = 'Canada';
        accnt.ShippingCountry = 'Canada';
        accnt.RecordTypeId = rtBus.Id;
        accnt.Automated_Account_Creation__c = true;
        insert accnt;
        
        Contact consample = new Contact();
        consample.firstname='Test 10';
        consample.lastname='Test 12';
        consample.Email='test@cityoftoronto12.com';
        consample.AccountId=accnt.Id;
        insert consample;
        
        try{
            insert interList;
            List<Related_Interaction_Contact__c > interContList = new List<Related_Interaction_Contact__c >();
            for (Integer k=0;k<4;k++) {
            interContList.add(new Related_Interaction_Contact__c (Contact__c = accList[0].Id, 
                                              Interaction__c = interList[0].Id
                                              ));
            } 
            interContList.add(new Related_Interaction_Contact__c (Contact__c = consample.Id,
                                              Interaction__c = interList[0].Id
                                              ));  
            insert interContList;
        }
        catch (DMLException e) {
            
        }
    }
    static testMethod void createTestData3(){
       
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        
        Id RecordTypeIdConsInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Consultation').getRecordTypeId();
       
       //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(Name='City Of Toronto 1',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        insert accList ;
        
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(firstname='Test'+7,lastname='Test'+7,Email='test@cityoftoronto.com'+7, AccountId=accList[0].Id));   
        conList.add(new Contact(firstname='Test'+7,lastname='Test'+7,Email='test@cityoftoronto.com'+8, AccountId=accList[1].Id));   
        insert conList ;
        
        List<Interaction__c > interList = new List<Interaction__c>();
        interList.add(new Interaction__c(Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction));
        
        try{
            database.Insert(interList);
             Related_Interaction_Contact__c relInt = new Related_Interaction_Contact__c ();
             relInt.Contact__c = conList[1].Id;
             relInt.Interaction__c= interList[0].Id;
             insert relInt;
        }
        catch (DMLException e) {
        }
    }        
}