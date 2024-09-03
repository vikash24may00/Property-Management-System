public class MaintenanceNotificationService {
    @future(callout=false)
    public static void sendMaintenanceNotification(Set<Id> tenantIds) 
    {
        // Query the Tenant records based on the provided tenant IDs
        List<Tenant__c> tenants = [SELECT Id, Name, Contact_Info__c FROM Tenant__c WHERE Id IN :tenantIds];
        
        // List to hold the email messages that will be sent
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        // Iterate over the queried tenants and prepare email messages
        for (Tenant__c tenant : tenants) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            // Set the recipient address for the email
            mail.setToAddresses(new String[] { tenant.Contact_Info__c });
            
            // Set the subject of the email
            mail.setSubject('Upcoming Maintenance Notification');
            
            // Set the body of the email
            mail.setPlainTextBody('Dear ' + tenant.Name + ',\n\nThis is a reminder that you have an upcoming maintenance task scheduled tommorow.');
            
            // Add the email message to the list of emails to be sent
            emails.add(mail);
        }
        
        // Check if there are any emails to be sent
        if (!emails.isEmpty()) {
            // Send all the email messages in a single call
            Messaging.sendEmail(emails);
        }
    }
}