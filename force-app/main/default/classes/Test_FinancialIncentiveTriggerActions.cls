@isTest
public class Test_FinancialIncentiveTriggerActions{
    
    static testMethod void createTestData1(){
            
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        RecordType rtPerson = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='PersonAccount'];
        
        List<RecordType> finRTList = [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c'];
        
        
        Map<String,String> finRTMap = new Map<String,String>();
        for(RecordType rt: [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c']){
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
        conList.add(new Contact(firstname='Test7', lastname='Test7', Email='test@cityoftoronto.com7',AccountId=accList[0].Id));
        // Insert all contacts for all accounts
        insert conList;
        
        List<Financial_Incentive__c> finIncList = new List<Financial_Incentive__c >();

        //BIA CFI Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=finRTMap.get('BIA_Commercial_Industrial_Facade_and_Property_Improvement'),Status__c='Draft',Personal_Information_Declaration__c=true,Permission_to_Bind_Corporation__c=true,Permission_to_Photograph_Video_Building__c=true));
        //BIA Innovation Fund Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[1].Id, Account__c = accList[1].Id,RecordTypeId=finRTMap.get('BIA_Innovation_Fund'),Status__c='Draft',Personal_Information_Declaration__c=true,Acknowledgement_Signature_of_Chair__c=true));
        //BIA Leadersip Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[2].Id, Account__c = accList[2].Id,RecordTypeId=finRTMap.get('BIA_Leadership_Fund'),Status__c='Draft',Personal_Information_Declaration__c=true,Permission_to_Photograph_Individual__c=true));
        //BIA Outside Mural Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[3].Id, Account__c = accList[3].Id,RecordTypeId=finRTMap.get('BIA_Outside_Mural_and_Street_Art_Grant'),Status__c='Draft',Personal_Information_Declaration__c=true,Permission_to_Photograph_Video_Building__c=true,Acknowledgement_Signature_of_Chair__c=true));
        //BIA Streetscape Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=finRTMap.get('BIA_Streetscape_Master_Plan_Funding'),Status__c='Draft',Personal_Information_Declaration__c=true,Acknowledgement_Signature_of_Chair__c=true));
        //Business Incubation Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[1].Id, Account__c = accList[1].Id,RecordTypeId=finRTMap.get('Business_Incubation_Grant'),Status__c='Draft'));
        //Event Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[2].Id, Account__c = accList[2].Id,RecordTypeId=finRTMap.get('Event_Sponsorship_Grant'),Status__c='Draft'));
        //Event Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[2].Id, Account__c = accList[2].Id,RecordTypeId=finRTMap.get('Event_Sponsorship_Grant'),Status__c='Submitted'));
        //Sector Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[3].Id, Account__c = accList[3].Id,RecordTypeId=finRTMap.get('Sector_Grant'),Status__c='Draft'));
        //
        //Starter Company Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[3].Id, Account__c = accList[3].Id,RecordTypeId=finRTMap.get('Starter_Company_Grant'),Status__c='Draft'));
        //IMIT Record   
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[1].Id, Account__c = accList[1].Id,Property_Street__c='100 Queen Street',RecordTypeId=finRTMap.get('IMIT'),Status__c='Draft',Has_Application_been_Submitted__c='Yes'));
        //IMIT Record   
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[2].Id, Account__c = accList[2].Id,RecordTypeId=finRTMap.get('IMIT'),Status__c='Submitted',Has_Application_been_Submitted__c='Yes'));
        
        insert finIncList;
        
        
        finIncList[0].Status__c='Application Declined';
        finIncList[1].Status__c='Extension Approved';
        finIncList[3].Status__c='Approved';
        finIncList[4].Status__c='Pending Approval';
        finIncList[5].Status__c='Completed';
        finIncList[7].Status__c='In Review';
        finIncList[9].Status__c='Compliance/Payment Review';
        finIncList[10].Status__c='Approved by GM';
        try{
            update finIncList;
            finIncList[8].Contact__c = conList[4].Id;
            update finIncList;
            
        }
        catch (DMLException ex) {
        System.debug('****** Exception Caught :   '+ex.getMessage());            
        }
    }
}