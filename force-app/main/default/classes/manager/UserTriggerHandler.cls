/**
 * @description Trigger handler class for user object
 */
public with sharing class UserTriggerHandler {
    public void onAfterInsert(List<Schema.User> users){
        User.updateEntityUserId(users);
    }
}