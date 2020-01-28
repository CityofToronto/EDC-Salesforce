trigger LeavePlanTrigger on Leave_Plan__c (after insert, after update, before delete) {
    Set<String> userIdSet = new Set<String>();
    Set<date> dateSet = new Set<date>();
    if(Trigger.isInsert || Trigger.isUpdate){ 
        for(Leave_Plan__c lp: trigger.new){
          userIdSet.add(lp.User__c);  
          if(lp.Start_Date__c<lp.End_Date__c){
              Date tempDate = lp.Start_Date__c;
              for(integer i=0;tempDate<=lp.End_Date__c;i++){
                  dateSet.add(tempDate);
                  tempDate = tempDate.addDays(1); 
              }
          }
          else{
          dateSet.add(lp.Start_Date__c);
          //dateSet.add(lp.End_Date__c);     
          } 
        }
        System.debug('dateSet++'+dateSet);
        //List<Custom_Calendar__c> clList = new List<Custom_Calendar__c>(SELECT Id FROM Custom_Calendar__c WHERE User__c IN: userIdSet AND On_Leave__c = false AND Calendar_Date__c IN: dateSet);
        List<Custom_Calendar__c> cListUpdate = new List<Custom_Calendar__c>();
        for(Custom_Calendar__c cc : [SELECT Id,On_Leave__c  FROM Custom_Calendar__c WHERE User__c IN: userIdSet AND On_Leave__c = false AND Calendar_Date__c IN: dateSet]){
            cc.On_Leave__c  = true;
            cListUpdate.add(cc);
        }
        if(cListUpdate.size()>0){
            Database.update(cListUpdate);
        }
    }   
    //Below logic to update related Working hour records if Leave records has been delete
    if(Trigger.isDelete) {
        Set<String> userIdSetOld = new Set<String>();
        Set<date> dateSetOld = new Set<date>();
        for(Leave_Plan__c lp: trigger.old){
          userIdSetOld.add(lp.User__c);  
          if(lp.Start_Date__c<lp.End_Date__c){
              Date tempDate = lp.Start_Date__c;
              for(integer i=0;tempDate<=lp.End_Date__c;i++){
                  dateSetOld.add(tempDate);
                  tempDate = tempDate.addDays(1); 
              }
          }
          else{
          dateSetOld.add(lp.Start_Date__c);
          //dateSetOld.add(lp.End_Date__c);     
          } 
        }
        List<Custom_Calendar__c> cListUpdateOld = new List<Custom_Calendar__c>();
        for(Custom_Calendar__c cc : [SELECT Id,On_Leave__c  FROM Custom_Calendar__c WHERE User__c IN: userIdSetOld AND On_Leave__c = True AND Calendar_Date__c IN: dateSetOld]){
            cc.On_Leave__c  = False;
            cListUpdateOld.add(cc);
        }
        if(cListUpdateOld.size()>0){
            Database.update(cListUpdateOld);
        }
    }
    
}