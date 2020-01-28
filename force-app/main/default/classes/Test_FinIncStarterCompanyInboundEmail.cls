/**
* @File Name:   Test_FinIncStarterCompanyInboundEmail.cls
* @Description: Test class for email service FinIncStarterCompanyInboundEmail.cls   
* @Author:      Manish Gaur
* @Group:       Apex 
* @Last Modified by:   Manish
* @Last Modified time: 2019-09-09
* @Modification Log :
*-------------------------------------------------------------------------------------
* Ver       Date        Author         Modification
* 1.0       2019-09-09  Manish Gaur    Created the file/class
*/
@isTest
private without sharing class Test_FinIncStarterCompanyInboundEmail{
    @testsetup
    static void setupTestData(){
        RecordType rtBus = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        Map<String,String> finRTMap = new Map<String,String>();
        for(RecordType rt: [SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c']){
            finRTMap.put(rt.DeveloperName,rt.Id); 
        }
        //Below code create list of Account records Business and Person Account
        List<Account> accList = new List<Account>(); 
        accList.add(new Account(Name='City Of Toronto 1',BillingCountry = 'Canada', ShippingCountry = 'Canada',RecordTypeId = rtBus.Id,Account_Type__c ='Business Client',Physical_Continent__c ='North America'));
        insert accList;
        
        //Below code create list of Contact records
        List<Contact> conList = new List<Contact>();
        conList.add(new Contact(firstname='Test',lastname='Contact',Email='test@cityoftoronto.com',AccountId=accList[0].Id));
        insert conList;
                //Below code create list of Starter Company records
        List<Financial_Incentive__c> finIncList = new List<Financial_Incentive__c >();
        //Sector Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=finRTMap.get('Sector_Grant'),Status__c='Draft'));
        //Starter Company Grant Record
        finIncList.add(new Financial_Incentive__c (Contact__c = conList[0].Id, Account__c = accList[0].Id,RecordTypeId=finRTMap.get('Starter_Company_Grant'),Status__c='Draft'));
        insert finIncList;
    }
    
    static testMethod void test_PositiveCalllInboundEmailService() {
        Messaging.InboundEmail email = new Messaging.InboundEmail() ;
        Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
        Financial_Incentive__c fin=[SELECT Id, Financial_Incentive_Name__c FROM Financial_Incentive__c WHERE Financial_Incentive_Name__c LIKE: '%STR%'];
        String recName = fin.Financial_Incentive_Name__c;
        email.subject = 'Sample Subject'+recName;
        email.plainTextBody = 'FromEmail Sample Test Data';
        env.fromAddress = 'SampleEmail@testcom';
        Messaging.InboundEmail.BinaryAttachment binaryAttachment = new Messaging.InboundEmail.BinaryAttachment();
        binaryAttachment.Filename = 'test.pdf';
        binaryAttachment.body = blob.valueOf('my attachment text');
        email.binaryAttachments = new Messaging.inboundEmail.BinaryAttachment[] { binaryattachment }; 
        
        Messaging.InboundEmail.TextAttachment textAttachment = new Messaging.InboundEmail.TextAttachment ();
        textAttachment.Filename = 'test.txt';
        textAttachment.body = 'my attachment text';
        email.TextAttachments = new Messaging.inboundEmail.TextAttachment [] { textAttachment }; 
 
         
        FinIncStarterCompanyInboundEmail updateFinInc = new FinIncStarterCompanyInboundEmail();
        updateFinInc.handleInboundEmail(email, env );
    
    }
    static testMethod void test_NegativeCalllInboundEmailService() {
        try{
            Messaging.InboundEmail email = new Messaging.InboundEmail() ;
            Messaging.InboundEnvelope env = new Messaging.InboundEnvelope();
      
            email.plainTextBody = 'FromEmail Sample Test Data';
            env.fromAddress = 'SampleEmail@testcom';
      
            FinIncStarterCompanyInboundEmail updateFinInc = new FinIncStarterCompanyInboundEmail();
            updateFinInc.handleInboundEmail(email, env );
        }
        catch (Exception e) {
        
        }
    }
    
}