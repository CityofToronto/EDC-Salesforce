public class UserSettingController
{
    public String selectStartTime{get;set;}
    public String selectEndTime{get;set;}
    public String leaveId{get;set;}
    public String userId{get;set;}
    public String followupId{get;set;}
    public List<User> LstLoggedUser {get;set;}
    public List<Leave_Plan__c> lstLeaveplan{get;set;}
    public List<Consultation_Follow_up__c> lstFollowUpObj{get;set;}
    public String selectedMeetingView {get;set;}
    public boolean ReadOnlyLeave {get;set;}
    public boolean EditableLeave {get;set;}
    public boolean ReadOnlyUser {get;set;}
    public boolean EditableUser {get;set;}
    public boolean ReadOnlyFollowup {get;set;}
    public boolean EditableFollowup {get;set;}
    public boolean Approved {get;set;}
    public boolean Rescheduled {get;set;}
    public boolean Rejected {get;set;}
    public String LoggedUserName {get;set;}
    public String Confirm{get;set;}
    private Id CurrUserId;
    public boolean ConfirmfrmClient;
     
    public UserSettingController()
    {  
        CurrUserId = UserInfo.getUserId(); 
        LoggedUserName = UserInfo.getName();
        selectedMeetingView = 'ALL';
        
        LstLoggedUser = [select Id, Name, DayStartTime__c, DayEndTime__c, Start_of_day__c, End_of_day__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Location__c FROM User where Id=:CurrUserId limit 1];
        lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__C =: CurrUserId AND End_Date__c >=: date.today()];
        lstFollowUpObj = [select id, Consultation__r.Contact_Consultation__r.Name,Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Advisor__c, Meeting_Time__c, Location__c, Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName order by Meeting_Date__c ASC];
    }
    
    public pagereference AddLine()
    {
        boolean AddRow = true;

        for(Leave_Plan__c s: lstLeaveplan)
        {
            if(s.id == null)
            AddRow = false;
        }

        if(AddRow)
            lstLeaveplan.add(new Leave_Plan__c());

        return null;   
    }
    
    public void OnChangeMeetingView()
    {
		if (selectedMeetingView == 'ALL')
        	lstFollowUpObj = [select id, Consultation__r.Contact_Consultation__r.Name,Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Advisor__c, Meeting_Time__c, Location__c, Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName order by Meeting_Date__c ASC];        
        else if (selectedMeetingView == 'CC')
        	lstFollowUpObj = [select id, Consultation__r.Contact_Consultation__r.Name,Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Advisor__c, Meeting_Time__c, Location__c, Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName AND Status__c = 'Confirmed' AND Meeting_Date__c <: date.today() order by Meeting_Date__c ASC];
        else if (selectedMeetingView == 'CU')
        	lstFollowUpObj = [select id, Consultation__r.Contact_Consultation__r.Name,Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Advisor__c, Meeting_Time__c, Location__c, Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName AND Status__c = 'Confirmed' AND Meeting_Date__c >=: date.today() order by Meeting_Date__c ASC];
        else if (selectedMeetingView == 'REJ')
        	lstFollowUpObj = [select id, Consultation__r.Contact_Consultation__r.Name,Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Advisor__c, Meeting_Time__c, Location__c, Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName AND Status__c = 'Rejected' order by Meeting_Date__c ASC];
    }
    
//SAVE START *************************************************************

    public pagereference SaveWorkingHour()
    {
        if(LstLoggedUser[0].Start_of_day__c != null && LstLoggedUser[0].End_of_day__c != null )
        {
            update LstLoggedUser[0];
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please add working start time and end time.'));
            return null;
        }
       
        EditableUser = false;
        ReadOnlyUser = true;
        
        return null;
    }
    
    public pagereference SaveLeave()
    {
        List<Leave_Plan__c> lnsertLeavePlan = new List<Leave_Plan__c>();
        List<Leave_Plan__c> updateLeavePlan = new List<Leave_Plan__c>();
      
        system.debug('VKS__1 '+ lstLeaveplan);
         
        for(Leave_Plan__c lp: lstLeaveplan)
        {
            if(lp.id == null)
            {
                system.debug('VKS__2 '+ lp.id);
                system.debug('VKS__2 '+ lp); 
                //2015-10-13 00:00:00, End_Date__c=2015-10-14 00:00:00, Start_Time__c=12 PM, End_Time__c=02 PM
                
                if(lp.Start_Date__c != null && lp.End_Date__c!= null && lp.Start_Time__c != null && lp.End_Time__c!=null && lp.Start_Date__c <= lp.End_Date__c)  //&& Integer.ValueOf(lp.Start_Time__c.split(' ')[0]) < Integer.ValueOf(lp.End_Time__c.split(' ')[0]))
                {
                    system.debug('VKS__3 '+ lp.id);
                    lp.User__c = CurrUserId;
                    lnsertLeavePlan.add(lp);
                }
                else
                {
                    system.debug(' **** Ankita ***** ');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid and complete information for leave plan in order to save it.'));
                    return null;
                }
            }
            
            if(leaveId != null && leaveId != '' && lp.id == leaveId)
            {
                if(lp.Start_Date__c != null && lp.End_Date__c!= null && lp.Start_Time__c != null && lp.End_Time__c!=null && lp.Start_Date__c <= lp.End_Date__c) // && Integer.ValueOf(lp.Start_Time__c.split(' ')[0]) < Integer.ValueOf(lp.End_Time__c.split(' ')[0]))
                {
                    updateLeavePlan .add(lp);
                }
                else
                {
                    system.debug(' **** Ankita ***** ');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid and complete information for leave plan in order to save it.'));
                    return null;
                }
            }
        }
        
        system.debug('VKS__5 '+ lnsertLeavePlan.size());
        
        if(updateLeavePlan .size()>0)
        {
            update updateLeavePlan ; 
            updateLeavePlan .clear();
            leaveId = null;
        }
        
        if(lnsertLeavePlan.size()>0)
        {
            insert lnsertLeavePlan;
            lnsertLeavePlan.clear();
        }
        
        lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__C =: CurrUserId AND End_Date__c >=: date.today()];
       
        EditableLeave= false;
        ReadOnlyLeave = true;
        
        return null;
    }
    
    public pagereference SaveFollowup()
    {
        List<Consultation_Follow_up__c> updateFollowup = new List<Consultation_Follow_up__c>();
      
        for(Consultation_Follow_up__c cf: lstFollowUpObj)
        {
            if(cf.id == followupId)
            {
                if(Approved)
                {
                    cf.Status__c = 'Confirmed';
                    Approved = false;
                    cf.Confirmation_Status__c = 'Confirmed by advisor';
                    //update cf;
                    //followupId = null;
                }
                
                if(Rescheduled)
                {
                    cf.Status__c = 'Rescheduled by Advisor';
                    
                    if(cf.MeetingTime__c == '08 AM - 09 AM')
                        cf.Meeting_Time__c =  '8';
                    
                    if(cf.MeetingTime__c == '09 AM - 10 AM')
                        cf.Meeting_Time__c =  '9';
                    
                    if(cf.MeetingTime__c == '10 AM - 11 AM')
                        cf.Meeting_Time__c =  '10';
                    
                    if(cf.MeetingTime__c == '11 AM - 12 PM')
                        cf.Meeting_Time__c =  '11';
                        
                    if(cf.MeetingTime__c == '12 PM - 01 PM')
                        cf.Meeting_Time__c =  '12';
                    
                    if(cf.MeetingTime__c == '01 PM - 02 PM')
                        cf.Meeting_Time__c =  '13';
                    
                    if(cf.MeetingTime__c == '02 PM - 03 PM')
                        cf.Meeting_Time__c =  '14';
                    
                    if(cf.MeetingTime__c == '03 PM - 04 PM')
                        cf.Meeting_Time__c =  '15';
                    
                    if(cf.MeetingTime__c == '04 PM - 05 PM')
                        cf.Meeting_Time__c =  '16';
                    
                    if(cf.MeetingTime__c == '05 PM - 06 PM')
                        cf.Meeting_Time__c =  '17';
                        
                    if(cf.MeetingTime__c == '06 PM - 07 PM')
                        cf.Meeting_Time__c =  '18';
                    
                    if(cf.MeetingTime__c == '07 PM - 08 PM')
                        cf.Meeting_Time__c =  '19';
                         
                    Rescheduled = false;
                    
                    //update cf;
                    //followupId = null;
                }
                
                if(Rejected)
                {
                    cf.Status__c = 'Rejected';
                    Rejected = false;
                    //cf.Confirmation_Status__c = 'Confirmed by advisor';
                }
                
                updateFollowup.add(cf);
            }
        }
        
        if(updateFollowup.size()>0)
        {
           update updateFollowup; 
           updateFollowup.clear();
           followupId = null;
        }
        
        lstFollowUpObj = [select id, Consultation__r.Contact_Consultation__r.Name, Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c, Meeting_Time__c, Location__c,Advisor__c, Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName];
        
        EditableFollowup = true;
        
        return null;
    }
    
//SAVE END ***********************************************************
    
    
//EDIT START *********************************************************
    public void EditUser()
    {
        EditableUser = true;
        ReadOnlyUser = false;
    }
    
    public void EditLeave()
    {
        EditableLeave= true;
        ReadOnlyLeave = false;
    }
    
    public void ApprovedFollowup()
    {
        Approved = true;
        Rescheduled = false;
        Rejected = false;
        SaveFollowup();
    }
    
    public void ConfirmedCustomer()
    {
        ConfirmfrmClient = true;
        lstFollowUpObj[0].Status__c = 'Confirmed';
        update lstFollowUpObj;
    }
    public void ReschdueldFollowup()
    {
        Rescheduled = true;
        Approved = false;
        Rejected = false;
        EditableFollowup = true;
        ReadOnlyFollowup = false;
    }
    
    public void RejectFollowup()
    {
        Rejected = true;
        Approved = false;
        Rescheduled = false;
        SaveFollowup();
    }

//END EDIT **************************************************************************** 
    
    
//START DELETE ************************************************************************ 
    public pagereference DeleteLeave()
    {
        System.debug('--vks-- '+ leaveId);
        if(leaveId != null && leaveId != '')
        {
            Leave_Plan__c DelLeave = [select id from Leave_Plan__c where id = :leaveId limit 1];
            if(DelLeave != null)
            delete DelLeave;
            
            lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__c =: CurrUserId AND End_Date__c >=: date.today()];
            leaveId = null;
        }
        return null;
    }
//END DELETE ************************************************************************** 
    
//START CENCEL ************************************************************************
    public pagereference CancelWorkingHrs()
    {
        LstLoggedUser = [select Id, Name, DayStartTime__c, DayEndTime__c, Start_of_day__c, End_of_day__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Location__c FROM User where Id=:CurrUserId limit 1];
        UserId = null;
        
        return null;
    }
    
    public pagereference CancelLeave()
    {
        lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__c =: CurrUserId AND End_Date__c >=: date.today()];
        leaveId = null;
        
        return null;
    }
    
     public pagereference CancelFollowUp()
    {
        lstFollowUpObj = [select id, Consultation__r.Name, Meeting_Date__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Meeting_Time__c, Location__c,Advisor__c,Status__c from Consultation_Follow_up__c where Advisor__c=: LoggedUserName];
        followupId = null;
        Rescheduled = false;
        return null;
    }
    
//END CENCEL ************************************************************************
}