/**
 * @description Trigger handler class for ContentDocument object.
 */
public with sharing class ContentDocumentTriggerHandler {
    public void onBeforeInsert(List<ContentDocument> contentDocs){
        ContentDocument.preventFileUploadIfLinked(contentDocs);
    } 
}