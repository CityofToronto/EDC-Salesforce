@isTest
public with sharing class AttachmentTriggerHandlerTest {
    static testMethod void testAfterInsertTrigger() {
        Account a = new Account(Name = 'TestAccount');
        insert a;

        Attachment att = new Attachment();
        att.name = 'My att';
        att.body = EncodingUtil.base64Decode('File text');

        att.ParentId = a.Id;
        insert att;

        system.assert([select id from attachment].size() == 0);

        system.assert([select id from ContentVersion].size() == 1);

        system.assert([select id from ContentDocumentLink where LinkedEntityId = :a.Id].size() == 1);
        
    }
}