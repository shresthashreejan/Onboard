/**
 * @description Trigger class for employee object
 */
trigger EmployeeTrigger on Employee__c (after insert) {
    EmployeeTriggerHandler handler = new EmployeeTriggerHandler();

    if (Trigger.isInsert) {
        if(Trigger.isBefore) {
            System.debug('Employee onBeforeInsert');
        } else {
            handler.onAfterInsert(Trigger.new);
        }
    }
}