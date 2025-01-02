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

    /**
     * @description Method to fetch resources based on employee's department
     * @param department holds employee's department
     * @param role holds employee's role
     * @return Map<String, List<Resource__c>> where string is the role identifier
     */
    @AuraEnabled
    public static Map<String, List<Resource__c>> fetchResources(String department, String role){
        try {
            Map<String, List<Resource__c>> response = new Map<String, List<Resource__c>>();
            List<Resource__c> roleSpecifiedResources = new List<Resource__c>();
            List<Resource__c> generalResources = new List<Resource__c>();
            
            List<Resource__c> resources = [SELECT Id, Name, Role__c FROM Resource__c WHERE Department__c =: department AND File_Linked__c = true];
            for(Resource__c resource : resources) {
                if(!String.isEmpty(role) && resource.Role__c == role){
                    roleSpecifiedResources.add(resource);
                } else if(String.isEmpty(resource.Role__c)){
                    generalResources.add(resource);
                }
            }
            if(roleSpecifiedResources.size() > 0 || generalResources.size() > 0){
                response = new Map<String, List<Resource__c>>{
                    'roleSpecified' => roleSpecifiedResources,
                    'general' => generalResources
                };
            }
            return response;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}