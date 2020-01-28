@isTest
public class Test_OnlineRegTriggerActions {
    
    static testMethod void testCreateData() {
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
        
        //Below code create list of Online Registration records
        List<Online_Registration__c> onRegList = new List<Online_Registration__c>();
        for (Integer j=0;j<accList.size();j++) {
            Account acct = accList[j];
            Contact con = conList[j];            
            // For each account just inserted, add contacts
            for (Integer k=0;k<5;k++) {
                onRegList.add(new Online_Registration__c(Account__c=acct.Id,Contact__c=con.Id));
            }
        }
        // Insert all Online Registration for all Contact
        insert onRegList;
        onRegList[0].Type_of_Registration_BNR__c = 'General Partnership';
        update onRegList;
    }
    
    static testMethod void testCreateData2() {
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
        
        //Business Outcome Survey Sample Records
        List<Client_FollowUp__c> busOutList = new List<Client_FollowUp__c >();
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[0].Id,Survey_Start_Date__c = system.today()+12,Engagement_Type__c='Online Registration'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[4].Id,Survey_Start_Date__c = system.today()+12,Engagement_Type__c='Business Expansion Event'));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[1].Id,Survey_Start_Date__c = system.today()+12,Engagement_Type__c=null));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[2].Id,Survey_Start_Date__c = system.today()-1));
        busOutList.add(new Client_FollowUp__c(Contact__c=conList[3].Id,Survey_Start_Date__c = null));
        insert busOutList;
        
        //Below code create list of Online Registration records
        List<Online_Registration__c> onRegList = new List<Online_Registration__c>();
        for (Integer j=0;j<accList.size();j++) {
            Account acct = accList[j];
            Contact con = conList[j];            
            // For each account just inserted, add contacts
            for (Integer k=0;k<5;k++) {
                onRegList.add(new Online_Registration__c(Account__c=acct.Id,Contact__c=con.Id));
            }
        }
        // Insert all Online Registration for all Contact
        insert onRegList;
    }
}