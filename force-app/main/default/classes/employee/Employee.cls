/**
 * @description Class for operations related to the employee object.
 */
public with sharing class Employee {
    /**
     * @description Method to create users for employees
     */
    public static void createUsersForEmployees (List<Employee__c> employees) {
        
        List<User> users = new List<User>();
        Map<String, String> firstNameAndAddress = new Map<String, String>();
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' WITH SECURITY_ENFORCED].Id;
        
        for(Employee__c employee : employees) {
            users.add(new User(
                Username = employee.Email__c,
                Email = employee.Email__c,
                FirstName = employee.First_Name__c,
                LastName = employee.Last_Name__c,
                Alias = employee.First_Name__c,
                CommunityNickname = employee.Email__c,
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = profileId
            ));
            firstNameAndAddress.put(employee.First_Name__c, employee.Email__c);
        }

        insert users;

        for (String firstName : firstNameAndAddress.keySet()) {
            Utility.sendWelcomeEmail(firstNameAndAddress.get(firstName), firstName);
        }
    }

    /**
     * @description Method to assign resources to employees based on their roles
     */
    public static void assignResourcesBasedOnRole(List<Employee__c> employees) {
        Set<String> roleSet = new Set<String>();
        for(Employee__c employee : employees) {
            roleSet.add(employee.Role__c);
        }

        List<String> roles = new List<String>(roleSet);
        Map<String, Id> roleToResourceMap = new Map<String, Id>();
        for (Resource__c resource : [SELECT Id, Role__c FROM Resource__c WHERE Role__c IN: roles WITH SECURITY_ENFORCED]) {
            roleToResourceMap.put(resource.Role__c, resource.Id);
        }

        for (Employee__c employee : employees) {
            if(employee.Role__c != null && roleToResourceMap.containsKey(employee.Role__c)) {
                employee.Resource__c = roleToResourceMap.get(employee.Role__c);
            }
        }
        update employees;
    }
}