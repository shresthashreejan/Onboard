/**
 * @description Trigger class for manager object
 */
trigger ManagerTrigger on Manager__c (before insert, after insert) {
    ManagerTriggerHandler handler = new ManagerTriggerHandler();
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            handler.onBeforeInsert(Trigger.new);
        } else {
            handler.onAfterInsert(Trigger.new);
        }
    }
}