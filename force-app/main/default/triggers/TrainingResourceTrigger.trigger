/**
 * @description Trigger class for training resource object
 */
trigger TrainingResourceTrigger on Training_Resource__c (before insert, after insert) {
    TrainingResourceTriggerHandler handler = new TrainingResourceTriggerHandler();
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            handler.onBeforeInsert(Trigger.new);
        } else {
            handler.onAfterInsert(Trigger.new);
        }
    }
}