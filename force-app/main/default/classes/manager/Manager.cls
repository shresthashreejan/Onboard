/**
 * @description Class for operations related to the manager object
 */
public with sharing class Manager {
    /**
     * @description Method to create users for managers
     */
    public static void createUsersForManagers (List<Manager__c> managers) {
        Utility.createUsersForEntities(managers, 'Standard Platform User');
    }
}