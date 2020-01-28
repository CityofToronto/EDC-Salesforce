@istest(SeeAllData=false)
public class Test_OnlineConsMeetingSchCompCtrl{
    static testmethod void createOnlineSchedulingCmpData(){
        
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
        
        Date myDate1 = Date.newInstance(2025,11,11);
        Date myDate2 = Date.newInstance(2025,10,23);
        Date myDate3 = Date.newInstance(2025,10,27);
        Date myDate4 = Date.newInstance(2025,10,28);
        
        List<Custom_Calendar__c> ccList = new List<Custom_Calendar__c>();
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate1, Availability_Start_Time__c = '08 00 AM',Availability_End_Time__c = '06 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate2, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate3, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        insert ccList;
        system.debug('ccList+++'+ccList);
        
        List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
        lstLeavePlan.add( new Leave_Plan__c(User__c =lstUser[0].Id, Start_Date__c = myDate3 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
        insert lstLeavePlan;
        
        List<Event> evList = new List <Event>();
        evList.add(new Event(DurationInMinutes = 60,OwnerId = lstUser[0].id,ActivityDateTime= DateTime.newInstance(2025, 11, 11, 11, 30, 00)));
        evList.add(new Event(DurationInMinutes = 60,OwnerId = lstUser[0].id,ActivityDateTime= DateTime.newInstance(2025, 11, 11, 08, 00, 00)));
        evList.add(new Event(DurationInMinutes = 15,OwnerId = lstUser[0].id,ActivityDateTime= DateTime.newInstance(2025, 11, 11, 13, 00, 00)));
        
        insert evList;
        
        OnlineConsultationMeetingSchCompCtrl Smeet = new OnlineConsultationMeetingSchCompCtrl();
        Smeet.InteractionRecId = interList[0].Id; 
        Smeet.AvailableLocations = null; 
        Smeet.AvailableAdvisors = null; 
        Smeet.AvailableTimeSlots = null; 
        Smeet.AvailableDateSlots = null;
        Smeet.WorkingDates= null;  
        
        Smeet.AvailableLocations();
        Smeet.LocationSelected= 'North York Civic Centre - 5100 Yonge Street - Main Floor';
        
        Smeet.AvailableAdvisors();
        Smeet.AdvisorSelected = lstUser[0].id;
        Smeet.AvailableDays();
        Smeet.DateSelected = '11-11-2025';
        Smeet.AvailableTimeSlots();
        Smeet.TimeSelected = '1000';
        Smeet.scheduleMeeting();
        PageReference pageRef = new PageReference('/apex/OnlineConsultationMeetingScheduler?InteractionId='+interList[0].Id);
        Smeet.PG = pageRef;
        Test.setCurrentPage(pageRef);
        
        OnlineConsultationMeetingSchCompCtrl Smeet1 = new OnlineConsultationMeetingSchCompCtrl();
        Smeet1.InteractionRecId = interList[1].Id; 
         
        Smeet1.AvailableLocations();
        Smeet1.LocationSelected= 'North York Civic Centre - 5100 Yonge Street - Main Floor';
        
        Smeet1.AvailableAdvisors();
        Smeet1.AdvisorSelected = lstUser[0].id;
        Smeet1.AvailableDays();
        Smeet1.DateSelected = '23-10-2025';
        Smeet1.AvailableTimeSlots();
        Smeet1.TimeSelected = '1000';
        Smeet1.scheduleMeeting();
        test.stoptest();

    } 
}