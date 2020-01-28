/**
* @File Name:  FinIncStarterCompanyInboundEmail.cls
* @Description:   Email Logging Integration
* Provides an entry point to manage the inbound emails sent to Email Service and attach to Financial Incentive Record
* @Author:    Manish 
* @Group:     Apex
* @Last Modified by:   Manish Gaur
* @Last Modified time: 2019-09-09
* @Modification Log  :
*-------------------------------------------------------------------------------------
* Ver       Date        Author         Modification
* 1.0       2019-09-09  Manish Gaur    Created the file/class
* 1.1       2019-11-18  DZ             Change inserting Note to ContentNot for Lightning Conversion
*/
global class FinIncStarterCompanyInboundEmail implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
                                                    Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        String emailSubject = email.subject;
        String startrCompRecord = 'FIN'+ (emailSubject.substringAfter('FIN')).substring(0,16);
        Financial_Incentive__c finRecord ;
        List<ContentDocumentLink> contentFileList = new List<ContentDocumentLink>();
        
        try{
            if(startrCompRecord!=null && startrCompRecord.length()==19){
                
                //Get the Starter Company Record based on unique record Name
                finRecord = [SELECT Id,Status__c,Financial_Incentive_Name__c FROM Financial_Incentive__c WHERE Financial_Incentive_Name__c=:startrCompRecord];
                
                if(finRecord!=null){
                    
                    finRecord.Status__c='Document Received';
                    update finRecord;
                          

                    ContentNote cnt = new ContentNote();
                    cnt.Content = Blob.valueOf(email.htmlBody);
                    cnt.Title = 'Email From -'+email.fromAddress + ' (' + DateTime.now() + ')';
                    insert cnt;

                    ContentDocumentLink clnk = new ContentDocumentLink();
                    clnk.LinkedEntityId = finRecord.Id;
                    clnk.ContentDocumentId = cnt.Id;
                    clnk.ShareType = 'I';
                    insert clnk;
                    
                    /*
                    Note note = new Note();
                    note.Title = 'Email From -'+email.fromAddress + ' (' + DateTime.now() + ')';
                    note.Body = email.plainTextBody;
                    note.ParentId = finRecord.Id;
                    insert note;
                    */

                    // Save any Text Attachment
                    if(email.textAttachments!=null && email.textAttachments.size()>0) {
                        for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
                            ContentVersion cv = new ContentVersion();
                            cv.VersionData =  Blob.valueOf(tAttachment.body);
                            cv.Title = tAttachment.fileName;
                            cv.PathOnClient = tAttachment.fileName;
                            insert cv;
                     
                            cv = [select ContentDocumentId from ContentVersion where id = :cv.id limit 1];
                            ContentDocumentLink cdl1 = new ContentDocumentLink();
                            cdl1.LinkedEntityId = finRecord.Id;
                            cdl1.ContentDocumentId = cv.ContentDocumentId;
                            cdl1.ShareType = 'V';
                            contentFileList.add(cdl1);
                        }
                    }
                    //Save any Binary Attachment
                    if(email.binaryAttachments!=null){
                        for (Messaging.Inboundemail.BinaryAttachment bAttachment : email.binaryAttachments) {
                            if(bAttachment.body.size()>0){
                                ContentVersion cv = new ContentVersion();
                                cv.VersionData = bAttachment.body;
                                cv.Title = bAttachment.fileName;
                                cv.PathOnClient = bAttachment.fileName;
                                insert cv;
                         
                                cv = [select ContentDocumentId from ContentVersion where id = :cv.id limit 1];
                                ContentDocumentLink cdl2 = new ContentDocumentLink();
                                cdl2.LinkedEntityId = finRecord.Id;
                                cdl2.ContentDocumentId = cv.ContentDocumentId;
                                cdl2.ShareType = 'V';
                                contentFileList.add(cdl2);
                            }
                        }
                    }
                }
                if(!contentFileList.isEmpty()){
                    insert contentFileList;
                }
           }
        }
        catch (Exception e) {
            result.success = false;
            result.message = 'Relevant Starter Company Record not Found : '+e.getMessage();
        }
        return result;
    }
}