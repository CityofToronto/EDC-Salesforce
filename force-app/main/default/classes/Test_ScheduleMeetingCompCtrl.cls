@istest
public class Test_ScheduleMeetingCompCtrl
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
         
         List<Consultation_Follow_up__c> lstFollowup = new List<Consultation_Follow_up__c>();   
         Date myDate = Date.newInstance(2015,10,20);
         Date myDate5 = Date.newInstance(2015,10,27);
         lstFollowup.add(new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Ankita Srivastava', Status__c ='Confirmed', Meeting_Time__c ='10',Location__c = 'City Hall'));
         lstFollowup.add(new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate5, Advisor__c = 'Ankita Srivastava', Status__c ='Confirmed', Meeting_Time__c ='10',Location__c = 'North York Civic Centre'));
         insert lstFollowup;
         
         Date myDate1 = Date.newInstance(2015,11,11);
         Date myDate2 = Date.newInstance(2015,10,23);
         Date myDate3 = Date.newInstance(2015,10,27);
         Date myDate4 = Date.newInstance(2015,10,28);
         
         Profile pfl = [select id from profile where name='Standard User'];     
         List<User> lstUser = new List<User>();
         
         lstUser.add(new User(alias = 'asriv', email='16sep.ankitta@gmail.com', emailencodingkey= 'UTF-8', Firstname='Ankita' ,lastname='Srivastava',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='16sep.ankitta@gmail.com', Start_of_day__c ='09 AM', End_of_day__c = '05 PM', Monday__c = true, Tuesday__c = false, Wednesday__c = true, Thursday__c = false, Friday__c = true, Location__c = 'Scarborough Civic Centre'));
         
         lstUser.add(new User(alias = 'jli', email='jlli@toronto.ca.sandplay',emailencodingkey='UTF-8', Firstname='Ankita', lastname='Srivastava', languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='jlli@toronto.ca.sandplay',Start_of_day__c ='09 AM', End_of_day__c = '05 PM', Monday__c = true, Tuesday__c = false, Wednesday__c = true, Thursday__c = false, Friday__c = false, Location__c = 'North York Civic Centre'));
         insert lstUser;
         
         List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
         lstLeavePlan.add( new Leave_Plan__c(User__c =lstUser[0].Id, Start_Date__c = myDate1 , End_Date__c = myDate1 , Start_Time__c ='09 AM', End_Time__c ='03 PM'));
         lstLeavePlan.add( new Leave_Plan__c(User__c =lstUser[0].Id, Start_Date__c = myDate3 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
         insert lstLeavePlan;
         
         JqueryDatePicker__c Jdp = new JqueryDatePicker__c(Name = 'DatePicker', NoOfMonths__c = '1', StartDateFrom__c = '', StartDateTo__c = '60');
         insert Jdp;
        
         Set<Date> NotWorkingDates = New Set<Date>();
         for(integer i=1; i <45; i++)
         {
            Datetime dt = DateTime.newInstance(System.today().adddays(i), Time.newInstance(0, 0, 0, 0));
            NotWorkingDates.add(dt.date());
         }
         
         ScheduleMeetingCompCtrl Smeet = new ScheduleMeetingCompCtrl();
         Smeet.NotWorkingDates = NotWorkingDates;
         Smeet.FollowUpEmail = cont.Contact_Consultation__r.Email; 
         Smeet.AdvisorSelected = lstUser[0].id;
         Smeet.DateSelected = '11/11/2015';
         Smeet.NoOfMonths = Jdp.NoOfMonths__c; 
         Smeet.StartDateTo = Jdp.StartDateTo__c;
         Smeet.AvailableLocations();
         Smeet.AvailableAdvisors();
         Smeet.AvailableDays();
         Smeet.AvailableTimeSlots();
         Smeet.ReScheduleMeeting();
         Smeet.Dummy();
         Smeet.FollowUpEmail = 'test@cityoftoronto.com';
         PageReference pageRef = new PageReference('/apex/ClientMeetingSchedule?email=test@cityoftoronto.com');
         Smeet.PG = pageRef;
         Test.setCurrentPage(pageRef);
         Smeet.TimeSelected = '10';
         Smeet.scheduleMeeting();  
         
         
         ScheduleMeetingCompCtrl Smeet1 = new ScheduleMeetingCompCtrl();
         Smeet1.NotWorkingDates = NotWorkingDates;
         Smeet1.FollowUpEmail = cont.Contact_Consultation__r.Email; 
         Smeet1.AdvisorSelected = lstUser[0].id;
         Smeet1.DateSelected = '11/11/2015';
         Smeet1.NoOfMonths = Jdp.NoOfMonths__c; 
         Smeet1.StartDateTo = Jdp.StartDateTo__c;
         Smeet1.AvailableLocations();
         Smeet1.AvailableAdvisors();
         Smeet1.AvailableDays();
         Smeet1.AvailableTimeSlots();
         Smeet1.ReScheduleMeeting();
         Smeet1.Dummy();
         Smeet1.FollowUpId= lstFollowup[0].Id;
         PageReference pageRef1 = new PageReference('/apex/ClientMeetingSchedule?FollowUpId='+lstFollowup[0].Id);
         Smeet1.PG = pageRef1;
         Test.setCurrentPage(pageRef1);
         Smeet1.TimeSelected = '10';
         Smeet1.scheduleMeeting();        
     }
}