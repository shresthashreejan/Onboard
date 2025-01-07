/**
 * @description Class for operations related to the home page.
 */
public with sharing class HomepageController {

    /**
     * @description Method to return list of training resources or employees based on current user
     * @return list of sobjects
     */
    @AuraEnabled(cacheable=true)
    public static List<SObject> fetchList() {
        List<SObject> response = new List<SObject>();
        Id currentUserId = UserInfo.getUserId();

        List<SObject> userRoles = [SELECT Id, (SELECT Id FROM Manager__r), (SELECT Id FROM Employee__r) FROM User WHERE Id =: currentUserId];

        if (!userRoles.isEmpty()) {
            SObject userRole = userRoles[0];
            if (!userRole.getSObjects('Manager__r').isEmpty()) {
                response = (List<SObject>) fetchEmployees(userRole.getSObjects('Manager__r')[0].Id);
            } else if (!userRole.getSObjects('Employee__r').isEmpty()) {
                response = (List<SObject>) fetchTrainingResources(userRole.getSObjects('Employee__r')[0].Id);
            }
        }
        return response;
    }

    /**
     * @description Method to return list of training resources assigned to an employee
     * @param userId holds employee's Id
     * @return list of training resources
     */
    public static List<Training_Resource__c> fetchTrainingResources(Id userId){
        try {
            return [SELECT Id, Employee__c, Resource__c, Resource__r.Name FROM Training_Resource__c WHERE Employee__c =: userId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Method to return list of employees under the specified manager
     * @param userId holds manager's Id
     * @return list of employees
     */
    public static List<Employee__c> fetchEmployees(Id userId){
        try {
            return [SELECT Id, Name, Manager__c FROM Employee__c WHERE Manager__c =: userId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}