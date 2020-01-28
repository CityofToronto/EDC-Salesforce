global class DeleteBlankOutcomeSurveyRecords implements Schedulable{
    global void execute(SchedulableContext SC) {
        List<Client_FollowUp__c> busOutcomeSurveyList = [SELECT Id FROM Client_FollowUp__c WHERE Event__c = '' AND Interaction__c = '' AND Online_Registration__c = '' AND Contact__c = '' LIMIT 100];
        if(!busOutcomeSurveyList.isEmpty() && busOutcomeSurveyList.size()>0)
            delete busOutcomeSurveyList;
    }
}