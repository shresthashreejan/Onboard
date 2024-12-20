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
            // Truncating first name to 8 characters for alias
            String alias = employee.First_Name__c.length() > 8 ? employee.First_Name__c.substring(0, 8) : employee.First_Name__c;
            users.add(new User(
                Username = employee.Email__c,
                Email = employee.Email__c,
                FirstName = employee.First_Name__c,
                LastName = employee.Last_Name__c,
                Alias = alias,
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
     * @description Method to assign resources to employees based on their role and department
     */
    public static void assignResourcesBasedOnRoleAndDepartment(List<Employee__c> employees) {
        List<String> roles = new List<String>();
        List<String> departments = new List<String>();
        for(Employee__c employee : employees) {
            if(employee.Role__c != null && employee.Department__c != null) {
                roles.add(employee.Role__c);
                departments.add(employee.Department__c);
            }
        }

        List<Training_Resource__c> trainingResources = new List<Training_Resource__c>(); 
        for (Resource__c resource : [SELECT Id, Role__c, Department__c FROM Resource__c WHERE Role__c IN: roles AND Department__c IN: departments WITH SECURITY_ENFORCED]) {
            for (Employee__c employee : employees) {
                if(resource.Role__c == employee.Role__c && resource.Department__c == employee.Department__c) {
                     trainingResources.add(new Training_Resource__c(Employee__c = employee.Id, Resource__c = resource.Id));
                }
            }
        }

        if(trainingResources.size() > 0) {
            insert trainingResources;
        }
    }
}