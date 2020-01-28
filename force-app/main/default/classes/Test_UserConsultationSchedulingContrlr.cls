@istest
public class Test_UserConsultationSchedulingContrlr
{
    static testmethod void createTestData1()
    {
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        Account acct = new Account(Name='City Of Toronto', RecordTypeId=rt.Id);
        insert acct;
        ID acctID = acct.ID;
         
         Contact firstCon = new Contact (LastName='Ray', AccountID = acctID, Email='test@cityoftoronto.com');
         insert firstCon;
         ID contactID = firstCon.ID;
         Profile pfl = [select id from profile where name='EDC_Admin'];     
         List<User> lstUser = new List<User>();
         
         lstUser.add(new User(alias = 'asriv', email='16sep.test@gmail.com', emailencodingkey= 'UTF-8', Firstname='Test' ,lastname='User',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='16sep.test@gmail.com', Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         
         lstUser.add(new User(alias = 'jli', email='jlli@toronto.ca.sandplay',emailencodingkey='UTF-8', Firstname='Sample', lastname='User', languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='jlli@toronto.ca.sandplay',Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         insert lstUser;
         
         
         List<Interaction__c > interList = new List<Interaction__c >();
         interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male'));
         interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male',Advisor_Lookup__c=lstUser[0].Id,Meeting_Status__c='Confirmed',Meeting_date__c=Date.newInstance(2018, 11, 11),Meeting_Time__c='1000',Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male',Advisor_Lookup__c=lstUser[0].Id,Meeting_Status__c='Requested',Meeting_date__c=Date.newInstance(2018, 11, 11),Meeting_Time__c='1500',Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         insert interList;
         
         Date myDate1 = Date.newInstance(2018,10,22);
         Date myDate2 = Date.newInstance(2018,10,23);
         Date myDate3 = Date.newInstance(2018,10,27);
         Date myDate4 = Date.newInstance(2018,10,28);
         
         List<Custom_Calendar__c> ccList = new List<Custom_Calendar__c>();
         ccList.add(new Custom_Calendar__c(User__c =UserInfo.getUserId(),Calendar_Date__c =  myDate1, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =UserInfo.getUserId(),Calendar_Date__c =  myDate2, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =UserInfo.getUserId(),Calendar_Date__c =  myDate3, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =UserInfo.getUserId(),Calendar_Date__c =  myDate4, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =UserInfo.getUserId(),Calendar_Date__c =  myDate1, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =UserInfo.getUserId(),Calendar_Date__c =  myDate1, Availability_Start_Time__c = '05 00 PM',Availability_End_Time__c = '06 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         insert ccList;
         system.debug('ccList+++'+ccList);
         
         List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
         lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate1 , End_Date__c = myDate1 , Start_Time__c ='09 AM', End_Time__c ='06 PM',User__c=UserInfo.getUserId()));
         lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate4 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM',User__c=UserInfo.getUserId()));
         insert lstLeavePlan;
        
        
        PageReference pageRef = Page.User_Setting_Panel;
        Test.setCurrentPage(pageRef);
        
        UserConsultationSchedulingController usc = new UserConsultationSchedulingController();
        usc.LoggedUserName = 'Test User';
        usc.Approved = true;
        usc.Rescheduled = true;
        usc.followupId = interList[1].id;
        usc.SaveLeave();
        usc.SaveWorkingHour();
        usc.SaveFollowup();
        usc.EditUser();
        usc.EditLeave();
        usc.ApprovedFollowup();
        //usc.ConfirmedCustomer();
        usc.RejectFollowup();
        usc.CancelledConsultationFollowup();
        usc.CancelWorkingHrs();
        usc.CancelLeave();
        usc.calendarRecId=ccList[0].Id;
        usc.DeleteCalendarRow();
        usc.CancelFollowUp();
        usc.leaveId = lstLeavePlan[0].id;
        usc.DeleteLeave();
     }
     static testmethod void createTestData2()
    {
        RecordType rt = [select id,Name from RecordType where SobjectType='Account' and DeveloperName='Business_Account'];
        Account acct = new Account(Name='City Of Toronto', RecordTypeId=rt.Id);
        insert acct;
        ID acctID = acct.ID;
         
         Contact firstCon = new Contact (LastName='Ray', AccountID = acctID, Email='test@cityoftoronto.com');
         insert firstCon;
         ID contactID = firstCon.ID;
         Profile pfl = [select id from profile where name='EDC_Admin'];     
         List<User> lstUser = new List<User>();
         
         lstUser.add(new User(alias = 'asriv', email='16sep.test@gmail.com', emailencodingkey= 'UTF-8', Firstname='Test' ,lastname='User',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='16sep.test@gmail.com', Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         
         lstUser.add(new User(alias = 'jli', email='jlli@toronto.ca.sandplay',emailencodingkey='UTF-8', Firstname='Sample', lastname='User', languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='jlli@toronto.ca.sandplay',Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         insert lstUser;
         
         
         List<Interaction__c > interList = new List<Interaction__c >();
         interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male'));
         interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male',Advisor_Lookup__c=lstUser[0].Id,Meeting_Status__c='Confirmed',Meeting_date__c=Date.newInstance(2018, 11, 11),Meeting_Time__c='1000',Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         interList.add(new Interaction__c(Contact__c = contactID,Account__c = acctID ,Business_Status__c= 'Existing',Gender__c= 'Male',Advisor_Lookup__c=lstUser[0].Id,Meeting_Status__c='Requested',Meeting_date__c=Date.newInstance(2018, 11, 11),Meeting_Time__c='1500',Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         insert interList;
         
         Date myDate1 = Date.newInstance(2018,10,22);
         Date myDate2 = Date.newInstance(2018,10,23);
         Date myDate3 = Date.newInstance(2018,10,27);
         Date myDate4 = Date.newInstance(2018,10,28);
         
         List<Custom_Calendar__c> ccList = new List<Custom_Calendar__c>();
         ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate1, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate2, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate3, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate4, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =lstUser[1].Id,Calendar_Date__c =  myDate1, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         ccList.add(new Custom_Calendar__c(User__c =lstUser[1].Id,Calendar_Date__c =  myDate1, Availability_Start_Time__c = '05 00 PM',Availability_End_Time__c = '06 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
         insert ccList;
         system.debug('ccList+++'+ccList);
         
         List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
         lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate1 , End_Date__c = myDate1 , Start_Time__c ='09 AM', End_Time__c ='06 PM',User__c=lstUser[0].Id));
         lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate4 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM',User__c=lstUser[0].Id));
         insert lstLeavePlan;
        
        
        PageReference pageRef = Page.User_Setting_Panel;
        Test.setCurrentPage(pageRef);
        
        UserConsultationSchedulingController usc = new UserConsultationSchedulingController();
        usc.AddLine();
        usc.AddCalendarLine();
        usc.selectStartTime = '10 AM';
        usc.selectEndTime = '11 AM';
        usc.Confirm = 'Confirmed';
        usc.userId = lstUser[0].Id;
        usc.ReadOnlyFollowup =false;
        
        
    }   
}