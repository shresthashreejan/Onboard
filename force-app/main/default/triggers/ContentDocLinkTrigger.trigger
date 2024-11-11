/**
 * @description Trigger class for ContentDocumentLink object.
 */
trigger ContentDocLinkTrigger on ContentDocumentLink (before insert, after insert) {
    ContentDocLinkTriggerHandler handler = new ContentDocLinkTriggerHandler();
    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            handler.onBeforeInsert(Trigger.new);
        }
    }
}