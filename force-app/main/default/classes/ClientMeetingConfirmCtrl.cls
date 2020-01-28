public class ClientMeetingConfirmCtrl
{
    public Consultation_Follow_up__c FollowUp {get; set;}
    
    public boolean ShowFollowUpRecord{get;set;}
    public boolean ShowMeetingConfirmMsg {get;set;}
    public boolean ShowRegisMeetingConfirmMsg {get;set;}
    public boolean ShowCalendar{get;set;}
    public boolean ShowErrorMsg{get;set;}
    public ID FollowUpRecId;

    public ClientMeetingConfirmCtrl()
    {  
        ShowErrorMsg = true;
        ShowFollowUpRecord = false;
        ShowMeetingConfirmMsg = false;
        ShowRegisMeetingConfirmMsg = false;
        ShowCalendar = false;
            
        if(ApexPages.currentPage().getParameters().get('Id') != null)
        {
            if(ApexPages.currentPage().getParameters().get('id') != '')
            {
                FollowUp = [select id, Meeting_Time__c,MeetingTime__c,Advisors__c,Confirmation_Status__c,Meeting_Date__c,  Advisor__c, Location__c, Status__c From Consultation_Follow_up__c WHERE Id = : ApexPages.currentPage().getParameters().get('Id')];
                ShowFollowUpRecord = true;
                ShowErrorMsg = false;
            }
            else
            {
                ShowErrorMsg = true;
                ShowFollowUpRecord = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Please check the Url'));
            }
        }
        
        if(ApexPages.currentPage().getParameters().get('FollowRecId') != null)
        {
            if(ApexPages.currentPage().getParameters().get('FollowRecId') != '')
            {
                ShowCalendar = false;
                ShowErrorMsg = false;
                ShowFollowUpRecord = false;
                ShowMeetingConfirmMsg = false;
                ShowRegisMeetingConfirmMsg = true;
            }
            else
            {
                ShowCalendar = false;
                ShowErrorMsg = true;
                ShowFollowUpRecord = false;
                ShowMeetingConfirmMsg = false;
                ShowRegisMeetingConfirmMsg = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Please check the Url'));
            }
        }
        
         
        if(ApexPages.currentPage().getParameters().get('ShowCal') != null)
        {
            if(ApexPages.currentPage().getParameters().get('ShowCal') == 'True')
            {
                ShowCalendar = true;
                ShowFollowUpRecord = true;
                ShowErrorMsg = false;
                ShowMeetingConfirmMsg = false;
                ShowRegisMeetingConfirmMsg = false;
            }
            else
            {
                ShowErrorMsg = true;
                ShowCalendar = false;
                ShowFollowUpRecord = false;
                ShowMeetingConfirmMsg = false;
                ShowRegisMeetingConfirmMsg = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Please check the Url'));
            }
        }
    }
    
    public PageReference MeetingConfirmed()
    {
        FollowUp.Status__c='Confirmed';
        FollowUp.Confirmation_Status__c = 'Confirmed by client';
        update FollowUp ;
        
        ShowFollowUpRecord = false;
        ShowMeetingConfirmMsg = true;
        ShowRegisMeetingConfirmMsg = false;
        ShowCalendar = false;
        ShowErrorMsg = false;
            
        return null; 
    }
    
    public PageReference MeetingReschuled()
    {
        ShowCalendar = true;
        ShowFollowUpRecord = true;
        ShowMeetingConfirmMsg = false;
        ShowRegisMeetingConfirmMsg = false;
        ShowErrorMsg = false;
        
        PageReference PG = new PageReference(System.Label.ForcecomSite+'/ClientMeetingConfirm?Id='+FollowUp.Id+'&ShowCal=True');
        PG.setRedirect(true);
        return PG;
    }
}