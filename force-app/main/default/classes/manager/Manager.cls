/**
 * @description Class for operations related to the manager object
 */
public with sharing class Manager {
    public static void createUsersForManagers (List<Manager__c> managers) {
        
        List<User> users = new List<User>();
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' WITH SECURITY_ENFORCED].Id;
        
        for(Manager__c manager : managers) {
            users.add(new User(
                Username = manager.Email__c,
                Email = manager.Email__c,
                FirstName = manager.First_Name__c,
                LastName = manager.Last_Name__c,
                Alias = manager.First_Name__c,
                CommunityNickname = 'PlatformUser',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = profileId
            ));
        }

        insert users;
    }
}