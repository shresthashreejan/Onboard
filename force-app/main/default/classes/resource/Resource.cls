/**
 * @description Class for operations related to resource object.
 */
public with sharing class Resource {

    // Constants
    public static String OBJECT_API_NAME = 'Resource__c';

    /**
     * @description Method to commit file upload changes on resource record.
     */
    @AuraEnabled
    public static void commitUploadChanges(Id recordId, String contentId) {
        try {
            Resource__c rsc = [SELECT Id, Content_Id__c, File_Linked__c FROM Resource__c WHERE Id =: recordId WITH SECURITY_ENFORCED];
            rsc.Content_Id__c = contentId;
            rsc.File_Linked__c = true;
            update rsc;
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }

    /**
     * @description Method to fetch content Id associated with the resource.
     */
    @AuraEnabled
    public static string fetchContentId(Id recordId){
        try {
            return [SELECT Id, Content_Id__c FROM Resource__c WHERE Id =: recordId WITH SECURITY_ENFORCED].Content_Id__c;
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
}