@isTest
private class CCEventTest{
    public static TestMethod void MyTest(){
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        Account acc = new Account();
        acc.Name='City Of Toronto';
        acc.BillingCountry = 'Canada';
        acc.ShippingCountry = 'Canada';
        acc.RecordTypeId = rt.Id;
        acc.Automated_Account_Creation__c = true;
        insert acc;  
        Contact con = new Contact();
        con.LastName ='Test Contact';
        con.Email = 'Test@test.com';
        con.AccountId = acc.Id;
        insert con;
        Corporate_Calling__c cc = new Corporate_Calling__c();
        cc.Contact__c = con.Id;
        insert cc;
        CorporateCallingSubjects__c c = new CorporateCallingSubjects__c();
        c.Subject__c = 'Corporate Call, Corporate Call Meeting'; 
        insert c;     
        test.StartTest();
        
        Event ev = new Event();
        ev.WhatId = cc.Id;
        ev.DurationInMinutes = 10;
        Datetime dt = DateTime.newInstance(2017,10,8,01,02,03);
        ev.ActivityDateTime = dt;
        ev.StartDateTime = dt;
        ev.EndDateTime = dt.Addminutes(10);
        ev.Subject = 'Corporate Call';
        
        insert ev;
        
        test.StopTest();
    }
}