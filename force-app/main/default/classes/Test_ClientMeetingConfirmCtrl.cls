@isTest

public class Test_ClientMeetingConfirmCtrl
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
         
         PageReference pageRef = Page.ClientMeetingConfirm;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('Id',Followup.Id);
         
         ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
        
    }
    
    static testmethod void createTestData2()
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
         Consultation_Follow_up__c Followup = new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Vikas Jain', Status__c ='Requested', Meeting_Time__c ='10',Location__c = 'City Hall');
         insert Followup; 
         
         PageReference pageRef = Page.ClientMeetingConfirm;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('Id','');
         
          ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
        
    }
    
    
    
      static testmethod void createTestData3()
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
         
         PageReference pageRef = Page.ClientMeetingConfirm;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('FollowRecId','');
         ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
        
    }
    
     static testmethod void createTestData4()
    {
         Account acct = new Account(Name='City Of Toronto', RecordTypeId='012o0000000Gb8K');
         insert acct;
         ID acctID = acct.ID;
         
         Contact firstCon = new Contact (LastName='Ray', AccountID = acctID, Email='testme@cityoftoronto.com');
         insert firstCon;
         ID contactID = firstCon.ID;
         
         Consultation__c cont = new Consultation__c(Contact_Consultation__c = contactID, Business_Status__c= 'Existing',Gender__c= 'Male');
         insert cont;
         ID ConsultationID = cont.ID;
            
         Date myDate = Date.newInstance(2015,10,17);
         Consultation_Follow_up__c Followup = new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Vikas Jain', Status__c ='Confirmed', Meeting_Time__c ='10',Location__c = 'City Hall');
         insert Followup;
          
         PageReference pageRef = Page.ClientMeetingConfirm;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('FollowRecId',Followup.id);
         ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
        
    }
    
    static testmethod void createTestData5()
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
         
         PageReference pageRef = Page.ClientMeetingConfirm;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('ShowCal',Followup.id);
         ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
        
    }
    
    static testmethod void createTestData6()
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
         Consultation_Follow_up__c Followup = new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Vikas Jain', Status__c ='Requested', Meeting_Time__c ='10',Location__c = 'City Hall');
         insert Followup;
         
         PageReference pageRef = Page.ClientMeetingConfirm;
         Test.setCurrentPage(pageRef);
         ApexPages.currentPage().getParameters().put('ShowCal','true');
         ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
       
    }
    
    static testmethod void createTestData7()
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
         Consultation_Follow_up__c Followup = new Consultation_Follow_up__c(Consultation__c = ConsultationID, Meeting_Date__c = myDate, Advisor__c = 'Vikas Jain', Status__c ='Requested', Meeting_Time__c ='10',Location__c = 'City Hall');
         insert Followup;
         
         //PageReference pageRef = Page.ClientMeetingConfirm;
         //Test.setCurrentPage(pageRef);
        
         ClientMeetingConfirmCtrl confirmmeeting = new ClientMeetingConfirmCtrl();
         
         confirmmeeting.FollowUp = [select id, Status__c From Consultation_Follow_up__c Where Id=: Followup.id];
         
         confirmmeeting.MeetingConfirmed();
         confirmmeeting.MeetingReschuled();
    }
}