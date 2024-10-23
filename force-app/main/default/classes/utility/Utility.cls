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
}