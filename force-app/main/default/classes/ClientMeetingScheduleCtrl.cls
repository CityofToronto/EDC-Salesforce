public class ClientMeetingScheduleCtrl
{
    public Consultation_Follow_up__c FollowUp {get; set;}
    
    public boolean ShowRegisConfirmPnlId{get;set;}
    public boolean ShowMeetingConfimedMsg{get;set;}
    public boolean ShowCalendar{get;set;}
    public boolean ShowErrMsg{get;set;}
    
    public String  FollowUpEmail;
    public String  FollowUpRecId;
    
    public ClientMeetingScheduleCtrl()
    {  
        ShowRegisConfirmPnlId = false;
        ShowMeetingConfimedMsg = false;
        ShowCalendar = false;
        ShowErrMsg= false;
        
        if(ApexPages.currentPage().getParameters().get('email') != null)
        {
            if(ApexPages.currentPage().getParameters().get('email') != '')
            {
                ShowRegisConfirmPnlId = true;
                ShowCalendar = true;
            }
            else
            {
                ShowErrMsg = true;
                ShowRegisConfirmPnlId = false;
                ShowCalendar = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Please check the Url'));
            }
        }
        
        if(ApexPages.currentPage().getParameters().get('FollowRecId') != null)
        {
            if(ApexPages.currentPage().getParameters().get('FollowRecId') != '')
            {
                ShowMeetingConfimedMsg = true;
                ShowCalendar = false;
                ShowRegisConfirmPnlId =  false;
            }
            else
            {
                ShowErrMsg = true;
                ShowMeetingConfimedMsg = false;
                ShowCalendar = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Please check the Url'));
            }
        }
        
    }
}