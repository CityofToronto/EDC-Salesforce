@isTest
private class Test_LeavePlanTrigger{
        
    static testMethod void createTestData(){
    
        Profile pfl = [select id from profile where name='EDC_Admin'];     
        List<User> lstUser = new List<User>();
        
        Date myDate1 = Date.newInstance(2020,11,11);
        Date myDate2 = Date.newInstance(2020,10,23);
        Date myDate3 = Date.newInstance(2020,10,27);
        Date myDate4 = Date.newInstance(2020,10,28);
         
        lstUser.add(new User(alias = 'tusr', email='16sep.test@gmail.com', emailencodingkey= 'UTF-8', Firstname='Test' ,lastname='User',languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,country='United States',CommunityNickname = 'u1',timezonesidkey='America/Los_Angeles',username='16sep.test@gmail.com', Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        lstUser.add(new User(alias = 'susr', email='jlli@toronto.ca.sandplay',emailencodingkey='UTF-8', Firstname='Sample', lastname='User', languagelocalekey='en_US',localesidkey='en_US', profileid = pfl.Id,  country='United States',CommunityNickname = 'u2',timezonesidkey='America/Los_Angeles',username='jlli@toronto.ca.sandplay',Consultation_Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        insert lstUser;
        
        List<Leave_Plan__c> lstLeavePlan = new List<Leave_Plan__c>();
        
        List<Custom_Calendar__c> ccList = new List<Custom_Calendar__c>();
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate1, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate2, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate3, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        ccList.add(new Custom_Calendar__c(User__c =lstUser[0].Id,Calendar_Date__c =  myDate4, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        ccList.add(new Custom_Calendar__c(User__c =lstUser[1].Id,Calendar_Date__c =  myDate1, Availability_Start_Time__c = '09 00 AM',Availability_End_Time__c = '03 00 PM', Location__c = 'North York Civic Centre - 5100 Yonge Street - Main Floor'));
        insert ccList;
        
        lstLeavePlan.add( new Leave_Plan__c(User__c =lstUser[0].Id, Start_Date__c = myDate3 , End_Date__c = myDate3 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
        lstLeavePlan.add( new Leave_Plan__c(User__c =lstUser[0].Id, Start_Date__c = myDate4 , End_Date__c = myDate4 , Start_Time__c ='09 AM', End_Time__c ='06 PM'));
        
        insert lstLeavePlan;
        
        delete lstLeavePlan[1];
    }
}