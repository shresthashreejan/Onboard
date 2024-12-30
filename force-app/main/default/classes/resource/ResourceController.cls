/**
 * @description Controller class for resource related operations
 */
public with sharing class ResourceController {
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
            
            List<Resource__c> resources = [SELECT Id, Name, Role__c FROM Resource__c WHERE Department__c =: department];
            for(Resource__c resource : resources) {
                if(resource.Role__c == role){
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