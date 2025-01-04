/**
 * @description Class for operations related to Training Resource object.
 */
public with sharing class TrainingResource {
    /**
     * @description Method for creating training resource records to assign resources to employees
     * @param employeeId holds employee's Id
     * @param resourceIds holds list of resource Ids
     */
    @AuraEnabled
    public static void assignResources(String employeeId, List<Id> resourceIds){
        try {
            Set<Id> assignedResources = new Set<Id>();
            for(Training_Resource__c rsc : [SELECT Id, Employee__c, Resource__c FROM Training_Resource__c WHERE Employee__c =: employeeId]) {
                assignedResources.add(rsc.Resource__c);
            }

            List<Training_Resource__c> trainingResources = new List<Training_Resource__c>();
            for(String rscId : resourceIds) {
                if(!assignedResources.contains(rscId)) {
                    trainingResources.add(new Training_Resource__c(
                        Employee__c = employeeId,
                        Resource__c = rscId
                    ));
                }
            }
            if(!trainingResources.isEmpty()) {
                insert trainingResources;
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Method to prevent duplicate resource assignment
     * @param trainingResources holds Training_Resource__c records
     */
    public static void preventDuplicateResourceAssignment(List<Training_Resource__c> trainingResources) {

        Set<Id> employeeIds = new Set<Id>();
        for(Training_Resource__c rsc : trainingResources) {
            employeeIds.add(rsc.Employee__c);
        }

        Set<String> existingAssignments = new Set<String>();
        List<Training_Resource__c> queriedResources = [SELECT Id, Employee__c, Resource__c FROM Training_Resource__c WHERE Employee__c IN: employeeIds];
        for(Training_Resource__c rsc : queriedResources) {
            existingAssignments.add(rsc.Employee__c + ':' + rsc.Resource__c);
        }

        for(Training_Resource__c rsc : trainingResources) {
            String key = rsc.Employee__c + ':' + rsc.Resource__c;
            if(existingAssignments.contains(key)) {
                rsc.addError('Resource is already assigned.');
            }
        }
    }

    /**
     * @description Method to return resource record's content id
     * @param recordId holds training resource record id
     * @return content id in string format
     */
    @AuraEnabled
    public static Map<String, String> fetchContentId(Id recordId){
        try {
            Training_Resource__c rsc = [SELECT Id, Resource__r.Name, Resource__r.Content_Id__c FROM Training_Resource__c WHERE Id =: recordId];
            return new Map<String, String> {
                'name' => rsc.Resource__r.Name,
                'contentId' => rsc.Resource__r.Content_Id__c
            };
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Method to complete training resource
     * @param recordId holds training resource record id
     */
    @AuraEnabled
    public static void completeTraining(Id recordId) {
        try {
            Training_Resource__c rsc = [SELECT Id, Complete__c FROM Training_Resource__c WHERE Id =: recordId];
            rsc.Complete__c = true;
            update rsc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}