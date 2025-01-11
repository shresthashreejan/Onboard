/**
 * @description Class for operations related to the user object
 */
public with sharing class User {
    /**
     * @description Method to update entity's user id field
     */
    public static void updateEntityUserId (List<Schema.User> users) {
        Map<String, Id> emailToUserIdMap = new Map<String, Id>();

        for (Schema.User user : users) {
            emailToUserIdMap.put(user.Email, user.Id);
        }

        List<Employee__c> employees = [
            SELECT Id, User_Id__c, Email__c 
            FROM Employee__c 
            WHERE Email__c IN :emailToUserIdMap.keySet()
        ];

        List<Manager__c> managers = [
            SELECT Id, User_Id__c, Email__c 
            FROM Manager__c 
            WHERE Email__c IN :emailToUserIdMap.keySet()
        ];

        if(employees.size() > 0) {
            for (Employee__c employee : employees) {
                if (emailToUserIdMap.containsKey(employee.Email__c)) {
                    employee.User_Id__c = emailToUserIdMap.get(employee.Email__c);
                }
            }
            update employees;
        }

        if(managers.size() > 0) {
            for (Manager__c manager : managers) {
                if (emailToUserIdMap.containsKey(manager.Email__c)) {
                    manager.User_Id__c = emailToUserIdMap.get(manager.Email__c);
                }
            }
            update managers;
        }
    }
}