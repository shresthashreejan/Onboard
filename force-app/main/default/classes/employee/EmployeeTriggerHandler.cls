/**
 * @description Trigger handler class for employee object
 */
public with sharing class EmployeeTriggerHandler {
    public void onAfterInsert(List<Employee__c> employees){
        Employee.createUsersForEmployees(employees);
        Employee.assignResourcesBasedOnRoleAndDepartment(employees);
    }
}