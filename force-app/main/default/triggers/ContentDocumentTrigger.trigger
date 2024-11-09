/**
 * @description Trigger class for ContentDocument object.
 */
trigger ContentDocumentTrigger on ContentDocument (before insert, after insert) {
    ContentDocumentTriggerHandler handler = new ContentDocumentTriggerHandler();
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            handler.onBeforeInsert(Trigger.new);
        }
    }
}