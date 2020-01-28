@isTest
private class Test_InteractionTriggerAction{
        
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
                                              Advisor_Lookup__c= UserInfo.getUserId(),
                                              Meeting_Status__c ='Requested', 
                                              Meetingtime__c ='09 00 AM - 10 00 AM',
                                              Location__c = 'City Hall'));
        }                                 
        insert interList;
        interList[0].Meeting_Status__c='Confirmed';
        interList[1].Meeting_Status__c='Confirmed';
        update interList;
        interList[1].Meeting_Status__c='Cancelled by Client';
        update interList[1];
    
    }
    
    static testMethod void createTestData2(){
        
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        
        Id RecordTypeIdConsInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Consultation').getRecordTypeId();
        Id RecordTypeIdComIntInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Company Intelligence').getRecordTypeId();
        //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(Name='City Of Toronto',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        accList.add(new Account(FirstName='City Of Toronto ',LastName='Person Account', PersonEmail = 'city11@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        accList.add(new Account(FirstName='City Of Oakville ',LastName='Person Account', PersonEmail = 'city12@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        insert accList ;
        
        //Below code create list of Contact records
        List<Contact> conList = new List<Contact>();
           Account acct = accList[0];            
            // For each account just inserted, add contacts
            for (Integer k=0;k<6;k++) {
                conList.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     Email='test@cityoftoronto.com'+k,
                                     AccountId=acct.Id));
            }
        // Insert all contacts for all accounts
        insert conList;
        
        //Business Outcome Survey Sample Records
        List<Client_FollowUp__c> busOutList = new List<Client_FollowUp__c >();
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[0].Id,Survey_Start_Date__c = system.today()-12,Engagement_Type__c='Consultation Interaction'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[1].Id,Survey_Start_Date__c = system.today()-12,Engagement_Type__c='Online Registration'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[2].Id,Survey_Start_Date__c = system.today()+12,Engagement_Type__c=''));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[3].Id,Survey_Start_Date__c = system.today()-12,Engagement_Type__c='Company Intelligence Interaction'));
        
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[4].Id,Survey_Start_Date__c = system.today()+12,Engagement_Type__c=null));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[5].Id,Survey_Start_Date__c = system.today()-12,Engagement_Type__c='Online Registration'));
        insert busOutList;
        List<Interaction__c > interList = new List<Interaction__c >();

        interList.add(new Interaction__c(Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor__c= 'Funmi',Meeting_Date__c=date.today()));
        
        interList.add(new Interaction__c(Contact__c = conList[1].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor__c= 'Funmi',Meeting_Date__c=date.today()));
        
        interList.add(new Interaction__c(Contact__c = conList[2].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor__c= 'Funmi',Meeting_Date__c=date.today()));
        
        Contact consCon =[Select Id, AccountId from Contact Where AccountId =:accList[1].Id];
        interList.add(new Interaction__c(Contact__c = consCon.Id, Account__c = accList[1].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor_Lookup__c= UserInfo.getUserId()));
        
        Contact con =[Select Id, AccountId from Contact Where AccountId =:accList[2].Id];
        interList.add(new Interaction__c(Contact__c = con.Id, Account__c = accList[2].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Market Development**'));
        
        
        interList.add(new Interaction__c(Contact__c = accList[0].PersonContactId__c, Account__c = accList[2].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor_Lookup__c= UserInfo.getUserId()));
        
        interList.add(new Interaction__c(Contact__c = conList[3].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Market Development**'));
        interList.add(new Interaction__c(Contact__c = conList[4].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Market Development**'));
        interList.add(new Interaction__c(Contact__c = conList[5].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Market Development**'));
        
       
        try{
            insert interList;
            interList[0].Meeting_Status__c='Confirmed';
            interList[1].Meeting_Status__c='Confirmed';
            update interList;
        
        }
        catch (DMLException e) {
            
        }
    }
    static testMethod void createTestData3(){
        
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        
        Id RecordTypeIdConsInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Consultation').getRecordTypeId();
        Id RecordTypeIdComIntInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Company Intelligence').getRecordTypeId();
        //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(Name='City Of Toronto 1',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        accList.add(new Account(FirstName='City Of Toronto 3',LastName='Person Account', PersonEmail = 'city11@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        accList.add(new Account(FirstName='City Of Toronto 4',LastName='Person Account', PersonEmail = 'city11@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        insert accList ;
        
        //Below code create list of Contact records
        List<Contact> conList = new List<Contact>();
           Account acct = accList[0];            
            // For each account just inserted, add contacts
            for (Integer k=0;k<6;k++) {
                conList.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     Email='test@cityoftoronto.com'+k,
                                     AccountId=acct.Id));
            }
        conList.add(new Contact(firstname='Test'+7,lastname='Test'+7,Email='test@cityoftoronto.com'+7, AccountId=accList[1].Id));   
        // Insert all contacts for all accounts
        insert conList;
        List<Interaction__c > interList = new List<Interaction__c>();
        interList.add(new Interaction__c(Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction,Follow_Up_Consultation_Type__c ='Follow-Up for Online clients',Location__c='City Hall', Meeting_Status__c = 'Requested',Date_of_Contact__c = date.today(),Advisor__c= 'Funmi',Meeting_Date__c=date.today()));
        interList.add(new Interaction__c(Contact__c = conList[1].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Expansion Assistance**'));
        interList.add(new Interaction__c(Contact__c = conList[2].Id, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Expansion Assistance**'));
//      interList.add(new Interaction__c(Contact__c = accList[2].PersonContactId__c, Account__c = accList[3].Id,RecordTypeId=RecordTypeIdComIntInteraction,Purpose_of_the_Interaction__c = 'Business Development - Expansion Assistance**'));
            
        try{
            insert interList;
            interList[0].Meeting_Status__c='Confirmed';
            update interList;
            interList[1].Account__c = accList[1].Id;
            update interList;
        }
        catch (DMLException e) {
        }
    } 
    static testMethod void createTestData4(){
       
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        Id RecordTypeIdConsInteraction = Schema.SObjectType.Interaction__c.getRecordTypeInfosByName().get('Consultation').getRecordTypeId();
       
       //Below code create list of  Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(FirstName='City Of Toronto 3',LastName='Person Account', PersonEmail = 'city11@toronto.com',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        accList.add(new Account(FirstName='City Of Toronto 4',LastName='Person Account', PersonEmail = 'city11@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
        insert accList ;
        
   
        Date myDate = Date.newInstance(2015,10,17);
        List<Interaction__c > interList = new List<Interaction__c>();
        interList.add(new Interaction__c(Contact__c = accList[0].PersonContactId__c, Account__c = accList[0].Id,RecordTypeId=RecordTypeIdConsInteraction));
        
        try{
            database.Insert(interList);
        }
        catch (DMLException e) {
        }
    }   
}