/**
 * @description Class for operations related to the home page.
 */
public with sharing class HomepageController {
    /**
     * @description Method to return list of training resources assigned to an employee
     * @param employeeId holds employee's Id
     * @return list of training resources
     */
    @AuraEnabled
    public static List<Training_Resource__c> fetchTrainingResources(Id employeeId){
        try {
            List<Training_Resource__c> trainingResources = [SELECT Id, Employee__c, Resource__c FROM Training_Resource__c WHERE Employee__c =: employeeId];
            return trainingResources;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}