public class AccountTriggerActions 
{
    public static void updateContinentOnAccount( List<Account> newAccountList,Map<Id,Account> oldAccounMap){
        Account_Country_Continent_Mapping__mdt[] countryContinentList = [SELECT MasterLabel, QualifiedApiName, Continent_Name__c, Country_Code__c FROM Account_Country_Continent_Mapping__mdt];
        Map<String,String> countryContinentMap = new Map<String,String>();        
        for(Account_Country_Continent_Mapping__mdt accCont : countryContinentList){
            countryContinentMap.put(accCont.Country_Code__c,accCont.Continent_Name__c);
        }
        for(Account acc:newAccountList){
            if((oldAccounMap!=null && ((oldAccounMap.get(acc.Id).BillingCountryCode!=acc.BillingCountryCode) || ( acc.Physical_Continent__c==null && acc.BillingCountryCode!=null))) || (oldAccounMap==null && acc.BillingCountryCode!=null)){
                if(countryContinentMap.get(acc.BillingCountryCode)!=null)
                acc.Physical_Continent__c = countryContinentMap.get(acc.BillingCountryCode); 
            }
            if((oldAccounMap!=null && ((oldAccounMap.get(acc.Id).ShippingCountryCode!=acc.ShippingCountryCode)|| (acc.Mailing_Continent__c==null && acc.ShippingCountryCode!=null))) || (oldAccounMap==null && acc.ShippingCountryCode!=null)){
                if(countryContinentMap.get(acc.ShippingCountryCode)!=null)
                acc.Mailing_Continent__c = countryContinentMap.get(acc.ShippingCountryCode); 
            }
        }
    }
    public static void updateAutoAccCreationFlagOnAccount(List<Account> newAccountList,Map<Id,Account> oldAccounMap){
        String urlvaluestring; 
        system.debug('urlvaluestring++'+System.URL.getCurrentRequestUrl().getPath());
        for(Account acc:newAccountList){
            urlvaluestring =  String.valueOf(System.URL.getCurrentRequestUrl().getPath());
            system.debug('urlvaluestring++'+urlvaluestring);
            if((urlvaluestring.contains('services/data')|| urlvaluestring.contains('a0A/e') || urlvaluestring.contains('/p/process/ProcessInstanceWorkitemWizardStageManager')) && acc.Automated_Account_Creation__c == false){
                acc.Automated_Account_Creation__c = true;    
            }
        }    
    }
    public static void updateBIABoardSizeBeforeUpdate(List<Account> newAccountList,Map<Id,Account> oldAccounMap){
        
        for(Account acc : newAccountList){
            if(acc.Board_Size__c!=null && acc.Standing_Members__c!=null && acc.Board_Size__c>acc.Standing_Members__c && acc.Vacancies__c==null)
                acc.Vacancies__c = acc.Board_Size__c-acc.Standing_Members__c;
            if(acc.Board_Size__c!=null && acc.Vacancies__c!=null && acc.Board_Size__c >acc.Vacancies__c  && acc.Standing_Members__c==null)
                acc.Standing_Members__c = acc.Board_Size__c-acc.Vacancies__c;
        
            if((acc.Standing_Members__c!=null && acc.Standing_Members__c>1 && acc.Quorum__c==null && ((acc.Standing_Members__c/2) -1)>0)|| (oldAccounMap!=null && oldAccounMap.get(acc.Id).Standing_Members__c != acc.Standing_Members__c && acc.Standing_Members__c!=null && acc.Standing_Members__c>1 && acc.Quorum__c==oldAccounMap.get(acc.Id).Quorum__c && ((acc.Standing_Members__c/2) -1)>0))
                if(Math.round((acc.Standing_Members__c/2) -1)>3){
                    acc.Quorum__c = Math.round((acc.Standing_Members__c/2) -1);
                }else{
                    acc.Quorum__c = 3;
                }
        }
    }
}