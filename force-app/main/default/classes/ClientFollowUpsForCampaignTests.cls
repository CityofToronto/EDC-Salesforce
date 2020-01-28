@isTest
public class ClientFollowUpsForCampaignTests {
    static testMethod void validateUpdate() {
        Account a = new Account(Name = 'TestAccount', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmail.com';
        c.AccountId = a.Id;
        c.LastName = 'Test';
        insert c;
        
        Campaign ca = new Campaign(Name='ET-Event Test', Type='Training (ET)');
        ca.IsActive = False;
        ca.Status = 'Completed';
        insert ca;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = ca.Id;
        cm.ContactId = c.Id;
        insert cm;
        
        //cm.Street = '1111111';
        update cm;
        
        // Retrieve the new Client_Follow_up__c
        /*
        Client_Follow_up__c cf = [SELECT ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Contact_ClientFollowUp__c =: c.Id];
        
        System.assertEquals('Training', cf.ET_Engagement_Type__c);
        System.assertEquals('Training', cf.Work_Flow_Session__c);
        */
    }
    
    static testMethod void validateInsert1() {
        Account a = new Account(Name = 'TestAccount', RecordTypeId='012o0000000Gb8K');
        insert a;
        
        Contact c = new Contact();
        c.Email = 'test@testmail.com';
        c.AccountId = a.Id;
        c.LastName = 'Test';
        insert c;
        
        Client_Follow_up__c cf = new Client_Follow_up__c();
        cf.Contact_ClientFollowUp__c = c.Id;
        cf.Account_ClientFollowUp__c = a.Id;
        insert cf;
        
        Campaign ca = new Campaign(Name='ET-Event Test', Type='Training (ET)');
        ca.IsActive = False;
        ca.Status = 'Completed';
        insert ca;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = ca.Id;
        cm.ContactId = c.Id;
        insert cm;
        
        // Retrieve the new Client_Follow_up__c
        /*
        cf = [SELECT Campaign_ID__c, Contact_ClientFollowUp__c, ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Campaign_ID__c =: ca.Id];
        
        System.assertEquals(ca.Id, cf.Campaign_ID__c);
        System.assertEquals(c.Id, cf.Contact_ClientFollowUp__c);
        System.assertEquals('Training', cf.ET_Engagement_Type__c);
        System.assertEquals('Training', cf.Work_Flow_Session__c);  
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
        
        Campaign ca = new Campaign(Name='ET-Event Test', Type='Training (ET)');
        ca.IsActive = False;
        ca.Status = 'Completed';
        insert ca;
        
        CampaignMember cm = new CampaignMember();
        cm.CampaignId = ca.Id;
        cm.ContactId = c.Id;
        insert cm;
        
        // Retrieve the new Client_Follow_up__c
        /*
        Client_Follow_up__c cf = [SELECT Campaign_ID__c, Contact_ClientFollowUp__c, ET_Engagement_Type__c, Work_Flow_Session__c FROM Client_Follow_up__c WHERE Campaign_ID__c =: ca.Id];
        
        //System.assertEquals(cm.Id, cf.Campaign_ID__c);
        System.assertEquals(c.Id, cf.Contact_ClientFollowUp__c);
        System.assertEquals('Training', cf.ET_Engagement_Type__c);
        System.assertEquals('Training', cf.Work_Flow_Session__c);
        */
    }
    
}