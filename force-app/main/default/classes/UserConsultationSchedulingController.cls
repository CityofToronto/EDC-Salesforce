public class UserConsultationSchedulingController
{
    public String selectStartTime{get;set;}
    public String selectEndTime{get;set;}
    public String leaveId{get;set;}
    public String calendarRecId{get;set;}
    public String userId{get;set;}
    public String followupId{get;set;}
    public List<Custom_Calendar__c> LstLoggedUser {get;set;}
    public List<Leave_Plan__c> lstLeaveplan{get;set;}
    public List<Interaction__c> lstFollowUpObj{get;set;}
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
    public boolean CancelledConsultation {get;set;}
    public String LoggedUserName {get;set;}
    public String Confirm{get;set;}
    private Id CurrUserId;
    public boolean ConfirmfrmClient;
     
    public UserConsultationSchedulingController(){  
        CurrUserId = UserInfo.getUserId(); 
        LoggedUserName = UserInfo.getName();
        selectedMeetingView = 'ALL';
        
        LstLoggedUser = [select Id, Calendar_Date__c, AvailabilityStartTimeFormula__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, Availability_End_Time__c, Location__c FROM Custom_Calendar__c where User__c=:CurrUserId AND Calendar_Date__c >=: date.today() ORDER BY Calendar_Date__c asc];
        lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__C =: CurrUserId AND End_Date__c >=: date.today() ORDER BY Start_Date__c asc];
        lstFollowUpObj = [select id, Contact__r.Name,Name, Meeting_Date__c,MeetingTime__c,Advisor__c,Advisor_Lookup__c,Meeting_Time__c, Location__c, Meeting_Status__c, Reason_for_Cancellation__c, Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND Meeting_Status__c!=null order by Meeting_Date__c ASC];
    }
    
    public pagereference AddLine(){
        boolean AddRow = true;
        
        system.debug('+++lstLeaveplan'+lstLeaveplan);
        for(Leave_Plan__c s: lstLeaveplan)
        {
            if(s.id == null)
            AddRow = false;
        system.debug('+++AddRowInside'+AddRow);
        }
        system.debug('+++AddRow'+AddRow);
        if(AddRow)
            lstLeaveplan.add(new Leave_Plan__c());

        return null;   
    }
    public pagereference AddCalendarLine(){
        boolean AddCalendarRow = true;
        ReadOnlyUser = true;
        for(Custom_Calendar__c cc: LstLoggedUser)
        {
            if(cc.id == null)
            AddCalendarRow = false;
        }
        system.debug('+++AddRow'+AddCalendarRow);
        if(AddCalendarRow)
            LstLoggedUser.add(new Custom_Calendar__c());

        return null;   
    }
    public void OnChangeMeetingView(){
    if (selectedMeetingView == 'ALL')
          lstFollowUpObj = [select id, Contact__r.Name,Name, Meeting_Date__c,MeetingTime__c,Advisor__c, Meeting_Time__c, Location__c, Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND ((Meeting_Status__c!=null AND Meeting_Date__c >=: date.today()) OR (Meeting_Date__c <: date.today() AND Meeting_Status__c != 'Requested' AND Meeting_Status__c != '')) order by Meeting_Date__c ASC];          
        else if (selectedMeetingView == 'RP')
          lstFollowUpObj = [select id, Contact__r.Name,Name, Meeting_Date__c,MeetingTime__c,Advisor__c,Advisor_Lookup__c, Meeting_Time__c, Location__c, Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND Meeting_Status__c = 'Requested' AND Meeting_Date__c >=:  date.today() order by Meeting_Date__c ASC];
        else if (selectedMeetingView == 'CC')
          lstFollowUpObj = [select id, Contact__r.Name,Name, Meeting_Date__c,MeetingTime__c,Advisor__c,Advisor_Lookup__c, Meeting_Time__c, Location__c, Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND (Meeting_Status__c = 'Confirmed' OR Meeting_Status__c = 'Completed') AND Meeting_Date__c <: date.today() order by Meeting_Date__c ASC];
        else if (selectedMeetingView == 'CU')
          lstFollowUpObj = [select id, Contact__r.Name,Name, Meeting_Date__c,MeetingTime__c,Advisor__c,Advisor_Lookup__c, Meeting_Time__c, Location__c,Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND Meeting_Status__c = 'Confirmed' AND Meeting_Date__c >=: date.today() order by Meeting_Date__c ASC];
        else if (selectedMeetingView == 'REJ')
          lstFollowUpObj = [select id,Contact__r.Name,Name, Meeting_Date__c,MeetingTime__c,Advisor__c, Advisor_Lookup__c, Meeting_Time__c, Location__c, Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND (Meeting_Status__c = 'Rejected' OR Meeting_Status__c = 'Cancelled by Advisor' OR Meeting_Status__c = 'Cancelled by Client') order by Meeting_Date__c ASC];
    }
    
//SAVE START *************************************************************

    public pagereference SaveWorkingHour(){
        List<Custom_Calendar__c> insertCalendarRec = new List<Custom_Calendar__c>();
        List<Custom_Calendar__c> updateCalendarRec = new List<Custom_Calendar__c>();
        Map<String,Integer> dateTimeMap= new Map<String,Integer>();
        dateTimeMap.put('08 00 AM',800);
        dateTimeMap.put('08 30 AM',830);
        dateTimeMap.put('09 00 AM',900);
        dateTimeMap.put('09 30 AM',930);
        dateTimeMap.put('10 00 AM',1000);
        dateTimeMap.put('10 30 AM',1030);
        dateTimeMap.put('11 00 AM',1100);
        dateTimeMap.put('11 30 AM',1130);
        dateTimeMap.put('12 00 PM',1200);
        dateTimeMap.put('12 30 PM',1230);
        dateTimeMap.put('01 00 PM',1300);
        dateTimeMap.put('01 30 PM',1330);
        dateTimeMap.put('02 00 PM',1400);
        dateTimeMap.put('02 30 PM',1430);
        dateTimeMap.put('03 00 PM',1500);
        dateTimeMap.put('03 30 PM',1530);
        dateTimeMap.put('04 00 PM',1600);
        dateTimeMap.put('04 30 PM',1630);
        dateTimeMap.put('05 00 PM',1700);
        dateTimeMap.put('05 30 PM',1730);
        dateTimeMap.put('06 00 PM',1800);
        List<Custom_Calendar__c> calendarRecList = new List<Custom_Calendar__c>([select Id, Calendar_Date__c, AvailabilityStartTimeFormula__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, Availability_End_Time__c, Location__c FROM Custom_Calendar__c where User__c=:CurrUserId ORDER BY Calendar_Date__c asc]); 
        Set<Date> leaveDateSet = new Set<Date>();
        for(Leave_Plan__c lp: [SELECT Id, User__c,Start_Date__c,End_Date__c FROM Leave_Plan__c WHERE User__c =:CurrUserId]){
            if(lp.Start_Date__c<lp.End_Date__c){
              Date tempDate = lp.Start_Date__c;
              for(integer i=0;tempDate<=lp.End_Date__c;i++){
                  leaveDateSet.add(tempDate);
                  tempDate = tempDate.addDays(1); 
              }
            }
            else{
            leaveDateSet.add(lp.Start_Date__c);
            //dateSet.add(lp.End_Date__c);     
            } 
        }
        system.debug('++calendarRecList'+calendarRecList);
        Map<Date, List<Custom_Calendar__c>> ccDateMap = new  Map<Date, List<Custom_Calendar__c>>();
        for(Custom_Calendar__c ccRec: calendarRecList){
            if(!ccDateMap.containsKey(ccRec.Calendar_Date__c)){
            ccDateMap.put(ccRec.Calendar_Date__c, new List<Custom_Calendar__c >{ccRec});
            
            }else{
                ccDateMap.get(ccRec.Calendar_Date__c).add(ccRec);
            }
        }
        for(Custom_Calendar__c cc: LstLoggedUser){
            
            if(cc.id == null){
                if(ccDateMap!=null && ccDateMap.containsKey(cc.Calendar_Date__c)){
                    for(Custom_Calendar__c ccOld : ccDateMap.get(cc.Calendar_Date__c)){
                            system.debug('VKS__4 '+ cc.id);
                            system.debug('VKS__4 '+ cc); 
                        if(cc.Calendar_Date__c== ccOld.Calendar_Date__c && ((dateTimeMap.get(cc.Availability_Start_Time__c) >integer.valueof(ccOld.AvailabilityStartTimeFormula__c) && dateTimeMap.get(cc.Availability_Start_Time__c) < integer.valueof(ccOld.AvailabilityEndTimeFormula__c)) || (dateTimeMap.get(cc.Availability_Start_Time__c)< integer.valueof(ccOld.AvailabilityStartTimeFormula__c) && dateTimeMap.get(cc.Availability_End_Time__c) > integer.valueof(ccOld.AvailabilityStartTimeFormula__c)) || (dateTimeMap.get(cc.Availability_End_Time__c)> integer.valueof(ccOld.AvailabilityStartTimeFormula__c) && dateTimeMap.get(cc.Availability_End_Time__c) < integer.valueof(ccOld.AvailabilityEndTimeFormula__c)) || dateTimeMap.get(cc.Availability_Start_Time__c)==integer.valueof(ccOld.AvailabilityStartTimeFormula__c) || dateTimeMap.get(cc.Availability_End_Time__c)==integer.valueof(ccOld.AvailabilityEndTimeFormula__c))){
                            system.debug(' ********* ');
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Duplicate Consultation slot not allowed for same date. Please provide valid Working Hours in order to save it.'));
                            return null;
                        }
                        
                    }       
                }
                if(leaveDateSet!=null && leaveDateSet.contains(cc.Calendar_Date__c)){
                    system.debug(' ********* ');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'You have a leave planned for this date.Please specify valid Consultation date.'));
                    return null;
                
                }
                
                if(cc.Calendar_Date__c != null && cc.Availability_Start_Time__c!= null && cc.Availability_End_Time__c!=null && cc.Location__c!=null && dateTimeMap.get(cc.Availability_End_Time__c)>dateTimeMap.get(cc.Availability_Start_Time__c) && (cc.Calendar_Date__c == Date.today() || cc.Calendar_Date__c > Date.today())){
                    system.debug('VKS__3 '+ cc.id);
                    cc.User__c = CurrUserId;
                    insertCalendarRec.add(cc);
                }
                else{
                    system.debug(' ********* ');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid and complete information for Working Hours in order to save it.'));
                    return null;
                }
            }else{
                system.debug('inside else++'+calendarRecId);
                system.debug('inside else++ccid'+cc.id);
                if(calendarRecId != null && calendarRecId != '' && cc.id == calendarRecId){
                    if(ccDateMap!=null && ccDateMap.containsKey(cc.Calendar_Date__c)){
                        for(Custom_Calendar__c ccOld : ccDateMap.get(cc.Calendar_Date__c)){
                            
                            if(cc.id != ccOld.Id && cc.Calendar_Date__c== ccOld.Calendar_Date__c && ((dateTimeMap.get(cc.Availability_Start_Time__c) >integer.valueof(ccOld.AvailabilityStartTimeFormula__c) && dateTimeMap.get(cc.Availability_Start_Time__c) < integer.valueof(ccOld.AvailabilityEndTimeFormula__c))|| (dateTimeMap.get(cc.Availability_Start_Time__c)< integer.valueof(ccOld.AvailabilityStartTimeFormula__c) && dateTimeMap.get(cc.Availability_End_Time__c) > integer.valueof(ccOld.AvailabilityStartTimeFormula__c)) || (dateTimeMap.get(cc.Availability_End_Time__c)> integer.valueof(ccOld.AvailabilityStartTimeFormula__c) && dateTimeMap.get(cc.Availability_End_Time__c) < integer.valueof(ccOld.AvailabilityEndTimeFormula__c))|| dateTimeMap.get(cc.Availability_Start_Time__c)==integer.valueof(ccOld.AvailabilityStartTimeFormula__c) || dateTimeMap.get(cc.Availability_End_Time__c)==integer.valueof(ccOld.AvailabilityEndTimeFormula__c))){
                                system.debug(' ********* ');
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Duplicate Consultation slot not allowed for same date. Please provide valid Working Hours in order to save it.'));
                                return null;
                            }
                        }
                    }   
                    if(cc.Calendar_Date__c != null && cc.Availability_Start_Time__c!= null && cc.Availability_End_Time__c!=null && cc.Location__c!=null && (cc.Calendar_Date__c == Date.today() || cc.Calendar_Date__c > Date.today()) && dateTimeMap.get(cc.Availability_End_Time__c)>dateTimeMap.get(cc.Availability_Start_Time__c)) {
                        updateCalendarRec.add(cc);
                    }
                    else {
                        system.debug(' ********* ');
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid and complete information for Working Hours in order to save it.'));
                        return null;
                    }
                }                                                                                          
            }
        }
        if(updateCalendarRec .size()>0)
        {
            update updateCalendarRec ; 
            updateCalendarRec .clear();
            calendarRecId = null;
        }
        
        if(insertCalendarRec.size()>0)
        {
            insert insertCalendarRec;
            insertCalendarRec.clear();
        }
        
        LstLoggedUser = [select Id, Calendar_Date__c, AvailabilityStartTimeFormula__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, Availability_End_Time__c, Location__c FROM Custom_Calendar__c where User__c=:CurrUserId AND Calendar_Date__c >=: date.today() ORDER BY Calendar_Date__c asc];
       
        EditableUser= false;
        ReadOnlyUser = true;
        
        return null;
    }
    
    public pagereference SaveLeave(){
        List<Leave_Plan__c> lnsertLeavePlan = new List<Leave_Plan__c>();
        List<Leave_Plan__c> updateLeavePlan = new List<Leave_Plan__c>();
      
        system.debug('VKS__1 '+ lstLeaveplan);
         
        for(Leave_Plan__c lp: lstLeaveplan)
        {
            if(lp.id == null)
            {
                system.debug('VKS__2 '+ lp.id);
                system.debug('VKS__2 '+ lp); 
                
                if(lp.Start_Date__c != null && lp.End_Date__c!= null && (lp.Start_Date__c < Date.today() || lp.End_Date__c < Date.today())){
                    system.debug(' ********* ');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid Date. Start Date/End Date in past are not allowed.'));
                    return null;
                }
                else if(lp.Start_Date__c != null && lp.End_Date__c!= null && lp.Start_Time__c != null && lp.End_Time__c!=null && lp.Start_Date__c<= lp.End_Date__c){
                    system.debug('VKS__3 '+ lp.id);
                    lp.User__c = CurrUserId;
                    lnsertLeavePlan.add(lp);
                }
                else
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid and complete information for leave plan in order to save it.'));
                    return null;
                }
            
            }
            
            if(leaveId != null && leaveId != '' && lp.id == leaveId)
            {
                if(lp.Start_Date__c != null && lp.End_Date__c!= null && lp.End_Date__c < Date.today()){
                    system.debug(' ********* ');
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please provide valid Date. End Date in past not allowed.'));
                    return null;
                }
                
                else if(lp.Start_Date__c != null && lp.End_Date__c!= null && lp.Start_Time__c != null && lp.End_Time__c!=null && lp.Start_Date__c <= lp.End_Date__c){
                    updateLeavePlan .add(lp);
                }
                else
                {
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
        
        lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__C =: CurrUserId AND End_Date__c >=: date.today() ORDER BY Start_Date__c asc];
       
        EditableLeave= false;
        ReadOnlyLeave = true;
        
        return null;
    }
    
    public pagereference SaveFollowup(){
        List<Interaction__c> updateFollowup = new List<Interaction__c>();
      
        for(Interaction__c cf: lstFollowUpObj)
        {
            if(cf.id == followupId)
            {
                if(Approved)
                {
                    cf.Meeting_Status__c = 'Confirmed';
                    Approved = false;
                  
                }
                if(Rejected)
                {
                    cf.Meeting_Status__c = 'Rejected';
                    Rejected = false;
                }
                if(CancelledConsultation)
                {
                    cf.Meeting_Status__c = 'Cancelled by Advisor';
                    CancelledConsultation = false;
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
        
        lstFollowUpObj = [select id, Contact__r.Name, Name, Meeting_Date__c,MeetingTime__c, Meeting_Time__c, Location__c,Advisor__c, Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND Meeting_Status__c!=null order by Meeting_Date__c ASC];
        
        EditableFollowup = true;
        
        return null;
    }
    
//SAVE END ***********************************************************
    
    
//EDIT START *********************************************************
    public void EditUser(){
        EditableUser = true;
        ReadOnlyUser = false;
    }
    public void EditLeave(){
        EditableLeave= true;
        ReadOnlyLeave = false;
    }
    public void ApprovedFollowup(){
        EditableUser = true;
        Approved = true;
        Rescheduled = false;
        CancelledConsultation = false;
        Rejected = false;
    }
    
    public void ConfirmedCustomer(){
        ConfirmfrmClient = true;
        lstFollowUpObj[0].Meeting_Status__c = 'Confirmed';
        update lstFollowUpObj;
    }
    /*
    public void ReschdueldFollowup(){
        Rescheduled = true;
        CancelledConsultation = false;
        Approved = false;
        Rejected = false;
        EditableFollowup = true;
        ReadOnlyFollowup = false;
    }
    */
    public void RejectFollowup(){
        Rejected = true;
        CancelledConsultation = false;
        Approved = false;
        Rescheduled = false;
    }
    public void CancelledConsultationFollowup(){
        CancelledConsultation =true;
        Rejected = false;
        Approved = false;
        Rescheduled = false;
    }

//END EDIT **************************************************************************** 
    
    
//START DELETE ************************************************************************ 
    public pagereference DeleteLeave(){
        System.debug('--vks-- '+ leaveId);
        if(leaveId != null && leaveId != '')
        {
            Leave_Plan__c DelLeave = [select id from Leave_Plan__c where id = :leaveId limit 1];
            if(DelLeave != null)
            delete DelLeave;
            
            lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__c =: CurrUserId AND End_Date__c >=: date.today() ORDER BY Start_Date__c asc];
            leaveId = null;
        }
        return null;
    }
    public pagereference DeleteCalendarRow(){
        System.debug('--vks-- '+ calendarRecId);
        if(calendarRecId != null && calendarRecId != '')
        {
            Custom_Calendar__c delCalendar = [Select Id from Custom_Calendar__c where id = :calendarRecId limit 1];
            if(delCalendar != null)
            delete delCalendar;
            
            LstLoggedUser = [select Id, Calendar_Date__c, AvailabilityStartTimeFormula__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, Availability_End_Time__c, Location__c FROM Custom_Calendar__c where User__c=:CurrUserId AND Calendar_Date__c >=: date.today() ORDER BY Calendar_Date__c asc];
            calendarRecId = null;
        }
        return null;
    }
//END DELETE ************************************************************************** 
    
//START CENCEL ************************************************************************
    public pagereference CancelWorkingHrs(){
        LstLoggedUser = [select Id, Calendar_Date__c, AvailabilityStartTimeFormula__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, Availability_End_Time__c, Location__c FROM Custom_Calendar__c where User__c=:CurrUserId AND Calendar_Date__c >=: date.today() ORDER BY Calendar_Date__c asc];
        calendarRecId = null;
        ReadOnlyUser = false;
        return null;
    }
    
    public pagereference CancelLeave(){
        lstLeaveplan = [select id, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__c =: CurrUserId AND End_Date__c >=: date.today() ORDER BY Start_Date__c asc];
        leaveId = null;
        return null;
    }
    
     public pagereference CancelFollowUp(){
        lstFollowUpObj = [select id, Contact__r.Name, Name, Meeting_Date__c,MeetingTime__c, Meeting_Time__c, Location__c,Advisor__c, Meeting_Status__c,Reason_for_Cancellation__c,Advisor_Comments__c from Interaction__c where Advisor_Lookup__c=: CurrUserId AND Meeting_Status__c!=null order by Meeting_Date__c ASC];
        followupId = null;
        Rescheduled = false;
        Rejected = false;
        Approved = false;
        CancelledConsultation = false;
        return null;
    }
    
//END CENCEL ************************************************************************
}