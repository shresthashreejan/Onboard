/**
 * @description Utility class with generic methods for use across the codebase.
 */
public class Utility {

    /**
     * @description Generic method to send welcome email upon user creation.
     */
    public static void sendWelcomeEmail(String toAddress, String firstName) {
        String companyName = 'Onboard';
        String subject = 'Welcome to ' + companyName + '!';
        String plainTextBody = 'Welcome ' + firstName + '!\n' +
                               'We are excited to have you on board.\n' +
                               'Please contact your HR to reset your password and log in to the Onboard platform to streamline your onboarding process.\n' +
                               'Best Regards,\n' + companyName;
        EmailService.sendWelcomeEmail(toAddress, subject, plainTextBody);
    }

    /**
     * @description Generic method to create and link users to parent record.
     */
    public static void createUsersForEntities(List<SObject> entities, String profileName) {
        List<Schema.User> users = new List<Schema.User>();
        Map<String, String> firstNameAndAddress = new Map<String, String>();
        Id profileId = [SELECT Id FROM Profile WHERE Name = :profileName WITH SECURITY_ENFORCED].Id;
    
        for(SObject entity : entities) {
            String firstName = (String) entity.get('First_Name__c');
            String lastName = (String) entity.get('Last_Name__c');
            String email = (String) entity.get('Email__c');
    
            // Truncate first name to 8 characters for alias
            String alias = firstName.length() > 8 ? firstName.substring(0, 8) : firstName;
    
            users.add(new Schema.User(
                Username = email,
                Email = email,
                FirstName = firstName,
                LastName = lastName,
                Alias = alias,
                CommunityNickname = email,
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                ProfileId = profileId
            ));
    
            firstNameAndAddress.put(firstName, email);
        }
    
        insert users;

        for (String firstName : firstNameAndAddress.keySet()) {
            sendWelcomeEmail(firstNameAndAddress.get(firstName), firstName);
        }
    }
}