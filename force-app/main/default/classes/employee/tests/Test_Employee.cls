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
        factory.createDepartment();
        factory.createDepartmentAndResource();
    }

    /**
     * @description givenEmployee_WhenInserted_ThenUserShouldBeCreated
     * GIVEN: Department record
     * WHEN: Employee is inserted
     * THEN: User should be created for the employee
     */
    @isTest
    public static void givenDepartment_WhenEmployeeIsInserted_ThenUserShouldBeCreated() {
        // ARRANGE: Query created department
        Department__c department = [SELECT Id FROM Department__c WHERE Name = 'createDepartment' WITH SECURITY_ENFORCED];

        // ARRANGE: Query created manager
        Manager__c manager = [SELECT Id FROM Manager__c WHERE First_Name__c = 'createDepartment' WITH SECURITY_ENFORCED];

        // ACT: Insert employee
        Employee__c employee = new Employee__c(
            First_Name__c = 'createDepartment',
            Last_Name__c = '0',
            Email__c = 'employee001@email.com',
            Department__c = department.Id,
            Role__c = 'Intern',
            Manager__c = manager.Id
        );
        insert employee;

        // ASSERT: Ensure user record is created for the employee
        Schema.User user = [SELECT Id, Email, FirstName, LastName FROM User WHERE FirstName = :employee.First_Name__c AND Email = :employee.Email__c WITH SECURITY_ENFORCED];
        System.assertNotEquals(null, user, 'User should be created for the employee.');
        System.assertEquals(employee.First_Name__c, user.FirstName, 'First names should match.');
        System.assertEquals(employee.Last_Name__c, user.LastName, 'Last names should match.');
        System.assertEquals(employee.Email__c, user.Email, 'Email addresses should match.');
    }

    /**
     * @description givenDepartmentAndResource_WhenEmployeeIsInserted_ThenResourcesShouldBeInserted
     * GIVEN: Department and resource records
     * WHEN: Employee is inserted
     * THEN: Training resources should be inserted
     */
    @isTest
    public static void givenDepartmentAndResource_WhenEmployeeIsInserted_ThenResourcesShouldBeInserted() {
        // ARRANGE: Query created department
        Department__c department = [SELECT Id FROM Department__c WHERE Name = 'createDepartmentAndResource' WITH SECURITY_ENFORCED];

        // ARRANGE: Query created manager
        Manager__c manager = [SELECT Id FROM Manager__c WHERE First_Name__c = 'createDepartmentAndResource' WITH SECURITY_ENFORCED];

        // ARRANGE: Query created resource
        Resource__c resource = [SELECT Id FROM Resource__c WHERE Name = 'createDepartmentAndResource' WITH SECURITY_ENFORCED];

        // ACT: Insert employee
        Employee__c employee = new Employee__c(
            First_Name__c = 'createDepartmentAndResource',
            Last_Name__c = '0',
            Email__c = 'employee002@employee.com',
            Department__c = department.Id,
            Role__c = 'Intern',
            Manager__c = manager.Id
        );
        insert employee;

        // ASSERT: Ensure training resource is inserted
        Training_Resource__c trainingResource = [SELECT Id, Employee__c, Resource__c FROM Training_Resource__c WHERE Employee__c =: employee.Id AND Resource__c =: resource.Id WITH SECURITY_ENFORCED];
        System.assertEquals(true, trainingResource != null, 'Training resource should be inserted.');
    }
}