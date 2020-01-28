public with sharing class AttachmentTriggerHandler {
     public void OnAfterInsert(List<Attachment> attachments) {

         //There are forms in Form Assembly adding attachments to a record.
         //This method used to convert attachment to File. File will be displayed in Lightning Files related list

         List<ContentVersion> conVers = new List<ContentVersion>();
         List<Id> attIds = new List<Id>();

         for (Attachment a : attachments)
         {
            ContentVersion conVer = new ContentVersion();
            conVer.ContentLocation = 'S'; // S specify this document is in SF, use E for external files
            conVer.PathOnClient = a.Name; // The files name, extension is very important here which will help the file in preview.
            conVer.Title = a.Name; // Display name of the files
            conVer.VersionData = a.Body; 
            conVer.FirstPublishLocationId  = a.ParentId;

            conVers.add(conVer);

            attIds.add(a.Id);
         }

        insert conVers;

        Delete [Select Id from attachment where id in : attIds];

     }
}