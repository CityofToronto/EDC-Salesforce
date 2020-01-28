@isTest
public class Test_IMITPaymentTriggerActions{
    
    static testMethod void createTestData(){
            
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        
        List<RecordType> finRTList = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c'];
        
        
        Map<String,String> finRTMap = new Map<String,String>();
        for(RecordType rt: [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c' AND DeveloperName = 'IMIT']){
            finRTMap.put(rt.DeveloperName,rt.Id); 
        }
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
        // Insert all contacts for all accounts
        insert conList;
        
        List<Financial_Incentive__c> finIncList = new List<Financial_Incentive__c >();

        //IMIT Record   
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[1].Id, Account__c = accList[1].Id,Property_Street__c='100 Queen Street',RecordTypeId=finRTMap.get('IMIT'),Status__c='Draft',Has_Application_been_Submitted__c='Yes'));
        insert finIncList;
        
        List<IMIT_Payment__c> imitPaymentList = new List<IMIT_Payment__c>();
        imitPaymentList.add(new IMIT_Payment__c(Financial_Incentive__c= finIncList[0].Id, Payment_Status__c= 'Compliance Preparation'));
        imitPaymentList.add(new IMIT_Payment__c(Financial_Incentive__c= finIncList[0].Id, Payment_Status__c= 'Compliance Preparation'));
        
        insert imitPaymentList;
        imitPaymentList[0].Payment_Status__c = 'Terminated';
        imitPaymentList[1].Payment_Status__c = 'Invalid Status';
        try{
            Database.update(imitPaymentList);
        }
        catch (DMLException e) {
            
        }
                    
    }    
}