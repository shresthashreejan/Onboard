/**
 * @description Trigger handler class for training resource object
 */
public with sharing class TrainingResourceTriggerHandler {
    
    public void onBeforeInsert(List<Training_Resource__c> trainingResources){
        TrainingResource.preventDuplicateResourceAssignment(trainingResources);
    }

    public void onAfterInsert(List<Training_Resource__c> trainingResources){
        System.debug('trainingResources onAfterInsert');
    } 
}