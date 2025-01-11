/**
 * @description Controller class for home page
 */
public with sharing class HomeController {
    /**
     * @description Method to return list of training resources or employees based on current user
     * @return list of sobjects
     */
    @AuraEnabled(cacheable=true)
    public static List<SObject> fetchList() {
        List<SObject> response = new List<SObject>();
        Id currentUserId = UserInfo.getUserId();

        Map<Id, Employee__c> employeeMap = new Map<Id, Employee__c>([SELECT Id FROM Employee__c WHERE User_Id__c = :currentUserId LIMIT 1]);
        Map<Id, Manager__c> managerMap = new Map<Id, Manager__c>([SELECT Id FROM Manager__c WHERE User_Id__c = :currentUserId LIMIT 1]);

        if (!employeeMap.isEmpty()) {
            response = fetchTrainingResources(employeeMap.keySet().iterator().next());
        } else if (!managerMap.isEmpty()) {
            response = fetchEmployees(managerMap.keySet().iterator().next());
        }
        
        return response;
    }

    /**
     * @description Method to return list of training resources assigned to an employee
     * @param userId holds employee's Id
     * @return list of training resources
     */
    public static List<Training_Resource__c> fetchTrainingResources(Id employeeId){
        try {
            return [SELECT Id, Resource__c, Resource__r.Name FROM Training_Resource__c WHERE Employee__c =: employeeId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Method to return list of employees under the specified manager
     * @param userId holds manager's Id
     * @return list of employees
     */
    public static List<Employee__c> fetchEmployees(Id managerId){
        try {
            return [SELECT Id, Name, Manager__c FROM Employee__c WHERE Manager__c =: managerId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}