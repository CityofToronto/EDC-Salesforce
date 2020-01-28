@isTest
public with sharing class COT_UtilityTest {
    static testMethod void testGetRecordTypes() {
        List<COT_Utility.CRecordType> types = COT_Utility.getRecordTypes('Interaction__c','');
        system.assert(types.size()>1);

        types = COT_Utility.getRecordTypes('Interaction__c','Company Intelligence');
        system.assert(types.size()==1);

        String recTypeId = COT_Utility.getDefaultRecordType('Interaction__c');
        RecordType r = [select Id from RecordType where sObjectType = 'Interaction__c' and Name ='Company Intelligence'  limit 1];
        system.assertEquals(r.Id,recTypeId);

    }
}