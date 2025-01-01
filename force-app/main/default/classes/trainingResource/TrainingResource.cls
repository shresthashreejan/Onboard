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
}