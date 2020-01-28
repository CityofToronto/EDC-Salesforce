public class ScheduleMeetingCompCtrl
{ 
    public string NoOfMonths {get;set;}
    public string StartDateFrom {get;set;}
    public string StartDateTo {get;set;}
    
    public String LocationSelected {get;set;}
    public String AdvisorSelected {get;set;}
    public String DateSelected {get;set;}
    public String TimeSelected {get;set;}
    
    public String StartYear {get;set;}
    public String StartMonth {get;set;}
    public String StartDay {get;set;}
    
    public boolean AvailableAdvisorsDisable {get;set;}
    public boolean AvailableTimeDisable {get;set;}
    
    public Boolean AlreadyScheduled {get; set;}
    public String AdvisorsWokringDays {get; set;}
    public String disableddates {get;set;}
    
    public String FollowUpEmail {get;set;}
    public String FollowUpId {get;set;}
    
    public Set<Date> NotWorkingDates;
    
    public List<SelectOption> LocationOptions = New List<SelectOption>();
    public List<SelectOption> AdvisorOptions = New List<SelectOption>();
    public List<SelectOption> TimeOptions = New List<SelectOption>();

    public List<SelectOption> AvailableLocations { get{ return LocationOptions;} set{ value = LocationOptions;} }
    public List<SelectOption> AvailableAdvisors { get{ return AdvisorOptions;} set{ value = AdvisorOptions;} }
    public List<SelectOption> AvailableTimeSlots { get{ return TimeOptions;} set{ value = TimeOptions;} }
    
    public PageReference PG;
    
    public ScheduleMeetingCompCtrl()
    {
        Date TD = Date.Today();
        StartYear = String.ValueOf(TD.Year());
        StartMonth = String.ValueOf(TD.Month()-1);
        StartDay = String.ValueOf(TD.adddays(35).Day());
        
        NoOfMonths = '0'; 
        StartDateTo = '-1'; 
        AdvisorsWokringDays = 'day == 9';
        
        AvailableLocations();
        AdvisorOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        
        AvailableAdvisorsDisable = true;
        AvailableTimeDisable = true;
        
        //Set<Date> NotWorkingDates = New Set<Date>();
        NotWorkingDates = New Set<Date>();
        for(integer i=1; i <Integer.ValueOf(NoOfMonths)*30; i++)
        {
            Datetime dt = DateTime.newInstance(System.today().adddays(i), Time.newInstance(0, 0, 0, 0));
            NotWorkingDates.add(dt.date());
        }
        
        if(NotWorkingDates.size()>0)
        {
            disableddates = '';
            integer k = 1;
            For(Date dt : NotWorkingDates)
            {
                if(NotWorkingDates.size() != k)
                    disableddates = disableddates + dt.Month() + '-' + dt.Day() + '-' + dt.Year() + '", "';
                else
                    disableddates = disableddates + dt.Month() + '-' + dt.Day() + '-' + dt.Year();
            
                ++k;  
            }
        }
        
        disableddates = '["' + disableddates + '"]';  
    }
    
    public PageReference AvailableLocations()
    {
        List<SelectOption> options = new List<SelectOption>();
        Schema.DescribeFieldResult fieldResult = Consultation_Follow_up__c.Location__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        LocationOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        
        for(Schema.PicklistEntry f : ple)
        LocationOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        
        return null;
    }
    
    public void AvailableAdvisors()
    {
        Date TD = Date.Today();
        StartYear = String.ValueOf(TD.Year());
        StartMonth = String.ValueOf(TD.Month()-1);
        StartDay = String.ValueOf(TD.adddays(35).Day());
        
        NoOfMonths = '0'; 
        StartDateTo = '-1'; 
        AdvisorsWokringDays = 'day == 9';
           
        AdvisorOptions.clear();
        AvailableAdvisorsDisable = true;
        AdvisorOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        
        TimeOptions.clear();
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        AvailableTimeDisable = true;
        
        List<User> userList = [Select Id, Name From User Where Location__c =: LocationSelected AND Location__c !=''];
        
        for(User u : userList)
            AdvisorOptions.add(new SelectOption(u.id, u.name));
            
        if(AdvisorOptions.size()>1)
        {
            AvailableAdvisorsDisable = false;
        }
    }
    
    public void AvailableDays()
    {
        Date TD = Date.Today().adddays(2);
        StartYear = String.ValueOf(TD.Year());
        StartMonth = String.ValueOf(TD.Month()-1);
        StartDay = String.ValueOf(TD.Day());
        
        JqueryDatePicker__c DatePicker = JqueryDatePicker__c.getInstance('DatePicker');
        NoOfMonths = DatePicker.NoOfMonths__c;
        StartDateTo = DatePicker.StartDateTo__c;
        
        User U = [select Id, Name, DayStartTime__c, DayEndTime__c, Start_of_day__c, End_of_day__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Location__c From User Where Id =: AdvisorSelected];
        
        Set<String> NoWorkingDaysOfWeek = New Set<String>();
        
        if(U.Monday__c==false)
        {
            NoWorkingDaysOfWeek.add('Monday');
        }
        if(U.Tuesday__c==false)
        {
             NoWorkingDaysOfWeek.add('Tuesday');
        }
        if(U.Wednesday__c==false)
        {
             NoWorkingDaysOfWeek.add('Wednesday');
        }
        if(U.Thursday__c==false)
        {
             NoWorkingDaysOfWeek.add('Thursday');
        }
        if(U.Friday__c==false)
        {
             NoWorkingDaysOfWeek.add('Friday');
        } 
        
        List<Leave_Plan__c> lstLeaveplan = [select id, StartTime__c, EndTime__c, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__c =: AdvisorSelected];
        
        System.debug('-lstLeaveplan- '+ lstLeaveplan);
        
        Set<Date> LeaveSet = New Set<Date>();
        integer LStartTime, LEndTime, WStartTime, WEndTime;
        
        for(Leave_Plan__c l : lstLeaveplan)
        {
            LStartTime = Integer.ValueOf(l.StartTime__c);
            LEndTime = Integer.ValueOf(l.EndTime__c);
            WStartTime = Integer.ValueOf(U.DayStartTime__c); 
            WEndTime = Integer.ValueOf(U.DayEndTime__c);
            
            if(l.Start_Date__c == l.End_Date__c && LStartTime <= WStartTime && LEndTime >= WEndTime)
            {
                LeaveSet.add(l.Start_Date__c);
            }
            else if(l.Start_Date__c != l.End_Date__c)
            {
                While(l.Start_Date__c <= l.End_Date__c)
                {  
                    //if(l.Start_Date__c == l.End_Date__c && LStartTime <= WStartTime && LEndTime >= WEndTime)
                    if(l.Start_Date__c <= l.End_Date__c && LStartTime <= WStartTime && LEndTime >= WEndTime)
                    {
                        LeaveSet.add(l.Start_Date__c);
                    }
                    l.Start_Date__c = l.Start_Date__c.adddays(1);
                }
            }
        }
        
        NotWorkingDates = New Set<Date>();
        
        for(integer i=1; i <Integer.ValueOf(NoOfMonths)*30; i++)
        {
            Datetime dt = DateTime.newInstance(System.today().adddays(i), Time.newInstance(0, 0, 0, 0));
            String dayOfWeek = dt.format('EEEE');
            System.debug('Day : ' + dayOfWeek);
            
            if(noWorkingDaysOfWeek.size()>0 && NoWorkingDaysOfWeek.contains(dayOfWeek))
                NotWorkingDates.add(dt.date());
            else if(LeaveSet.size()>0 && LeaveSet.contains(dt.date()))
                NotWorkingDates.add(dt.date());
        }
        
        disableddates = '';
          
        if(NotWorkingDates.size()>0)
        {
            disableddates = '';
            integer k = 1;
            
            For(Date dt : NotWorkingDates)
            {
                if(NotWorkingDates.size() != k)
                    disableddates = disableddates + dt.Month() + '-' + dt.Day() + '-' + dt.Year() + '", "';
                else
                    disableddates = disableddates + dt.Month() + '-' + dt.Day() + '-' + dt.Year();
                    
                ++k;  
            }
        }
        
        disableddates = '["' + disableddates + '"]';
        
        System.debug('-DisableddatesFinal- ' + disableddates);
        
        //return null;
    }
    
    public void AvailableTimeSlots()
    {
        TimeOptions.clear();
        AvailableTimeDisable = true;
        
        integer LStartTime, LEndTime, WStartTime, WEndTime;
       
        User U = [select Id, Name, DayStartTime__c, DayEndTime__c, Start_of_day__c, End_of_day__c, Monday__c, Tuesday__c, Wednesday__c, Thursday__c, Friday__c, Location__c From User Where Id =: AdvisorSelected];
        
        Date dt = Date.newInstance(Integer.Valueof(DateSelected.split('/')[2]), Integer.Valueof(DateSelected.split('/')[0]), Integer.Valueof(DateSelected.split('/')[1]));
        
        System.debug('-dt-'+ dt);
        System.debug('-AdvisorSelected-'+ AdvisorSelected );
        
        List<Leave_Plan__c> lstLeaveplan = [select id, StartTime__c, EndTime__c, Start_Date__c, End_Date__c, Start_Time__c, End_Time__c, Comments__c from Leave_Plan__c where User__c =: AdvisorSelected AND (Start_Date__c=:dt OR End_Date__c=:dt)];
        
        List<Consultation_Follow_up__c> lstFollowUpObj = [select id, Consultation__r.Name, Meeting_Date__c, MeetingTime__c, Advisors__c,Confirmation_Status__c, Meeting_Time__c, Location__c,Advisor__c, Status__c from Consultation_Follow_up__c where Advisors__c=: AdvisorSelected and Meeting_date__c=:dt];
        
        List<Consultation_Follow_up__c> lstFollowUpObj1 = [select id, Consultation__r.Name, Meeting_Date__c, MeetingTime__c, Advisors__c,Confirmation_Status__c, Meeting_Time__c, Location__c,Advisor__c, Status__c from Consultation_Follow_up__c];
        
        System.debug('-lstFollowUpObj1 - '+ lstFollowUpObj1);
        
        Set<Integer> FLSet = New Set<Integer>();
        
        if(lstFollowUpObj.size() > 0)
        {
            for(Consultation_Follow_up__c c : lstFollowUpObj){
                if(c.Status__c != 'Rejected')
                    FLSet.add(Integer.ValueOf(c.Meeting_Time__c));
            }
        }
        
        System.debug('-VKS3FLSet-'+ FLSet);
        
        System.debug('-VKSlstLeaveplan size-'+ lstLeaveplan.size());
        
        System.debug('-VKSlstLeaveplan-'+ lstLeaveplan);
        
        TimeOptions.add(new SelectOption('-SELECT-', '-SELECT-'));
        
        WStartTime = Integer.ValueOf(U.DayStartTime__c);
        WEndTime = Integer.ValueOf(U.DayEndTime__c);
        
        if(lstLeaveplan.size()>0)
        {
            for(Leave_Plan__c l : lstLeaveplan)
            {
                LStartTime = Integer.ValueOf(l.StartTime__c);
                LEndTime = Integer.ValueOf(l.EndTime__c);
                
                Set<Integer> iSet = New Set<Integer>();
                
                if(l.Start_Date__c == dt && l.End_Date__c == dt)
                {
                     for(Integer i=LStartTime; i< LEndTime; i++)
                     iSet.add(i);
                     
                     System.debug('-VKS3iSet-'+ iSet);
                     
                     for(Integer i= WStartTime; i < WEndTime; i++)
                     {
                         if(!iSet.contains(i) && !FLSet.contains(i))
                             TimeOptions.add(new SelectOption( String.ValueOf(i), SetAmPm(i)));
                     }
                }
            }
        }
        else
        {
            for(Integer i=WStartTime; i< WEndTime; i++)
            {
                 if(!FLSet.contains(i)) {
                     TimeOptions.add(new SelectOption( String.ValueOf(i), SetAmPm(i)));
                 }   
            }
        }
        
        System.debug('-VKS3-'+ TimeOptions);
        
        if(TimeOptions.size()>1)
            AvailableTimeDisable = false;
    }
    
    public String SetAmPm(integer t)
    {
        String tm;
        
        if(t==12)
            tm = String.ValueOf(t) + ' PM' + ' - ' + '0'+ String.ValueOf(t-11) + ' PM';
        else if(t>12)
            tm = '0'+ String.ValueOf(t-12) + ' PM' + ' - ' + '0'+ String.ValueOf(t-11) + ' PM';
        
        if(t==11)
            tm = String.ValueOf(t) + ' AM' + ' - ' + String.ValueOf(t+1) + ' PM';
        else if(t==10)
            tm = String.ValueOf(t) + ' AM' + ' - ' + String.ValueOf(t+1) + ' AM';
        else if(t==9)
            tm = '0'+ String.ValueOf(t) + ' AM' + ' - ' + String.ValueOf(t+1) + ' AM';
        else if(t<9)
            tm = '0'+ String.ValueOf(t) + ' AM' + ' - ' + '0'+ String.ValueOf(t+1) + ' AM';
            
       return tm;
    }
    
    public PageReference scheduleMeeting()
    {
        System.debug('## VKS - ' + PG);
        
        System.debug('$$ VKS - ' + FollowUpEmail +' - '+ FollowUpId);
        
        if(FollowUpEmail != null && FollowUpEmail != '')
        {
            Consultation__c Con1 = [select id,ET_Consultant__c From Consultation__c WHERE Contact_Consultation__r.Email = : FollowUpEmail limit 1];
            
            System.debug(' %% VKS - ' + Con1);
            
            Consultation__c Con = [select id,ET_Consultant__c From Consultation__c WHERE Contact_Consultation__r.Email = : FollowUpEmail limit 1];
            
            Consultation_Follow_up__c FollowUp = New Consultation_Follow_up__c();
            FollowUp.Meeting_Time__c = TimeSelected;
            FollowUp.MeetingTime__c = SetAmPm(Integer.valueOf(TimeSelected));
            FollowUp.Meeting_Date__c = Date.newInstance(Integer.Valueof(DateSelected.split('/')[2]), Integer.Valueof(DateSelected.split('/')[0]), Integer.Valueof(DateSelected.split('/')[1]));
            FollowUp.Advisor__c = [Select Id, Name From User Where id =: AdvisorSelected limit 1].Name;
            FollowUp.Advisors__c = AdvisorSelected;
            FollowUp.Location__c = LocationSelected;
            FollowUp.Status__c ='Requested';
            FollowUp.Consultation__c = Con.id;
            FollowUp.FollowUp_Consultation_Type__c = 'Follow-up for online clients';
            
            insert FollowUp;
            
            Con.ET_Consultant__c = [Select Id, Name From User Where id =: AdvisorSelected limit 1].Name;
            update Con;
            
            PG = new PageReference(System.Label.ForcecomSite+'/ClientMeetingSchedule?FollowRecId='+FollowUp.Id);
            
        }
        
        if(FollowUpId != null && FollowUpId != '')
        {
            Consultation_Follow_up__c FollowUp = [Select Id,Consultation__c,Meeting_Time__c, MeetingTime__c,Meeting_Date__c,Advisor__c,Advisors__c,Location__c, Status__c From Consultation_Follow_up__c Where Id =:FollowUpId];
            FollowUp.Meeting_Time__c = TimeSelected;
            FollowUp.MeetingTime__c = SetAmPm(Integer.valueOf(TimeSelected));
            FollowUp.Meeting_Date__c = Date.newInstance(Integer.Valueof(DateSelected.split('/')[2]), Integer.Valueof(DateSelected.split('/')[0]), Integer.Valueof(DateSelected.split('/')[1]));
            FollowUp.Advisor__c = [Select Id, Name From User Where id =: AdvisorSelected limit 1].Name;
            FollowUp.Advisors__c = AdvisorSelected; 
            FollowUp.Location__c = LocationSelected;
            FollowUp.Status__c ='Rescheduled by Client';
            
            update FollowUp;
              
            Consultation__c Con = [select id,ET_Consultant__c From Consultation__c WHERE id = : FollowUp.Consultation__c  limit 1];
            Con.ET_Consultant__c = [Select Id, Name From User Where id =: AdvisorSelected limit 1].Name;
            update Con;
            
            PG = new PageReference(System.Label.ForcecomSite+'/ClientMeetingConfirm?FollowRecId='+FollowUp.Id);
        }
     
        PG.setRedirect(true);
        
        FollowUpEmail = '';
        FollowUpId = '';
        
        return PG;
    }  
    
    public void ReScheduleMeeting()
    {
        
    } 
    
    public void Dummy()
    {
        
    } 
}