/**
 * @description Test class for Manager.cls
 */
@isTest
public class Test_Manager {

    /**
     * @description Test data setup
     */
    @TestSetup
    static void setupData(){
        Test_Manager_Factory factory = new Test_Manager_Factory();
        factory.insertManager();
    }

    /**
     * @description givenManager_WhenInserted_ThenUserShouldBeCreated
     * GIVEN: Manager record
     * WHEN: Inserted
     * THEN: User should be created for the manager
     */
    @isTest
    public static void givenManager_WhenInserted_ThenUserShouldBeCreated() {
        // ARRANGE: Query created manager
        Manager__c manager = [SELECT Id, First_Name__c, Last_Name__c FROM Manager__c WHERE First_Name__c = 'insertManager' WITH SECURITY_ENFORCED];

        // ARRANGE: Query user record
        Schema.User user = [SELECT Id, Email, FirstName, LastName FROM User WHERE FirstName = :manager.First_Name__c WITH SECURITY_ENFORCED];

        // ASSERT: Ensure user record is created for the manager
        System.assertNotEquals(null, user, 'User should be created for the manager.');
        System.assertEquals(manager.First_Name__c, user.FirstName, 'First names should match.');
        System.assertEquals(manager.Last_Name__c, user.LastName, 'Last names should match.');
    }
}