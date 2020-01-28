trigger AddClientsToCampaign on Starter_Company_Clients__c(after insert, after update) 
{
    for(Starter_Company_Clients__c sc : Trigger.new)
    {
        if(Trigger.isInsert)
        {
            if(sc.Contact__c != null && sc.Phase_1_Application_Approved__c == 'yes')
            {
               Campaign_Mapping_Custom_Setting__c Cmap = Campaign_Mapping_Custom_Setting__c.getvalues('Stage#1');
               List<CampaignMember> CMlist =[Select Name, ContactId from CampaignMember where ContactId =:sc.Contact__c And CampaignId =:Cmap.CampaignRecordId__c];
             
               if(CMlist.size() <= 0)
               {
                   CampaignMember cm = new CampaignMember();
                   cm.ContactId = sc.Contact__c;
                   cm.CampaignId = Cmap.CampaignRecordId__c;
                   Insert cm;
               }
               else
               {
                   //sc.addError('Campaign Member already exist');
               }
            }
        
            if(sc.Contact__c != null && sc.Phase_2_GrantApproved__c == 'yes')
            {
               Campaign_Mapping_Custom_Setting__c Cmap1 = Campaign_Mapping_Custom_Setting__c.getvalues('Grant Recipient');
               List<CampaignMember> CMlist1 =[Select Name, ContactId from CampaignMember where ContactId =:sc.Contact__c And CampaignId =:Cmap1.CampaignRecordId__c];
             
               if(CMlist1.size() <= 0)
               {
                   CampaignMember cm1 = new CampaignMember();
                   cm1.ContactId = sc.Contact__c;
                   cm1.CampaignId = Cmap1.CampaignRecordId__c;
                   Insert cm1; 
               }
                else
               {
                   //sc.addError('Campaign Member already exist');
               }
            }
  
            if(sc.Contact__c != null && sc.Program_Completed__c == 'yes')
            {
               Campaign_Mapping_Custom_Setting__c Cmap2 = Campaign_Mapping_Custom_Setting__c.getvalues('Graduate');
               List<CampaignMember> CMlist2 =[Select Name, ContactId from CampaignMember where ContactId =:sc.Contact__c And CampaignId =:Cmap2.CampaignRecordId__c];
             
               if(CMlist2.size() <= 0)
               {
                   CampaignMember cm2 = new CampaignMember();
                   cm2.ContactId = sc.Contact__c;
                   cm2.CampaignId = Cmap2.CampaignRecordId__c;
                   Insert cm2;
               }
               else
               {
                   //sc.addError('Campaign Member already exist');
               }
                  
            }
        } 

        if(Trigger.isUpdate)
        {
            if(sc.Contact__c != null && sc.Phase_1_Application_Approved__c == 'yes' && Trigger.new[0].Phase_1_Application_Approved__c != Trigger.old[0].Phase_1_Application_Approved__c)
            {
               Campaign_Mapping_Custom_Setting__c Cmap = Campaign_Mapping_Custom_Setting__c.getvalues('Stage#1');
               List<CampaignMember> CMlist =[Select Name, ContactId from CampaignMember where ContactId =:sc.Contact__c And CampaignId =:Cmap.CampaignRecordId__c];
             
               if(CMlist.size() <= 0)
               {
                   CampaignMember cm = new CampaignMember();
                   cm.ContactId = sc.Contact__c;
                   cm.CampaignId = Cmap.CampaignRecordId__c;
                   Insert cm;
               }
               else
               {
                   //sc.addError('Campaign Member already exist');
               }
            }
        
            if(sc.Contact__c != null && sc.Phase_2_GrantApproved__c == 'yes' && Trigger.new[0].Phase_2_GrantApproved__c  != Trigger.old[0].Phase_2_GrantApproved__c)
            {
               Campaign_Mapping_Custom_Setting__c Cmap1 = Campaign_Mapping_Custom_Setting__c.getvalues('Grant Recipient');
               List<CampaignMember> CMlist1 =[Select Name, ContactId from CampaignMember where ContactId =:sc.Contact__c And CampaignId =:Cmap1.CampaignRecordId__c];
             
               if(CMlist1.size() <= 0)
               {
                   CampaignMember cm1 = new CampaignMember();
                   cm1.ContactId = sc.Contact__c;
                   cm1.CampaignId = Cmap1.CampaignRecordId__c;
                   Insert cm1; 
               }
                else
               {
                   //sc.addError('Campaign Member already exist');
               }
            }
  
            if(sc.Contact__c != null && sc.Program_Completed__c == 'yes'&& Trigger.new[0].Program_Completed__c != Trigger.old[0].Program_Completed__c)
            {
               Campaign_Mapping_Custom_Setting__c Cmap2 = Campaign_Mapping_Custom_Setting__c.getvalues('Graduate');
               List<CampaignMember> CMlist2 =[Select Name, ContactId from CampaignMember where ContactId =:sc.Contact__c And CampaignId =:Cmap2.CampaignRecordId__c];
             
               if(CMlist2.size() <= 0)
               {
                   CampaignMember cm2 = new CampaignMember();
                   cm2.ContactId = sc.Contact__c;
                   cm2.CampaignId = Cmap2.CampaignRecordId__c;
                   Insert cm2;
               }
               else
               {
                   //sc.addError('Campaign Member already exist');
               }
                  
            }
        } 
    }
}