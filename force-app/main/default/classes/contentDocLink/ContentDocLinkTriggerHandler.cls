/**
 * @description Trigger handler class for ContentDocumentLink object.
 */
public with sharing class ContentDocLinkTriggerHandler {
    public void onBeforeInsert(List<ContentDocumentLink> contentDocLinks){
        ContentDocLink.preventFileUploadIfLinked(contentDocLinks);
    } 
}