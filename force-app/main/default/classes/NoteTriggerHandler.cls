public with sharing class NoteTriggerHandler {
     public void OnAfterInsert(List<Note> notes) {

         //There are forms in Form Assembly adding attachments to a record.
         //This method used to convert Note to Content. File will be displayed in Lightning Files related list

         List<ContentNote> contentNotes = new List<ContentNote>();
         List<ContentDocumentLink> ContentDocumentLinks = new List<ContentDocumentLink>();
         List<Id> noteIds = new List<Id>();
         list<Id> noteParentIds = new List<Id>();

         for (Note a : notes)
         {
            ContentNote cnt = new ContentNote();
            cnt.Content = Blob.valueOf(a.Body);
            cnt.Title = a.Title;

            ContentNotes.add(cnt);

            noteIds.add(a.Id);
            noteParentIds.add(a.parentId);
         }

        insert contentNotes;

        for (integer i =0;i<contentNotes.size();i++)
        {
            ContentDocumentLink clnk = new ContentDocumentLink();
            clnk.LinkedEntityId = noteParentIds[i];
            clnk.ContentDocumentId = contentNotes[i].Id;
            clnk.ShareType = 'I';
            ContentDocumentLinks.add(clnk);
        }

        insert ContentDocumentLinks;

        Delete [Select Id from note where id in : noteIds];

     }
}