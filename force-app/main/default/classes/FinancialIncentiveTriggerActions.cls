public class FinancialIncentiveTriggerActions{
    public static void validateRejectionReason( List<Financial_Incentive__c> newFinancialIncentiveList, Map<ID, Financial_Incentive__c> oldFinancialIncentiveMap){
        Map<Id, Financial_Incentive__c> rejectedStatements = new Map<Id, Financial_Incentive__c>{};
        Map<Id, Financial_Incentive__c> approvedAmountMap = new Map<Id, Financial_Incentive__c>{};
        Map<Id, Financial_Incentive__c> imitApprovedMap = new Map<Id, Financial_Incentive__c>{};
        Map<Id, Financial_Incentive__c> imitCityCounApprovedMap = new Map<Id, Financial_Incentive__c>{};
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c']){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        
        if(oldFinancialIncentiveMap!=null){
        for(Financial_Incentive__c inv: newFinancialIncentiveList){
                /* 
                  Get the old object record, and check if the approval status 
                  field has been updated to rejected. If so, put it in a map 
                  so we only have to use 1 SOQL query to do all checks.
                */
                system.debug('inside update loop');
                Financial_Incentive__c oldInv = oldFinancialIncentiveMap.get(inv.Id);

                //Below condition to capture the Financial Incentive Record Ids for which Grant request has been declined
                if ((oldInv.Status__c != 'Declined'  && inv.Status__c == 'Declined')|| (oldInv.Status__c != 'Application Declined'  && inv.Status__c == 'Application Declined')){ 
                    rejectedStatements.put(inv.Id, inv);  
                    system.debug('rejectedStatements++++'+rejectedStatements);
                }
                
                //Below condition to capture the Financial Incentive Record Ids that has no Amount Approved value specified
                if(oldInv.Status__c != 'Approved'  && inv.Status__c == 'Approved' && inv.RecordTypeId==recTypeNameIDMap.get('Sector_Grant') && inv.Amount_Approved__c==null){ 
                    approvedAmountMap.put(inv.Id, inv);  
                }
                
                //Below condition to capture the IMIT Financial Incentive Record Ids that has been Approved without specifying No Conflict
                if(oldInv.Status__c != 'Approved by GM'  && inv.Status__c == 'Approved by GM' && inv.RecordTypeId==recTypeNameIDMap.get('IMIT') && (inv.Has_No_Conflict_Doc_Uploaded_EDC_GM__c!='Yes' || inv.No_Conflict_of_Interest_EDC_GM__c!='Yes')){ 
                    imitApprovedMap.put(inv.Id, inv);  
                }
                
                //Below condition to capture the IMIT Financial Incentive Record Ids that has been Approved without specifying if Approval Document from City Council has been Uploaded
                if(oldInv.Status__c != 'Approved by City Council'  && inv.Status__c == 'Approved by City Council' && inv.RecordTypeId==recTypeNameIDMap.get('IMIT') && inv.City_Council_s_Approval_Doc_Uploaded__c != 'Yes'){ 
                    imitCityCounApprovedMap.put(inv.Id, inv);  
                }
                
                //Below logic will assign current user as Record Submitter
                if (oldInv.Status__c != 'Pending Approval'  && inv.Status__c == 'Pending Approval'){ 
                    inv.Record_Submitter__c = UserInfo.getUserId();  
                }
                system.debug('invRecord_Submitter__c ++++'+inv.Record_Submitter__c );
                
                //Below Logic will Update the Financial Incentive Records owner from  Queue to Current User when Status changes to In Review for all record type except Sector   
                if (oldInv.Status__c == 'Submitted' && inv.Status__c == 'In Review' && inv.RecordTypeId!=recTypeNameIDMap.get('Sector_Grant')){ 
                    inv.OwnerId = UserInfo.getUserId();  
                }
                
                //Below code block is to update the Event Report Date for BIC Grant Records once status has been completed
                if (inv.Status__c == 'Completed' && oldFinancialIncentiveMap.get(inv.Id).Status__c != 'Completed' && inv.RecordTypeId==recTypeNameIDMap.get('Business_Incubation_Grant')){ 
                    Integer currentYear = System.Today().year();
                    Integer nextYear = currentYear+1;
                    Date currentYearDate = Date.newInstance(currentYear, 11, 15);
                    Date nextYearDate = Date.newInstance(nextYear, 11, 15);
                    if(currentYearDate.addDays(1)>date.today()){
                        inv.BIC_Report_Trigger_Date__c = currentYearDate;
                    }
                    else{
                        inv.BIC_Report_Trigger_Date__c = nextYearDate;
                    }
                }
            }
        }
        if (!rejectedStatements.isEmpty()){
            // Get the most recent approval process instance for the object.
            // If there are some approvals to be reviewed for approval, then
            // get the most recent process instance for each object.
            List<Id> processInstanceIds = new List<Id>{};
            for (Financial_Incentive__c invs : [SELECT Rejection_Reason__c,Id, (SELECT ID
                                                FROM ProcessInstances
                                                ORDER BY CreatedDate DESC
                                                LIMIT 1)
                                                FROM Financial_Incentive__c
                                                WHERE ID IN :rejectedStatements.keySet() AND Rejection_Reason__c='' ]){
                if(invs.ProcessInstances.size()>0)
                processInstanceIds.add(invs.ProcessInstances[0].Id);
            }

            // Now that we have the most recent process instances, we can check
            // the most recent process steps for comments.  
            for (ProcessInstance pi : [SELECT TargetObjectId,
                                        (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                        FROM ProcessInstance
                                        WHERE Id IN :processInstanceIds
                                        ORDER BY CreatedDate DESC]){                   
                rejectedStatements.get(pi.TargetObjectId).addError('Operation Cancelled: Please provide a Rejection Reason!');
            }
        }
       
        if (!approvedAmountMap.isEmpty()){
            List<Id> processApprovedAmountInstanceIds = new List<Id>{};
            for (Financial_Incentive__c invs : [SELECT Rejection_Reason__c,Application_Extension_Date__c,Id, (SELECT ID
                                                FROM ProcessInstances
                                                ORDER BY CreatedDate DESC
                                                LIMIT 1)
                                                FROM Financial_Incentive__c
                                                WHERE ID IN :approvedAmountMap.keySet()]){
                if(invs.ProcessInstances.size()>0)
                processApprovedAmountInstanceIds.add(invs.ProcessInstances[0].Id);
            }

            for (ProcessInstance piAppAm : [SELECT TargetObjectId,
                                        (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                        FROM ProcessInstance
                                        WHERE Id IN :processApprovedAmountInstanceIds
                                        ORDER BY CreatedDate DESC]){                   
                approvedAmountMap.get(piAppAm.TargetObjectId).addError('Operation Cancelled: Please specify Amount Approved before Approval');
            }
        }
        if (!imitApprovedMap.isEmpty()){
            List<Id> processIMITApprovedInstanceIds = new List<Id>{};
            for (Financial_Incentive__c invs : [SELECT Has_No_Conflict_Doc_Uploaded_EDC_GM__c, No_Conflict_of_Interest_EDC_GM__c,Id, (SELECT ID                                 FROM ProcessInstances
                                                ORDER BY CreatedDate DESC
                                                LIMIT 1)
                                                FROM Financial_Incentive__c
                                                WHERE ID IN :imitApprovedMap.keySet()]){
                if(invs.ProcessInstances.size()>0)
                processIMITApprovedInstanceIds.add(invs.ProcessInstances[0].Id);
            }

            for (ProcessInstance piAppAm : [SELECT TargetObjectId,
                                        (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                        FROM ProcessInstance
                                        WHERE Id IN :processIMITApprovedInstanceIds
                                        ORDER BY CreatedDate DESC]){                   
                imitApprovedMap.get(piAppAm.TargetObjectId).addError('Operation Cancelled: Please specify you have No Conflict of Interest and uploaded its document before Approval');
            }
        }
        if (!imitCityCounApprovedMap.isEmpty()){
            List<Id> processIMITCityCouApprovedInstanceIds = new List<Id>{};
            for (Financial_Incentive__c invs : [SELECT City_Council_s_Approval_Doc_Uploaded__c, Id, (SELECT ID                                 FROM ProcessInstances
                                                ORDER BY CreatedDate DESC
                                                LIMIT 1)
                                                FROM Financial_Incentive__c
                                                WHERE ID IN :imitCityCounApprovedMap.keySet()]){
                if(invs.ProcessInstances.size()>0)
                processIMITCityCouApprovedInstanceIds.add(invs.ProcessInstances[0].Id);
            }

            for (ProcessInstance piAppAm : [SELECT TargetObjectId,
                                        (SELECT Id, StepStatus, Comments 
                                        FROM Steps
                                        ORDER BY CreatedDate DESC
                                        LIMIT 1 )
                                        FROM ProcessInstance
                                        WHERE Id IN :processIMITCityCouApprovedInstanceIds
                                        ORDER BY CreatedDate DESC]){                   
                imitCityCounApprovedMap.get(piAppAm.TargetObjectId).addError('Operation Cancelled: IMIT Application can not be Approved without uploading City Council Approval Document');
            }
        }
    }
    public static void validateAccountRelationOnFinancialIncentive( List<Financial_Incentive__c> newFinancialIncentiveList){
        Map<Id, Set<String>> accountToRelatedContacts = new Map<Id, Set<String>>();
        Set<Id> accIdSet = new Set<Id>();
        Set<Id> contIdSet = new Set<Id>();
        Set<Id> busAccountIdSet = new Set<Id>();
        Set<Id> busContIdSet = new Set<Id>();
         
        for(Financial_Incentive__c finInc: newFinancialIncentiveList){
            accIdSet.add(finInc.Account__c);
            contIdSet.add(finInc.Contact__c);
        }
        if(accIdSet!=null){
            for(Account acc: [SELECT ID,Name,IsPersonAccount From Account WHERE ID IN:accIdSet]){
                if(!acc.IsPersonAccount)
                busAccountIdSet.add(acc.Id);
            }
        }   
        if(contIdSet!=null){
        for(Contact con: [SELECT ID,LastName,IsPersonAccount From Contact WHERE ID IN:contIdSet]){
                if(!con.IsPersonAccount)
                busContIdSet.add(con.Id);
            }
        }
        if(busAccountIdSet!=null || busContIdSet!=null){
            for(AccountContactRelation accCon: [SELECT Id, AccountId, ContactId FROM AccountContactRelation WHERE AccountId IN: busAccountIdSet OR ContactId IN: busContIdSet]){
                if(!accountToRelatedContacts.containsKey(accCon.AccountId)){
                    accountToRelatedContacts.put(accCon.AccountId, new Set<String>{accCon.ContactId});
                    system.debug('++accountToRelatedContactsinside++'+accountToRelatedContacts);
                }else{
                    accountToRelatedContacts.get(accCon.AccountId).add(accCon.ContactId);
                }
            }
            for(Financial_Incentive__c finIncVal: newFinancialIncentiveList){
                system.debug('++finIncVal++'+finIncVal);
                if(finIncVal.Account__c!=null && finIncVal.Contact__c!=null && busAccountIdSet.contains(finIncVal.Account__c) && busContIdSet.contains(finIncVal.Contact__c) && (!accountToRelatedContacts.containsKey(finIncVal.Account__c) || (accountToRelatedContacts.containsKey(finIncVal.Account__c) && !accountToRelatedContacts.get(finIncVal.Account__c).contains(finIncVal.Contact__c)))){
                    finIncVal.adderror('IMIT Account and IMIT Contact are not related to each other');
                }
            }
        }
    }
    public static void updateFinancialIncentiveNameCustom(List<Financial_Incentive__c> newFinancialIncentiveList){
        List<Financial_Incentive__c> lstToUpdate = new List<Financial_Incentive__c>();
        Map<String,String> recTypeNameIDMap = new Map<String,String>();
        for(RecordType recType:[SELECT DeveloperName,Id,Name,SobjectType FROM RecordType WHERE SobjectType = 'Financial_Incentive__c']){
            recTypeNameIDMap.put(recType.DeveloperName,recType.Id);
        }
        for(Financial_Incentive__c fInc: [SELECT Id, Name, Property_Street__c,Financial_Incentive_Name__c,RecordTypeId,Account__c,Account__r.Name FROM Financial_Incentive__c WHERE ID IN: newFinancialIncentiveList]){
            if(fInc.Name!=null){
                List<String> lsName = fInc.Name.split('-',3);
                System.debug('lsName+++'+lsName);
                String autoNumber = lsName[2];
                if(fInc.RecordTypeId==recTypeNameIDMap.get('BIA_Commercial_Industrial_Facade_and_Property_Improvement')){
                    fInc.Financial_Incentive_Name__c = 'FIN-CFI-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('BIA_Innovation_Fund')){
                    fInc.Financial_Incentive_Name__c = 'FIN-INO-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('BIA_Leadership_Fund')){
                    fInc.Financial_Incentive_Name__c = 'FIN-LDR-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('BIA_Outside_Mural_and_Street_Art_Grant')){
                    fInc.Financial_Incentive_Name__c = 'FIN-OMS-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('BIA_Streetscape_Master_Plan_Funding')){
                    fInc.Financial_Incentive_Name__c = 'FIN-SMP-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('Business_Incubation_Grant')){
                    fInc.Financial_Incentive_Name__c = 'FIN-OPG-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('Event_Sponsorship_Grant')){
                    fInc.Financial_Incentive_Name__c = 'FIN-EVT-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('Sector_Grant')){
                    fInc.Financial_Incentive_Name__c = 'FIN-SEC-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('Starter_Company_Grant')){
                    fInc.Financial_Incentive_Name__c = 'FIN-STR-'+System.Today().year()+'-'+autoNumber;
                }
                if(fInc.RecordTypeId==recTypeNameIDMap.get('IMIT')){
                    if(fInc.Property_Street__c!=null){
                        fInc.Financial_Incentive_Name__c = 'FIN-IMIT-'+System.Today().year()+'-'+fInc.Property_Street__c+'-'+autoNumber;
                    }else{
                    fInc.Financial_Incentive_Name__c = 'FIN-IMIT-'+System.Today().year()+'-'+autoNumber;
                        
                    }
                }
                
                lstToUpdate.add(fInc);
            }           
        }
        if(lstToUpdate.size()>0){
            Database.update(lstToUpdate);
        }
   }
}