/**
 * @description Factory class for Manager
 */
@isTest
public class Test_Manager_Factory {

    /**
     * @description Method to insert manager record
     */
    public void insertManager() {
        Manager__c manager = new Manager__c(
            First_Name__c = 'insertManager',
            Last_Name__c = '0',
            Email__c = 'inserManager@insertManager.com'
        );
        insert manager;
    }
}