/**
 * @description Test class for Employee.cls
 */
@isTest
public class Test_Employee {

    /**
     * @description Test data setup
     */
    @TestSetup
    static void setupData(){
        Test_Employee_Factory factory = new Test_Employee_Factory();
        factory.insertEmployee();
    }

    /**
     * @description givenEmployee_WhenInserted_ThenUserShouldBeCreated
     * GIVEN: Employee record
     * WHEN: Inserted
     * THEN: User should be created for the employee
     */
    @isTest
    public static void givenEmployee_WhenInserted_ThenUserShouldBeCreated() {
        // ARRANGE: Query created employee
        Employee__c employee = [SELECT Id, First_Name__c, Last_Name__c, Email__c FROM Employee__c WHERE First_Name__c = 'insertEmployee' WITH SECURITY_ENFORCED];

        // ARRANGE: Query user record
        User user = [SELECT Id, Email, FirstName, LastName FROM User WHERE FirstName = :employee.First_Name__c AND Email = :employee.Email__c WITH SECURITY_ENFORCED];

        // ASSERT: Ensure user record is created for the employee
        System.assertNotEquals(null, user, 'User should be created for the employee.');
        System.assertEquals(employee.First_Name__c, user.FirstName, 'First names should match.');
        System.assertEquals(employee.Last_Name__c, user.LastName, 'Last names should match.');
        System.assertEquals(employee.Email__c, user.Email, 'Email addresses should match.');
    }
}