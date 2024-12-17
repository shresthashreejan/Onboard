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
            Name = 'Engineering'
        );
        insert department;

        Employee__c employee = new Employee__c(
            First_Name__c = 'insertEmployee',
            Last_Name__c = '0',
            Email__c = 'insertEmployee@insertEmployee.com',
            Department__c = department.Id,
            Role__c = 'Intern'
        );
        insert employee;
    }
}