/**
 * @description Class for operations related to the manager object.
 */
public with sharing class Manager {
    
    public static void createUsersForManagers (List<Manager__c> managers) {
        
        List<User> users = new List<User>();
        Map<String, String> firstNameAndAddress = new Map<String, String>();
        Id profileId = [SELECT Id FROM Profile WHERE Name = 'Standard Platform User' WITH SECURITY_ENFORCED].Id;

        for(Manager__c manager : managers) {
            users.add(new User(
                Username = manager.Email__c,
                Email = manager.Email__c,
                FirstName = manager.First_Name__c,
                LastName = manager.Last_Name__c,
                Alias = manager.First_Name__c,
                CommunityNickname = manager.Email__c,
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = profileId
            ));
            firstNameAndAddress.put(manager.First_Name__c, manager.Email__c);
        }
        
        insert users;

        for (String firstName : firstNameAndAddress.keySet()) {
            Utility.sendWelcomeEmail(firstNameAndAddress.get(firstName), firstName);
        }
    }
}