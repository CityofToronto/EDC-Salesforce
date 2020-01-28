@isTest
public class Test_AgreementTriggerActions{
    
    static testMethod void createTestData(){
            
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        
        
        //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        
        accList.add(new Account(Name='City Of Toronto 1',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client',Physical_Continent__c ='North America'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'India', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client',Physical_Continent__c ='Asia'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'Mexico', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client',Physical_Continent__c ='South America'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'France', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client',Physical_Continent__c ='Europe'));
        accList.add(new Account(Name='City Of Toronto 2',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client',Physical_Continent__c ='North America'));
        
        insert accList;
        //Below code create list of Contact records
        List<Contact> conList = new List<Contact>();
            // For each account just inserted, add contacts
            for (Integer k=0;k<4;k++) {
                conList.add(new Contact(firstname='Test'+k,
                                     lastname='Test'+k,
                                     Email='test@cityoftoronto.com'+k,
                                     AccountId=accList[k].Id));
            }
        conList.add(new Contact(firstname='Test7', lastname='Test7', Email='test@cityoftoronto.com7',AccountId=accList[0].Id));
        // Insert all contacts for all accounts
        insert conList;
        
        Profile pfl = [select id from profile where name='Standard User'];     
        List<User> lstUser = new List<User>();
        lstUser.add(new User(alias = 'db', email='Vanna@toronto.test.ca', emailencodingkey= 'UTF-8', FirstName='Vanna', lastname='Petropoulos',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='Vanna@toronto.test.ca'));
        lstUser.add(new User(alias = 'dbm', email='Connie@toronto.test.ca',emailencodingkey='UTF-8', FirstName='Connie', lastname='Fusillo' , languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='Connie@toronto.test.ca'));
        lstUser.add(new User(alias = 'dbm', email='Linda@toronto.test.ca',emailencodingkey='UTF-8', FirstName='Linda', lastname='Fava' , languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u3',timezonesidkey='America/Los_Angeles',username='Linda@toronto.test.ca'));
        lstUser.add(new User(alias = 'dbm', email='Susana@toronto.test.ca',emailencodingkey='UTF-8', FirstName='Susana', lastname='Vaz' , languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u4',timezonesidkey='America/Los_Angeles',username='Susana@toronto.test.ca'));
        insert lstUser;
    
        List<International_Agreement__c > agreementList = new List<International_Agreement__c >();
      
        agreementList.add(new International_Agreement__c (Contact_Name__c = conList[0].Id, Account_Name__c = accList[0].Id,Agreement_Country__c='India',Agreement_Type__c='Partnership',Status__c='Pre Agreement'));
        agreementList.add(new International_Agreement__c (Contact_Name__c = conList[1].Id, Account_Name__c = accList[1].Id,Agreement_Country__c='Germany',Agreement_Type__c='Partnership',Status__c='Pre Agreement'));
        agreementList.add(new International_Agreement__c (Contact_Name__c = conList[2].Id, Account_Name__c = accList[2].Id,Agreement_Country__c='Canada',Agreement_Type__c='Partnership',Status__c='Pre Agreement'));
        agreementList.add(new International_Agreement__c (Contact_Name__c = conList[3].Id, Account_Name__c = accList[3].Id,Agreement_Country__c='Mexico',Agreement_Type__c='Partnership',Status__c='Pre Agreement'));
            
        try{
            insert agreementList;
            agreementList[0].Agreement_Country__c='Mexico';
            agreementList[0].Account_Name__c = accList[3].Id;
            update agreementList;
        }
        catch (DMLException e) {
            
        }
    }    
}