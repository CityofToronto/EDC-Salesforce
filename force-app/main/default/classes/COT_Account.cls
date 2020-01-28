public with sharing class COT_Account {
    @AuraEnabled
    public static void convertPersonToBusinessAccount (string accountId)
    {
        String businessAccountRecordTypeId = [SELECT Id FROM recordtype WHERE sObjectType='Account' 
            AND Developername = 'Business_Account'].Id;

        Account a  = [SELECT Id,recordTypeId from Account WHERE Id = :accountId];
        a.recordTypeId = businessAccountRecordTypeId;
        update a;
    }
}