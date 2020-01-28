@isTest
public class ClientFollowUpsForConsultTests {

    static testMethod void validateUpdate() {
        Account a = new Account(Name = 'TestAccountqwert', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmailqwerty.com';
        c.AccountId = a.Id;
        c.LastName = 'Testqwerty';
        insert c;
        
        Consultation__c co = new Consultation__c();
        co.Contact_Consultation__c = c.Id;
        insert co;
        
        co.Number_Of_Employees__c = 1;
        update co;
        
        // Retrieve the new Client_Follow_up__c
        /*
        Client_Follow_up__c cf = [SELECT ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        System.assertEquals('Consultation', cf.ET_Engagement_Type__c);
        System.assertEquals('Consultation', cf.Work_Flow_Session__c);
        */
    }
    
    static testMethod void validateInsert1() {
        Account a = new Account(Name = 'TestAccountqwert', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmailqwerty.com';
        c.AccountId = a.Id;
        c.LastName = 'Testqwerty';
        insert c;
        
        Client_Follow_up__c cf = new Client_Follow_up__c();
        cf.Contact_ClientFollowUp__c = c.Id;
        cf.Account_ClientFollowUp__c = a.Id;
        insert cf;
        
        Consultation__c co = new Consultation__c();
        co.Contact_Consultation__c = c.Id;
        insert co;
        
        // Retrieve the new Client_Follow_up__c
        /*
        cf = [SELECT Account_ClientFollowUp__c, Consultation_ClientFollowUp__c, Contact_ClientFollowUp__c, ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        System.assertEquals(a.Id, cf.Account_ClientFollowUp__c);
        System.assertEquals(co.Id, cf.Consultation_ClientFollowUp__c);
        System.assertEquals(c.Id, cf.Contact_ClientFollowUp__c);
        System.assertEquals('Consultation', cf.ET_Engagement_Type__c);
        System.assertEquals('Consultation', cf.Work_Flow_Session__c);    
        */
    }
    
    static testMethod void validateInsert2() {
        Account a = new Account(Name = 'TestAccount', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmail.com';
        c.AccountId = a.Id;
        c.LastName = 'Test';
        insert c;
        
        Consultation__c co = new Consultation__c();
        co.Contact_Consultation__c = c.Id;
        insert co;
        
        // Retrieve the new Client_Follow_up__c
        /*Client_Follow_up__c cf = [SELECT Account_ClientFollowUp__c, Consultation_ClientFollowUp__c, Contact_ClientFollowUp__c, ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        //System.assertEquals(a.Id, cf.Account_ClientFollowUp__c);
        System.assertEquals(co.Id, cf.Consultation_ClientFollowUp__c);
        System.assertEquals(c.Id, cf.Contact_ClientFollowUp__c);
        System.assertEquals('Consultation', cf.ET_Engagement_Type__c);
        System.assertEquals('Consultation', cf.Work_Flow_Session__c);
        */
    }
}