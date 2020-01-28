@isTest
public with sharing class NoteTriggerHandlerTest {
    static testMethod void testAfterInsertTrigger() {

        integer cnt = [select id from ContentNote].size();


        Account a = new Account(Name = 'TestAccount');
        insert a;

        Note att = new Note();
        att.Title = 'My note';
        att.body = 'File text';

        att.ParentId = a.Id;
        insert att;

        system.assert([select id from note].size() == 0);

        system.assertEquals([select id from ContentNote].size() - cnt,1);

        system.assert([select id from ContentDocumentLink where LinkedEntityId = :a.Id].size() == 1);
        
    }
}