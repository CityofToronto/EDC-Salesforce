public class OnlineConsultationMeetingSchedulerCtrl
{
    public boolean ShowRegisConfirmPnlId{get;set;}
    public boolean ShowMeetingConfimedMsg{get;set;}
    public boolean ShowCalendar{get;set;}
    public boolean ShowErrMsg{get;set;}
    public String  InteractionId;
    public String  FollowUpIntId;
    
    public OnlineConsultationMeetingSchedulerCtrl()
    {  
        ShowRegisConfirmPnlId = false;
        ShowMeetingConfimedMsg = false;
        ShowCalendar = false;
        ShowErrMsg= false;
        InteractionId = ApexPages.currentPage().getParameters().get('InteractionId');
        FollowUpIntId = ApexPages.currentPage().getParameters().get('FollowRecId');
        
        Interaction__c intRec = new Interaction__c();
        Interaction__c followUpRec = new Interaction__c();
        
        system.debug('InteractionId ++++'+InteractionId);
        if(InteractionId != '' && InteractionId!=null){
            try{
                intRec = [SELECT Id, Name, Account__c FROM Interaction__c WHERE ID = :InteractionId AND ((Meeting_Status__c=null and Location__c =null and Meeting_Time__c = null and Advisor_Lookup__c=null) OR (Meeting_Status__c= 'Cancelled by Advisor' OR Meeting_Status__c= 'Cancelled by Client'))];
                } catch(Exception ex){
                intRec = null;
            }
            System.debug('intRec +++'+intRec);
            if(intRec != null){
                ShowRegisConfirmPnlId = true;
                ShowCalendar = true;
            }
            else {
                ShowErrMsg = true;
                ShowRegisConfirmPnlId = false;
                ShowCalendar = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Incorrect  Record ID Specified. Please contact City staff and share the error with URL at edc_toronto@toronto.ca '));
            }
        }
        if(InteractionId == ''){
             ShowErrMsg = true;
             ShowRegisConfirmPnlId = false;
             ShowCalendar = false;
             ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'No Record ID Specified. Please Check the URL'));
        }
        if(FollowUpIntId != '' && FollowUpIntId !=null){
            try{
                followUpRec = [SELECT Id, Name, Account__c FROM Interaction__c WHERE ID = :FollowUpIntId AND Meeting_Status__c=:'Requested'];
                } catch(Exception ex){
                followUpRec = null;
            }
            if(followUpRec != null){
                ShowMeetingConfimedMsg = true;
                ShowCalendar = false;
                ShowRegisConfirmPnlId =  false;
            }
            else
            {
                ShowErrMsg = true;
                ShowMeetingConfimedMsg = false;
                ShowCalendar = false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'Incorrect  Record ID Specified. Please contact City staff and share the error with URL at edc_toronto@toronto.ca '));
            }
        }
        if(ApexPages.currentPage().getParameters().get('FollowRecId') == ''){
            ShowErrMsg = true;
            ShowMeetingConfimedMsg = false;
            ShowCalendar = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.info, 'No Record ID Specified. Please Check the URL'));
        }
        
    }
}