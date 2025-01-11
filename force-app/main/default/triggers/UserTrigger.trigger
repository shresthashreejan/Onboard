/**
 * @description Trigger class for User object
 */
trigger UserTrigger on User (before insert, after insert) {
    UserTriggerHandler handler = new UserTriggerHandler();
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            System.debug('Before Trigger');
        } else {
            handler.onAfterInsert(Trigger.new);
        }
    }
}