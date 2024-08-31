@IsTest
public class LeaseTriggerHandlerTest {
    @IsTest
    static void testUpdatePropertyStatus() {
        // Create test properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            Property__c property = new Property__c(Name = 'Test Property ' + i, Status__c = 'Available');
            properties.add(property);
        }
        insert properties;

        // Create test leases
        List<Lease__c> leases = new List<Lease__c>();
        for (Integer i = 0; i < 10; i++) {
            Lease__c lease = new Lease__c(Property__c = properties[i].Id, End_Date__c = Date.today().addDays(1), Status__c = 'Active');
            leases.add(lease);
        }
        insert leases;

        // Call the method under test
        LeaseTriggerHandler.updatePropertyStatus(leases);

        // Verify the properties were updated
        List<Property__c> updatedProperties = [SELECT Id, Status__c FROM Property__c WHERE Id IN :properties];
        for (Property__c property : updatedProperties) {
            System.assertEquals('Leased', property.Status__c);
        }
            Lease__c lease = new Lease__c(End_Date__c = Date.today().addDays(-1), Status__c = 'Active');
            leases.add(lease);
    }

    @IsTest
    static void testHandleLeaseExpiration() {
        // Create test leases
        List<Lease__c> leases = new List<Lease__c>();
        for (Integer i = 0; i < 10; i++) {
        insert leases;
        // Call the method under test
        LeaseTriggerHandler.handleLeaseExpiration(leases);
        // Verify the properties were updated
        List<Lease__c> updatedLeases = [SELECT Id, Status__c FROM Lease__c WHERE Id IN :leases];
        for (Lease__c lease : updatedLeases) {
            System.assertEquals('Expired', lease.Status__c);
        }

        // Verify the email was sent
        /*Messaging.SingleEmailMessage[] emails = Messaging.getSentEmails();
        System.assertEquals(1, emails.size());
        System.assertEquals('Lease Expiration Notice', emails[0].getSubject());
        String body = emails[0].getPlainTextBody();
        System.assertEquals(true, body.contains('The following leases have expired:'));
        System.assertEquals(true, body.contains('Lease ID: ' + leases[0].Id + ', End Date: ' + leases[0].End_Date__c));
*/
        }

    }
}