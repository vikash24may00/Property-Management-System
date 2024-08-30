public class LeaseTriggerHandler {
    public static void updatePropertyStatus(List<Lease__c> leases) {
        // Collect Property Ids from Leases
        Set<Id> propertyIds = new Set<Id>();
        for (Lease__c lease : leases) {
            if (lease.Property__c != null && lease.End_Date__c > Date.today()) {
                propertyIds.add(lease.Property__c);
            }
        }

        // Query the Properties that need to be updated
        List<Property__c> propertiesToUpdate = [SELECT Id, Status__c FROM Property__c WHERE Id IN :propertyIds];

        // Update the Status to 'Leased'
        for (Property__c property : propertiesToUpdate) {
            property.Status__c = 'Leased';
        }

        // Perform the update DML
        if (!propertiesToUpdate.isEmpty()) {
            update propertiesToUpdate;
        }
    }

    public static void handleLeaseExpiration(List<Lease__c> leases) {
        List<Property__c> propertiesToUpdate = new List<Property__c>();
        List<Lease__c> expiredLeases = new List<Lease__c>();

        for (Lease__c lease : leases) {
            if (lease.End_Date__c < Date.today() && lease.Property__c != null) {
                // Update property status to 'Available'
                Property__c property = new Property__c(Id = lease.Property__c);
                property.Status__c = 'Available';
                propertiesToUpdate.add(property);

                // Collect the expired leases for notification
                expiredLeases.add(lease);
            }
        }

        // Update the properties
        if (!propertiesToUpdate.isEmpty()) {
            update propertiesToUpdate;
        }

        // Send email notification for expired leases
        if (!expiredLeases.isEmpty()) {
            sendLeaseExpirationNotification(expiredLeases);
        }
    }

    private static void sendLeaseExpirationNotification(List<Lease__c> expiredLeases) {
        // Create a list of admin email addresses
        List<String> adminEmails = new List<String>{'vikashmundari7@gmail.com'};

        // Prepare email content
        String subject = 'Lease Expiration Notice';
        String body = 'The following leases have expired:\n\n';

        for (Lease__c lease : expiredLeases) {
            body += 'Lease ID: ' + lease.Id + ', Property: ' + lease.Property__c + ', End Date: ' + lease.End_Date__c + '\n';
        }

        // Create and send the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(adminEmails);
                system.debug(adminEmails);
        email.setSubject(subject);
        email.setPlainTextBody(body);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
    }
}