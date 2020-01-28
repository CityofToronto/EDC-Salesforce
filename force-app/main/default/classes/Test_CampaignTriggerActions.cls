@isTest
private class Test_CampaignTriggerActions{
        
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
            acc.Automated_Account_Creation__c = true;
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
        RecordType rtEvent = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Events'];
        RecordType rtGroup = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Group_Management'];
        RecordType rtInvst = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Investment_Activity'];
        RecordType rtPrjct = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Projects'];
        
        //Insert Campaign List
        List<Campaign> campList = new List<Campaign>();
        campList.add(new Campaign(Name='Event Campaign 1',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='Business Start Up',StartDate = system.today(),EndDate = system.today()+10,Status = 'Completed'));
        campList.add(new Campaign(Name='Event Campaign 1',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='Business Expansion',StartDate = system.today(),EndDate = system.today()+8));
        campList.add(new Campaign(Name='Event Campaign 2 ',RecordTypeId= rtEvent.Id,Event_Type__c='Event Support'));
        campList.add(new Campaign(Name='Event Campaign 3',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='International Events'));
        campList.add(new Campaign(Name='Event Campaign 4',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='Online Training',Status = 'Completed'));
        campList.add(new Campaign(Name='Group Campaign',RecordTypeId= rtGroup.Id,Group_Management_Type__c='Advisory Group (Formal)'));
        campList.add(new Campaign(Name='Invstement Campaign',RecordTypeId= rtInvst.Id,Account__c=accList[0].Id,StartDate = system.today()+2));
        campList.add(new Campaign(Name='Project Campaign',RecordTypeId= rtPrjct.Id,Project_Type__c='International Project',International_Project_Type__c='Outbound Mission',StartDate = system.today()+2,EndDate = system.today()+10,Status = 'Completed'));
        insert campList;
        
         //Business Outcome Survey Sample Records
        List<Client_FollowUp__c> busOutList = new List<Client_FollowUp__c >();
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[1].Id,Survey_Start_Date__c = system.today()+12,Engagement_Type__c='Business Start Up Event'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[3].Id,Survey_Start_Date__c = system.today()+12));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[2].Id,Survey_Start_Date__c = system.today()+12));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[0].Id,Survey_Start_Date__c = system.today(),Engagement_Type__c='Online Training'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[3].Id,Survey_Start_Date__c = system.today()+5,Engagement_Type__c='Business Expansion Event;Online Training'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[4].Id,Survey_Start_Date__c =system.today()));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[5].Id,Survey_Start_Date__c = null,Engagement_Type__c=''));
        insert busOutList;
        
        //Insert Campaign Member List
        List<CampaignMember> campMemList = new List<CampaignMember>();
        campMemList.add(new CampaignMember(CampaignId = campList[0].Id,ContactId = conList[0].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[1].Id,ContactId = conList[1].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[1].Id,ContactId = conList[2].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[0].Id,ContactId = conList[4].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[1].Id,ContactId = conList[4].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[2].Id,ContactId = conList[2].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[3].Id,ContactId = conList[3].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[4].Id,ContactId = conList[4].Id,Member_Role__c = 'Internal - Team Member',Survey_Start_Date__c=system.today()));
        campMemList.add(new CampaignMember(CampaignId = campList[4].Id,ContactId = conList[5].Id,Member_Role__c = 'Internal - Team Member',Survey_Start_Date__c=system.today()+7));
        campMemList.add(new CampaignMember(CampaignId = campList[5].Id,ContactId = conList[5].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[6].Id,ContactId = conList[1].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[7].Id,ContactId = conList[1].Id));
        
        //insert campMemList;
        try{
            Database.insert(campMemList);
        }
        catch (DMLException e) {
            
        }
        
        campList[1].Event_Type__c = 'Networking Events';
        campList[1].StartDate = system.today();
        campList[1].EndDate = system.today()+10;
        campList[1].Status = 'Completed';
        update campList;
        
    }
    static testMethod void createTestData2(){
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
       
        //Below code create list of Account records
        List<Account> accList = new List<Account>(); 
        for(Integer i=0;i<6;i++){
            Account acc = new Account();
            acc.Name='City Of Toronto';
            acc.BillingCountry = 'Canada';
            acc.ShippingCountry = 'Canada';
            acc.RecordTypeId = rt.Id;
            acc.Automated_Account_Creation__c = true;
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
        RecordType rtEvent = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Events'];
        RecordType rtGroup = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Group_Management'];
        RecordType rtInvst = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Investment_Activity'];
        RecordType rtPrjct = [select id,Name from RecordType where SobjectType='Campaign' and DeveloperName='Projects'];
        
        //Insert Campaign List
        List<Campaign> campList = new List<Campaign>();
        campList.add(new Campaign(Name='Event Campaign 1',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='Business Start Up',StartDate = system.today(),EndDate = system.today()+10,Status = 'Completed'));
        campList.add(new Campaign(Name='Event Campaign 1',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='Business Expansion',StartDate = system.today(),EndDate = system.today()+8));
        campList.add(new Campaign(Name='Event Campaign 2 ',RecordTypeId= rtEvent.Id,Event_Type__c='Event Support'));
        campList.add(new Campaign(Name='Event Campaign 3',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='International Events'));
        campList.add(new Campaign(Name='Event Campaign 4',RecordTypeId= rtEvent.Id,Event_Type__c='Business Training',Program_Sub_Type__c='Online Training',Status = 'Completed'));
        campList.add(new Campaign(Name='Group Campaign',RecordTypeId= rtGroup.Id,Group_Management_Type__c='Advisory Group (Formal)'));
        campList.add(new Campaign(Name='Invstement Campaign',RecordTypeId= rtInvst.Id,Account__c=accList[0].Id,StartDate = system.today()+2));
        campList.add(new Campaign(Name='Project Campaign',RecordTypeId= rtPrjct.Id,Project_Type__c='International Project',International_Project_Type__c='Outbound Mission',StartDate = system.today()+2,EndDate = system.today()+10,Status = 'Completed'));
        insert campList;
        
        
        //Insert Campaign Member List
        List<CampaignMember> campMemList = new List<CampaignMember>();
        campMemList.add(new CampaignMember(CampaignId = campList[0].Id,ContactId = conList[0].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[1].Id,ContactId = conList[1].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[2].Id,ContactId = conList[2].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[3].Id,ContactId = conList[3].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[4].Id,ContactId = conList[4].Id,Member_Role__c = 'Internal - Team Member'));
        campMemList.add(new CampaignMember(CampaignId = campList[5].Id,ContactId = conList[5].Id));
        campMemList.add(new CampaignMember(CampaignId = campList[6].Id,ContactId = conList[1].Id));
        
        //insert campMemList;
        
        try{
            Database.insert(campMemList);
        }
        catch (DMLException e) {
            
        }
        campList[1].Event_Type__c = 'Networking Events';
        campList[1].StartDate = system.today();
        campList[1].EndDate = system.today()+10;
        campList[1].Status = 'Completed';
        update campList;
        
    }
}