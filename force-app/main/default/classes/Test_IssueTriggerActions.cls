@isTest
public class Test_IssueTriggerActions{
    
    static testMethod void createTestData(){
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        
        //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(Name='City Of Toronto 1',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client'));
        accList.add(new Account(FirstName='City Of Brampton ',LastName='Person Account', PersonEmail = 'city11@toronto.ca',PersonMailingCountry = 'Canada', PersonOtherCountry = 'Canada',RecordTypeId = rtPerson.Id));
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
        
        List<Issue__c> issueList = new List<Issue__c>();

        issueList.add(new Issue__c(Contact__c = conList[0].Id, Account__c = accList[0].Id,Date_Raised__c=date.today(),Priority__c='Low'));
        issueList.add(new Issue__c(Contact__c = conList[1].Id, Account__c = accList[1].Id,Date_Raised__c=date.today(),Priority__c='Low'));
        issueList.add(new Issue__c(Contact__c = conList[2].Id, Account__c = accList[2].Id));
        issueList.add(new Issue__c(Contact__c = conList[2].Id, Account__c = accList[3].Id));
        
        
        try{
            insert issueList;
        }
        catch (DMLException e) {
            
        }
    }    
}