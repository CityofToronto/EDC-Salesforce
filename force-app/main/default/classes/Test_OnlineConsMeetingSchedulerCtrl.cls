@isTest(SeeAllData=false)

public class Test_OnlineConsMeetingSchedulerCtrl{
    static testmethod void createTestData1(){
         Profile pfl = [select id from profile where name='EDC_Admin'];     
        List<User> lstUser = new List<User>();
        lstUser.add(new User(alias = 'asriv', email='16sep.test@gmail.com', emailencodingkey= 'UTF-8', Firstname='Test' ,lastname='User',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='16sep.test@gmail.com', Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        lstUser.add(new User(alias = 'jli', email='jlli@toronto.ca.sandplay',emailencodingkey='UTF-8', Firstname='Test', lastname='User2', languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='jlli@toronto.ca.sandplay',Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        insert lstUser;
        
        Account acct = new Account(Name='City Of Toronto', RecordTypeId='012o0000000Gb8K');
        insert acct;
        Id acctID = acct.ID;
         
        Contact firstCon = new Contact (LastName='Ray', AccountID = acctID, Email='test@cityoftoronto.com');
        insert firstCon;
        Id contactID = firstCon.ID;
        
        test.starttest();
         
        List<Interaction__c > interList = new List<Interaction__c >();
        interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male'));
        interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male',Advisor_Lookup__c=lstUser[0].Id,Meeting_Status__c='Cancelled by Advisor',Meeting_date__c=Date.newInstance(2025, 11, 11)));
        interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male',Advisor_Lookup__c=lstUser[0].Id,Meeting_Status__c='Requested',Meeting_date__c=Date.newInstance(2025, 11, 11),Meeting_Time__c='1500'));
        insert interList;

        PageReference pageRef = Page.OnlineConsultationMeetingScheduler;
        pageRef.getParameters().put('InteractionId', interList[0].Id);
        pageRef.getParameters().put('FollowRecId', interList[2].Id);
        Test.setCurrentPage(pageRef);
        OnlineConsultationMeetingSchedulerCtrl onlineConContrlr = new OnlineConsultationMeetingSchedulerCtrl();
        
        PageReference pageRef2 = Page.OnlineConsultationMeetingScheduler;
        pageRef2.getParameters().put('InteractionId', '');
        pageRef2.getParameters().put('FollowRecId', '');
        Test.setCurrentPage(pageRef2);
        OnlineConsultationMeetingSchedulerCtrl onlineConContrlr2 = new OnlineConsultationMeetingSchedulerCtrl();


        PageReference pageRef3 = Page.OnlineConsultationMeetingScheduler;
        pageRef3.getParameters().put('InteractionId', '312312sdasda');
        Test.setCurrentPage(pageRef3);
        OnlineConsultationMeetingSchedulerCtrl onlineConContrlr3 = new OnlineConsultationMeetingSchedulerCtrl();

        test.stoptest();
    }
}