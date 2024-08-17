/**
 * @description Trigger handler class for manager object
 */
public with sharing class ManagerTriggerHandler {
    
    public void onBeforeInsert(List<Manager__c> managers){
        System.debug('Manager onBeforeInsert');
    }

    public void onAfterInsert(List<Manager__c> managers){
        Manager.createUsersForManagers(managers);
    } 
}