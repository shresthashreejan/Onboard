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
    public static void commitUploadChanges(Id recordId, String fileName) {
        try {
            Resource__c rsc = [SELECT Id, File_Name__c, File_Linked__c FROM Resource__c WHERE Id =: recordId];
            rsc.File_Name__c = fileName;
            rsc.File_Linked__c = true;
            update rsc;
        } catch (Exception e) {
            throw new AuraHandledException('Error: ' + e.getMessage());
        }
    }
}