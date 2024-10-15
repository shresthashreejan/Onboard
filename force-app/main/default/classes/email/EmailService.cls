/**
 * @description Class for sending emails to users.
 */
public with sharing class EmailService {

    public static void sendWelcomeEmail(String toAddress, String subject, String body) {
        sendEmail(toAddress, subject, body);
    }

    private static void sendEmail(String toAddress, String subject, String body) {
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] {toAddress});
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
}