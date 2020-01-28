@isTest
public class ClientFollowUpsForOnlineRegTests {
    
    static testMethod void validateUpdate() {
        Account a = new Account(Name = 'TestAccountqwert', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmailqwerty.com';
        c.AccountId = a.Id;
        c.LastName = 'Testqwerty';
        insert c;
        
        Online_Registration__c o = new Online_Registration__c();
        o.Account__c = a.Id;
        o.Contact__c = c.Id;
        insert o;
        
        o.Type_of_Registration_BNR__c = 'General Partnership';
        update o;
        
        // Retrieve the new Client_Follow_up__c
        /*
        Client_Follow_up__c cf = [SELECT ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        System.assertEquals('Registration', cf.ET_Engagement_Type__c);
        System.assertEquals('Registration', cf.Work_Flow_Session__c);
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
        
        Online_Registration__c o = new Online_Registration__c();
        o.Account__c = a.Id;
        o.Contact__c = c.Id;
        insert o;
        
        // Retrieve the new Client_Follow_up__c
        /*
        cf = [SELECT Account_ClientFollowUp__c, RegistrationID__c, Contact_ClientFollowUp__c, ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        System.assertEquals(a.Id, cf.Account_ClientFollowUp__c);
        System.assertEquals(o.Id, cf.RegistrationID__c);
        System.assertEquals(c.Id, cf.Contact_ClientFollowUp__c);
        System.assertEquals('Registration', cf.ET_Engagement_Type__c);
        System.assertEquals('Registration', cf.Work_Flow_Session__c);
        */    
    }
    
    static testMethod void validateInsert2() {
        Account a = new Account(Name = 'TestAccountqwert', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmailqwerty.com';
        c.AccountId = a.Id;
        c.LastName = 'Testqwerty';
        insert c;
        
        Online_Registration__c o = new Online_Registration__c();
        o.Account__c = a.Id;
        o.Contact__c = c.Id;
        insert o;
        
        // Retrieve the new Client_Follow_up__c
        /*
        Client_Follow_up__c cf = [SELECT Account_ClientFollowUp__c, RegistrationID__c, Contact_ClientFollowUp__c, ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        System.assertEquals(a.Id, cf.Account_ClientFollowUp__c);
        System.assertEquals(o.Id, cf.RegistrationID__c);
        System.assertEquals(c.Id, cf.Contact_ClientFollowUp__c);
        System.assertEquals('Registration', cf.ET_Engagement_Type__c);
        System.assertEquals('Registration', cf.Work_Flow_Session__c);
        */
    }
}