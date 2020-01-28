public class OnlineConsultationMeetingSchCompCtrl
{ 
    public String LocationSelected {get;set;}
    public String AdvisorSelected {get;set;}
    public String DateSelected {get;set;}
    public String TimeSelected {get;set;}
    
    public boolean AvailableAdvisorsDisable {get;set;}
    public boolean AvailableTimeDisable {get;set;}
    public boolean AvailableDateDisable {get;set;}
    
    
    public boolean noDateSlotAvailable {get;set;}
    public boolean noTimeSlotAvailable {get;set;}
    public Set<Date> WorkingDates;
    public String InteractionRecId {get;set;}
    
    
    public List<SelectOption> LocationOptions = New List<SelectOption>();
    public List<SelectOption> AdvisorOptions = New List<SelectOption>();
    public List<SelectOption> TimeOptions = New List<SelectOption>();
    public List<SelectOption> DateOptions = New List<SelectOption>();

    public List<SelectOption> AvailableLocations { get{ return LocationOptions;} set{ value = LocationOptions;} }
    public List<SelectOption> AvailableAdvisors { get{ return AdvisorOptions;} set{ value = AdvisorOptions;} }
    public List<SelectOption> AvailableTimeSlots { get{ return TimeOptions;} set{ value = TimeOptions;} }
    public List<SelectOption> AvailableDateSlots { get{ return DateOptions;} set{ value = DateOptions;} }
    
    public PageReference PG;
    
    public OnlineConsultationMeetingSchCompCtrl()
    {
        AvailableLocations();
        DateOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AdvisorOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        
        AvailableDateDisable = true;
        AvailableAdvisorsDisable = true;
        AvailableTimeDisable = true;
        
        noDateSlotAvailable = false;
        noTimeSlotAvailable = false;
        
        WorkingDates = new Set<Date>();
    }
    
    public PageReference AvailableLocations()
    {
        
        List<SelectOption> options = new List<SelectOption>();
        noDateSlotAvailable = false;
        noTimeSlotAvailable = false;
        LocationOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
         //Below Logic to dynamicall only send the Location value in picklist that are availabale as record on Custom Calendar Object
        Set<String> validLocation = new Set<String>();
        for(Custom_Calendar__c cCal: [SELECT Id, Calendar_Date__c, Location__c, On_Leave__c, User__c FROM Custom_Calendar__c WHERE Calendar_Date__c >= TODAY AND On_Leave__c = False]){ 
            validLocation.add(cCal.Location__c);
        }
        for(String locKey : validLocation)
        LocationOptions.add(new SelectOption(locKey, locKey));
        system.debug('LocationOptions+++'+LocationOptions);
        return null;
    }
    
    public void AvailableAdvisors()
    {
        System.debug('AdvisorOptions++'+AdvisorOptions);  
        AdvisorSelected='';
        AdvisorOptions.clear();
        AdvisorOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableAdvisorsDisable = true;
        DateOptions.clear();
        DateOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableDateDisable = true;
        TimeOptions.clear();
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableTimeDisable = true;
        
        noDateSlotAvailable = false;
        noTimeSlotAvailable = false;
        
        List<User> userList = [Select Id, Name From User Where Consultation_Location__c includes (:LocationSelected) AND Consultation_Location__c !=''];
        if(userList.size()>0){
            for(User u : userList){
                AdvisorOptions.add(new SelectOption(u.id, u.name));
            }
        }   
        if(AdvisorOptions.size()>1)
        {
            AvailableAdvisorsDisable = false;
        }
    }
    
    public void AvailableDays()
    {    
        DateSelected = '';
        System.debug('DateOptions++'+DateOptions); 
        DateOptions.clear();
        DateOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableDateDisable = true;
        
        TimeOptions.clear();
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableTimeDisable = true;
        
        WorkingDates = New Set<Date>();
        for(Custom_Calendar__c cCal: [select Id, Availability_End_Time__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, AvailabilityStartTimeFormula__c, Calendar_Date__c, Location__c, On_Leave__c, User__c From Custom_Calendar__c Where User__c =: AdvisorSelected AND On_Leave__c = False AND Location__c =:LocationSelected AND Calendar_Date__c > TODAY Order by Calendar_Date__c asc]) {
            WorkingDates.add(cCal.Calendar_Date__c);
        }
        noDateSlotAvailable = false;
        noTimeSlotAvailable = false;
        system.debug('WorkingDates++'+WorkingDates.size());
        if(WorkingDates.size()==0 && AdvisorSelected !='-SELECT-'){
            noDateSlotAvailable =true;
        }
          
        if(WorkingDates.size()>0)
        {
            integer k = 1;
            For(Date dt : WorkingDates)
            {
                DateTime todayDateTime = dt;
                DateOptions.add(new SelectOption(dt.Day() + '-' + dt.Month() + '-' + dt.Year(),todayDateTime.format('EEEE MMMM dd, YYYY')));
                ++k;
            }
        }
        if(DateOptions.size()>1)
        AvailableDateDisable = false;
        
    }
    
    public void AvailableTimeSlots()
    {
        TimeSelected ='';
        TimeOptions.clear();
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableTimeDisable = true;
        Set<Integer> FLSet = New Set<Integer>();
        String evStartTime, evEndTime; 
        Integer WStartTime, WEndTime;
        List<Integer> WStartTimeList = new List<Integer> ();
        List<Integer> WEndTimeList = new List<Integer> ();
        noDateSlotAvailable = false;
        noTimeSlotAvailable = false;
        
        system.debug('DateSelected+++'+DateSelected);
        Date dt;
        if(DateSelected!='-SELECT-' && DateSelected!=null && DateSelected!=''){
        system.debug('DateSelectedInside+++'+DateSelected);
            dt = Date.newInstance(Integer.Valueof(DateSelected.split('-')[2]), Integer.Valueof(DateSelected.split('-')[1]), Integer.Valueof(DateSelected.split('-')[0]));
            List<Interaction__c> lstInteracObj = [Select Id,Meeting_Time__c, MeetingTime__c,Meeting_Date__c,Advisor_Lookup__c,Advisor__c,Location__c, Meeting_Status__c From Interaction__c Where Advisor_Lookup__c=: AdvisorSelected and Meeting_date__c=:dt];
            
            if(lstInteracObj.size() > 0){
                for(Interaction__c intr : lstInteracObj){
                    if(intr.Meeting_Status__c != 'Rejected' && intr.Meeting_Status__c != 'Cancelled by Advisor' && intr.Meeting_Status__c != 'Cancelled by Client')
                        FLSet.add(Integer.ValueOf(intr.Meeting_Time__c));
                }
            }
            for(Custom_Calendar__c cCal: [select Id, Availability_End_Time__c, AvailabilityEndTimeFormula__c, Availability_Start_Time__c, AvailabilityStartTimeFormula__c, Calendar_Date__c, Location__c, On_Leave__c, User__c From Custom_Calendar__c Where User__c =: AdvisorSelected AND On_Leave__c = False AND Calendar_Date__c =:dt AND Location__c =: LocationSelected]) {   
                System.debug('-cCal-'+ cCal);
                WStartTime = Integer.ValueOf(cCal.AvailabilityStartTimeFormula__c);
                WEndTime = Integer.ValueOf(cCal.AvailabilityEndTimeFormula__c);
                WStartTimeList.add(WStartTime);
                WEndTimeList.add(WEndTime);
            }
        }
        
        List<Event> lstExistingEvent = [SELECT Id, OwnerId, ActivityDate, StartDateTime, EndDateTime FROM Event WHERE OwnerId =: AdvisorSelected AND ActivityDate=:dt];
        Set<Integer> iSet = New Set<Integer>();
        System.debug('-lstExistingEvent-'+ lstExistingEvent);
        if(lstExistingEvent.size() > 0){
            for(Event ev : lstExistingEvent){
                String startTimeMinute;
                String endTimeMinute;
                if(String.valueOf(ev.StartDateTime.minute())=='0'){
                    startTimeMinute ='00';
                }
                else{
                    startTimeMinute = String.valueOf(ev.StartDateTime.minute());
                }
                if(String.valueOf(ev.EndDateTime.minute())=='0'){
                    endTimeMinute='00';
                }
                else{
                    endTimeMinute =String.valueOf(ev.EndDateTime.minute());
                }
                
                evStartTime = String.valueOf(ev.StartDateTime.hour()-4)+startTimeMinute;
                evEndTime =  String.valueOf(ev.EndDateTime.hour()-4)+endTimeMinute;
                System.debug('-evStartTime-'+ evStartTime);             
                System.debug('-evEndTime-'+ evEndTime);             
                for(Integer i=Integer.valueOf(evStartTime); i< Integer.valueOf(evEndTime);){
                    System.debug('-i-'+i);
                    iSet.add(i);
                    
                    if(String.valueOf(i).right(2)=='00'){
                    i = i+30;
                    }
                    else if(Integer.valueof(String.valueOf(i).right(2))>30 || Integer.valueof(String.valueOf(i).right(2))==30){
                        i= i+(100-Integer.valueof(String.valueOf(i).right(2)));
                    }
                    else if(Integer.valueof(String.valueOf(i).right(2))<30 && String.valueOf(i).right(2)!='00'){
                        i= i-Integer.valueof(String.valueOf(i).right(2));
                    }
                }
            }         
            System.debug('-VKS3iSet-'+ iSet);
            for(Integer j=0; j < WEndTimeList.size(); j++){ 
                for(Integer i=WStartTimeList[j]; i< WEndTimeList[j];){
                    if(i!=null && !iSet.contains(i) && !FLSet.contains(i)){
                         TimeOptions.add(new SelectOption(String.ValueOf(i), SetAmPm(i)));
                    }   
                    if(String.valueOf(i).right(2)=='30'){
                    
                    i = i+70;
                    }
                    else{
                        i= i+30;
                    }
                }
            }   
        }
        else{
            for(Integer j=0; j < WEndTimeList.size(); j++){
                for(Integer i=WStartTimeList[j]; i< WEndTimeList[j];){
                system.debug('+++IValue++'+i);
                if(!FLSet.contains(i)){
                    TimeOptions.add(new SelectOption( String.ValueOf(i), SetAmPm(i)));
                }   
                    if(String.valueOf(i).right(2)=='30'){
                    i = i+70;
                    }
                    else{
                        i= i+30;
                    }
                }
            }
        }   
        System.debug('-VKS3FLSet-'+ FLSet);
        System.debug('-VKS3-'+ TimeOptions);
        if(TimeOptions.size()>1)
            AvailableTimeDisable = false;
        if((TimeOptions.size()<1 || TimeOptions.size()==1) && DateSelected !='-SELECT-'){
            noTimeSlotAvailable = true;
        }
        System.debug('-noTimeSlotAvailable-'+ noTimeSlotAvailable);
    }
    
    public String SetAmPm(integer t)
    {
        String tm;
        String formatedTM;
        if(t==1200)
            tm = '12 00 PM - 12 30 PM';
        else if(t==1230)
            tm = '12 30 PM - 01 00 PM';    
        else if(t==1300)
            tm = '01 00 PM - 01 30 PM';    
        else if(t==1330)
            tm = '01 30 PM - 02 00 PM';    
        else if(t==1400)
            tm = '02 00 PM - 02 30 PM';    
        else if(t==1430)
            tm = '02 30 PM - 03 00 PM';    
        else if(t==1500)
            tm = '03 00 PM - 03 30 PM';    
        else if(t==1530)
            tm = '03 30 PM - 04 00 PM';    
        else if(t==1600)
            tm = '04 00 PM - 04 30 PM';    
        else if(t==1630)
            tm = '04 30 PM - 05 00 PM';    
        else if(t==1700)
            tm = '05 00 PM - 05 30 PM';    
        else if(t==1730)
            tm = '05 30 PM - 06 00 PM';    
        else if(t==1100)
            tm = '11 00 AM - 11 30 AM';    
        else if(t==1130)
            tm = '11 30 AM - 12 00 PM';    
        else if(t==1000)
            tm = '10 00 AM - 10 30 AM';    
        else if(t==1030)
            tm = '10 30 AM - 11 00 AM';    
        else if(t==900)
            tm = '09 00 AM - 09 30 AM';    
        else if(t==930)
            tm = '09 30 AM - 10 00 AM';    
        else if(t==800)
            tm = '08 00 AM - 08 30 AM';    
        else if(t==830)
            tm = '08 30 AM - 09 00 AM';    
        
        return tm;
    }
    
    public PageReference scheduleMeeting()
    {
        System.debug('## VKS - ' + PG);
        System.debug('$$ VKS - ' + InteractionRecId);
        
        if(InteractionRecId!= null && InteractionRecId!= '')
        {
            Interaction__c inter = [SELECT Id,Location__c,Advisor__c  FROM Interaction__c WHERE ID = :InteractionRecId AND ((Meeting_Status__c=null and Location__c =null and Meeting_Time__c = null and Advisor_Lookup__c=null) OR (Meeting_Status__c= 'Cancelled by Advisor' OR Meeting_Status__c= 'Cancelled by Client'))];
            inter.Meeting_Time__c = TimeSelected;
            inter.MeetingTime__c = SetAmPm(Integer.valueOf(TimeSelected));
            inter.Meeting_Date__c = Date.newInstance(Integer.Valueof(DateSelected.split('-')[2]), Integer.Valueof(DateSelected.split('-')[1]), Integer.Valueof(DateSelected.split('-')[0]));
            inter.Advisor__c = [Select Id, Name From User Where id =: AdvisorSelected limit 1].Name;
            inter.Advisor_Lookup__c = AdvisorSelected;
            inter.Location__c = LocationSelected;
            inter.Meeting_Status__c ='Requested';
            
            update inter;
            
            PG = new PageReference(System.Label.ForcecomSite+'/OnlineConsultationMeetingScheduler?FollowRecId='+inter.Id);
        }
        PG.setRedirect(true);
        
        InteractionRecId= '';
        return PG;
    }  
}