@istest
public class Test_UserSettingController
{
    static testmethod void createTestData1()
    {
         Account acct = new Account(Name='City Of Toronto', RecordTypeId='012o0000000Gb8K');
         insert acct;
         ID acctID = acct.ID;
         
         Contact firstCon = new Contact (LastName='Ray', AccountID = acctID, Email='test@cityoftoronto.com');
         insert firstCon;
         ID contactID = firstCon.ID;
         
         Consultation__c cont = new Consultation__c(Contact_Consultation__c = contactID, Business_Status__c= 'Existing',Gender__c= 'Male');
         insert cont;
         ID ConsultationID = cont.ID;
            
         Date myDate = Date.newInstance(2015,10,17);
         Consultation_Follow_up__c Followup = new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Vikas Jain', Status__c ='Confirmed', Meeting_Time__c ='10',Location__c = 'City Hall');
         insert Followup;
         
         Date myDate1 = Date.newInstance(2015,10,22);
         Date myDate2 = Date.newInstance(2015,10,23);
         Date myDate3 = Date.newInstance(2015,10,27);
         Date myDate4 = Date.newInstance(2015,10,28);
         
         List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
         lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate1 , End_Date__c = myDate2 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
         lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate3 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
         insert lstLeavePlan;
        
         
         PageReference pageRef = Page.User_Setting_Panel;
         Test.setCurrentPage(pageRef);
         
         UserSettingController usc = new UserSettingController();
         usc.AddLine();
     }
     
     
    static testmethod void createTestData2()
    {
        Profile pfl = [select id from profile where name='Standard User'];     
        
        List<User> lstUser = new List<User>();
        lstUser.add(new User(alias = 'db', email='deepabalib@mfs.com', emailencodingkey= 'UTF-8', FirstName='Ankita', lastname='Srivastava',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='deepabaliwwww@mindfiresolutions.com', Start_of_day__c ='09 AM', End_of_day__c = '05 PM', Monday__c = true, Tuesday__c = false, Wednesday__c = true, Thursday__c = false, Friday__c = true, Location__c = 'City Hall'));
        
        lstUser.add(new User(alias = 'dbm', email='deepalib@mfs.com',emailencodingkey='UTF-8', FirstName='Ankita', lastname='Srivastava' , languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='deepaliiiii@mindfiresolutions.com',Start_of_day__c ='09 AM', End_of_day__c = '05 PM', Monday__c = true, Tuesday__c = false, Wednesday__c = true, Thursday__c = false, Friday__c = false, Location__c = 'North York Civic Centre'));
        insert lstUser;
        
        Account acct = new Account(Name='City Of Toronto', RecordTypeId='012o0000000Gb8K');
        insert acct;
        ID acctID = acct.ID;
        
        Contact firstCon = new Contact (LastName='Ray', AccountID = acctID, Email='test@cityoftoronto.com');
        insert firstCon;
        ID contactID = firstCon.ID;
        
        Consultation__c cont = new Consultation__c(Contact_Consultation__c = contactID, Business_Status__c= 'Existing',Gender__c= 'Male');
        insert cont;
        ID ConsultationID = cont.ID;
        
        List<Consultation_Follow_up__c> lstFollowup = new List<Consultation_Follow_up__c>();   
        Date myDate = Date.newInstance(2015,10,20);
        Date myDate5 = Date.newInstance(2015,10,27);
        lstFollowup.add(new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Ankita Srivastava', Status__c ='Confirmed', Meeting_Time__c ='10',Location__c = 'City Hall'));
        lstFollowup.add(new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate5, Advisor__c = 'Ankita Srivastava', Status__c ='Confirmed', Meeting_Time__c ='10',Location__c = 'North York Civic Centre'));
        insert lstFollowup;
        
        Date myDate1 = Date.newInstance(2015,10,22);
        Date myDate2 = Date.newInstance(2015,10,23);
        Date myDate3 = Date.newInstance(2015,10,27);
        Date myDate4 = Date.newInstance(2015,10,28);
        
        List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
        lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate1 , End_Date__c = myDate2 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
        lstLeavePlan.add( new Leave_Plan__c(Start_Date__c = myDate3 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
        insert lstLeavePlan;
        
        PageReference pageRef = Page.User_Setting_Panel;
        Test.setCurrentPage(pageRef);
        
        UserSettingController usc = new UserSettingController();
        usc.LoggedUserName = 'Ankita Srivastava';
        usc.Approved = true;
        usc.Rescheduled = true;
        usc.followupId = lstFollowup[0].id;
        usc.SaveLeave();
        usc.SaveWorkingHour();
        usc.SaveFollowup();
        usc.EditUser();
        usc.EditLeave();
        usc.ApprovedFollowup();
        usc.ConfirmedCustomer();
        usc.ReschdueldFollowup();
        usc.CancelWorkingHrs();
        usc.CancelLeave();
        usc.CancelFollowUp();
        usc.leaveId = lstLeavePlan[0].id;
        usc.DeleteLeave();
        
     }
}