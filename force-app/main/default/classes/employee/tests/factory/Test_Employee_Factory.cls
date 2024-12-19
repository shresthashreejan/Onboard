/**
 * @description Factory class for Employee
 */
@isTest
public class Test_Employee_Factory {

    /**
     * @description Method to insert employee record
     */
    public void insertEmployee() {

        Department__c department = new Department__c(
            Name = 'insertEmployee'
        );
        insert department;

        Employee__c employee = new Employee__c(
            First_Name__c = 'insertEmployee',
            Last_Name__c = '0',
            Email__c = 'insertEmployee@employee.com',
            Department__c = department.Id,
            Role__c = 'Intern'
        );
        insert employee;
    }

    /**
     * @description Method to create employee record with manager and resource record
     */
    public void createEmployeeWithManagerAndResource() {
        Department__c department = new Department__c(
            Name = 'createEmployeeWithManagerAndResource'
        );
        insert department;

        Manager__c manager = new Manager__c(
            First_Name__c = 'createEmployeeWithManagerAndResource',
            Last_Name__c = '0',
            Email__c = 'createEmployeeWith@manager.com'
        );
        insert manager;

        Employee__c employee = new Employee__c(
            First_Name__c = 'createEmployeeWithManagerAndResource',
            Last_Name__c = '0',
            Email__c = 'createEmployeeWith@employee.com',
            Department__c = department.Id,
            Role__c = 'Intern',
            Manager__c = manager.Id
        );
        insert employee;

        Resource__c resource = new Resource__c(
            Name = 'createEmployeeWithManagerAndResource'
        );
        insert resource;
    }
}