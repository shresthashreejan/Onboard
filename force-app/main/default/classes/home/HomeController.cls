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

        Employee__c employee = [SELECT Id FROM Employee__c WHERE User_Id__c = :currentUserId];
        Manager__c manager = [SELECT Id FROM Manager__c WHERE User_Id__c = :currentUserId];

        if(employee != null) {
            response = (List<SObject>) fetchTrainingResources(employee.Id);
        } else if(manager != null) {
            response = (List<SObject>) fetchEmployees(manager.Id);
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
            return [SELECT Id, Employee__c, Resource__c, Resource__r.Name FROM Training_Resource__c WHERE Employee__c =: employeeId];
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