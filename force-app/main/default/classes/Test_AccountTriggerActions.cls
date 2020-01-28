@isTest
public class Test_AccountTriggerActions{
    
    static testMethod void createTestData(){
        List<Account> accList = new List<Account>(); 
        for(Integer i=0;i<5;i++){
            Account acc = new Account();
            acc.Name='City Of Toronto +i';
            acc.BillingCountry = 'Canada';
            acc.ShippingCountry = 'Canada';
            acc.Board_Size__c=10;
            acc.Standing_Members__c =5;
            acc.RecordTypeId='012o0000000Gb8K';
            accList.add(acc);
        }
        
        Account acc1 = new Account();
        acc1.Name='City Of Toronto 10';
        acc1.BillingCountry = 'Canada';
        acc1.ShippingCountry = 'Canada';
        acc1.Board_Size__c=10;
        acc1.Vacancies__c=5;
        acc1.RecordTypeId='012o0000000Gb8K';
        accList.add(acc1);
        
        Account acc2 = new Account();
        acc2.Name='City Of Toronto 11';
        acc2.BillingCountry = 'Canada';
        acc2.ShippingCountry = 'Canada';
        acc2.Standing_Members__c=10;
        acc2.Vacancies__c=5;
        acc2.RecordTypeId='012o0000000Gb8K';
        accList.add(acc2);
        
        Account acc3 = new Account();
        acc3.Name='City Of Toronto 12';
        acc3.BillingCountry = 'Canada';
        acc3.ShippingCountry = 'Canada';
        acc3.Standing_Members__c=4;
        acc3.RecordTypeId='012o0000000Gb8K';
        accList.add(acc3);
        
        insert accList ;
        
        Contact firstCon = new Contact (LastName='Ray', AccountID = accList[0].Id , Email='test@cityoftoronto.com');
        insert firstCon;
         
        Date myDate = Date.newInstance(2015,10,17);
        Interaction__c interact = new Interaction__c(Contact__c = firstCon.Id,Account__c = accList[0].Id,Business_Status__c= 'Existing',Gender__c= 'Male',Meeting_Date__c = myDate, Advisor__c = 'Vikas Jain', Meeting_Status__c ='Confirmed', Meeting_Time__c ='1000',Location__c = 'City Hall');
        insert interact;
        
        try{
            delete accList[0]; 
         }
         catch (DMLException e) {
       //      System.assertEquals(e.getMessage().contains('Account has related child Interaction records and cannot be deleted'), true);
         }
     }    
}