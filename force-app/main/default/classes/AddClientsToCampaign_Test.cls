@isTest(seeAllData=false)
public class AddClientsToCampaign_Test
{
     Static testMethod Void checkClientAddition()
     {
         Campaign camp = new Campaign(Name='Stage#1');
         insert camp;
         
         Campaign_Mapping_Custom_Setting__c Cmap = new Campaign_Mapping_Custom_Setting__c(Name='Stage#1',CampaignRecordId__c = camp.ID);
         insert Cmap; 
         
         Campaign camp2 = new Campaign(Name='GrantRecipient');
         insert camp2;
         
         Campaign_Mapping_Custom_Setting__c Cmap2 = new Campaign_Mapping_Custom_Setting__c(Name='Grant Recipient',CampaignRecordId__c = camp2.ID);
         insert Cmap2; 
         
         Campaign camp3 = new Campaign(Name='Graduate');
         insert camp3;
         
         Campaign_Mapping_Custom_Setting__c Cmap3 = new Campaign_Mapping_Custom_Setting__c(Name='Graduate',CampaignRecordId__c = camp3.ID);
         insert Cmap3; 
        
        
         
         Account acct = new Account(Name='City Of Toronto');
         insert acct;
         
         Contact firstCon = new Contact(LastName='Ray', AccountID = acct.ID, Email='test@cityoftoronto.com');
         insert firstCon;
         
         Starter_Company_Clients__c sc = new Starter_Company_Clients__c(Account__c = acct.ID, Contact__c = firstCon.ID, Phase_1_Application_Approved__c= 'yes');
         insert sc;
         
         Starter_Company_Clients__c upsc =[Select id, Phase_1_Application_Approved__c,Phase_2_GrantApproved__c,Program_Completed__c from Starter_Company_Clients__c where Id =: sc.Id];
         upsc.Program_Completed__c ='yes';
         update upsc;
         
         
         /*****************************************************************************************************************/
         Account acct1 = new Account(Name='Enterprise Toronto');
         insert acct1;
         
         Contact SecCon = new Contact(LastName='Kim', AccountID = acct1.ID, Email='test@toronto.com');
         insert  SecCon;
         
         
         Starter_Company_Clients__c sc2 = new Starter_Company_Clients__c(Account__c = acct.ID, Contact__c = SecCon.ID, Phase_2_GrantApproved__c = 'yes');
         insert sc2;
         
         Starter_Company_Clients__c upsc2 =[Select id, Phase_1_Application_Approved__c,Phase_2_GrantApproved__c,Program_Completed__c from Starter_Company_Clients__c where Id =: sc2.Id];
         upsc2.Phase_1_Application_Approved__c ='Yes';
         update upsc2;
         
       /*****************************************************************************************************************/
         Account acct2 = new Account(Name='Toronto Canada');
         insert acct2;
         
         Contact ThirdCon = new Contact(LastName='Kim', AccountID = acct2.ID, Email='test@toronto.ca');
         insert ThirdCon ;
         
         
         Starter_Company_Clients__c sc3 = new Starter_Company_Clients__c(Account__c = acct2.ID, Contact__c = ThirdCon.ID, Program_Completed__c ='yes');
         insert sc3;
         
         Starter_Company_Clients__c upsc3 =[Select id, Program_Completed__c,Phase_2_GrantApproved__c from Starter_Company_Clients__c where Id =: sc3.Id];
         upsc3.Phase_2_GrantApproved__c= 'Yes';
         update upsc3;
     }
    
}