/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 09-03-2024
 * @last modified by  : VIKASH MUNDARI
**/
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
            System.assertEquals('Leased', property.Status__c, 'Property status should be updated to Leased');
        }
    }

    @IsTest
    static void testHandleLeaseExpiration() {
        // Create test properties
        List<Property__c> properties = new List<Property__c>();
        for (Integer i = 0; i < 10; i++) {
            Property__c property = new Property__c(Name = 'Test Property ' + i, Status__c = 'Leased');
            properties.add(property);
        }
        insert properties;

        // Create test leases
        List<Lease__c> leases = new List<Lease__c>();
        for (Integer i = 0; i < 10; i++) {
            Lease__c lease = new Lease__c(Property__c = properties[i].Id, End_Date__c = Date.today().addDays(-1), Status__c = 'Active');
            leases.add(lease);
        }
        insert leases;

        // Call the method under test
        LeaseTriggerHandler.handleLeaseExpiration(leases);

        // Verify the properties were updated
        List<Property__c> updatedProperties = [SELECT Id, Status__c FROM Property__c WHERE Id IN :properties];
        for (Property__c property : updatedProperties) {
            System.assertEquals('Available', property.Status__c, 'Property status should be updated to Available');
        }

        // Verify that the expired leases were processed
        List<Lease__c> expiredLeases = [SELECT Id, Status__c FROM Lease__c WHERE Id IN :leases];
        for (Lease__c lease : expiredLeases) {
            System.assertEquals('Active', lease.Status__c, 'Lease status should remain Active');
        }

       
        
        // Verify the email was sent
       /* Messaging.SingleEmailMessage[] emails = Messaging.getSentEmailMessages();
        System.assertEquals(1, emails.size(), 'One email should have been sent');
        System.assertEquals('Lease Expiration Notice', emails[0].getSubject(), 'Email subject should match');
        String body = emails[0].getPlainTextBody();
        System.assert(body.contains('The following leases have expired:'), 'Email body should contain lease expiration notice');
        System.assert(body.contains('Lease ID: ' + leases[0].Id), 'Email body should contain the lease ID');
        */
    }
}