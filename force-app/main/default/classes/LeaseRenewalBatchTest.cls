/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 09-03-2024
 * @last modified by  : VIKASH MUNDARI
**/
@IsTest
public class LeaseRenewalBatchTest {

    @testSetup
    static void setupTestData() 
    {
        // Create a property
        Property__c property = new Property__c(Name = 'Test Property', Location__c = 'Test Location');
        insert property;

        // Create tenants
        Tenant__c tenant1 = new Tenant__c(Name = 'vikash mundari', Contact_Info__c = 'test@example.com', Lease_Start_Date__c = Date.today().addYears(-1), Lease_End_Date__c = Date.today().addDays(25));
        Tenant__c tenant2 = new Tenant__c(Name = 'animesh', Contact_Info__c = 'animesh@example.com', Lease_Start_Date__c = Date.today().addYears(-1), Lease_End_Date__c = Date.today().addDays(35));
        Tenant__c tenant3 = new Tenant__c(Name = 'fahad', Contact_Info__c = 'fahad@example.com', Lease_Start_Date__c = Date.today().addYears(-1), Lease_End_Date__c = Date.today().addDays(45));

        insert new List<Tenant__c> { tenant1, tenant2, tenant3 };

        // Create leases
        Lease__c lease1 = new Lease__c(Property__c = property.Id, Tenant__c = tenant1.Id, End_Date__c = Date.today().addDays(25), Status__c = 'Active');
        Lease__c lease2 = new Lease__c(Property__c = property.Id, Tenant__c = tenant2.Id, End_Date__c = Date.today().addDays(35), Status__c = 'Active');
        Lease__c lease3 = new Lease__c(Property__c = property.Id, Tenant__c = tenant3.Id, End_Date__c = Date.today().addDays(45), Status__c = 'Active');

        insert new List<Lease__c> { lease1, lease2, lease3 };
    }

    @IsTest
    static void testLeaseRenewalBatch() {
        // Start the test
        Test.startTest();

        // Execute the batch job
        LeaseRenewalBatch batch = new LeaseRenewalBatch();
        Database.executeBatch(batch, 100);

        Test.stopTest();

        // Query all leases to verify changes
        List<Lease__c> leases = [
            SELECT End_Date__c, Status__c, Tenant__r.Name 
            FROM Lease__c 
            WHERE Tenant__r.Name IN ('vikash mundari', 'animesh', 'fahad')
        ];

        // Verify the lease end date is extended by one year for leases expiring within 30 days
        for (Lease__c lease : leases) {
            if (lease.Tenant__r.Name == 'vikashmundari') {
                System.assertEquals(Date.today().addDays(25).addYears(1), lease.End_Date__c, 'Lease1 end date should be extended by one year.');
            } else if (lease.Tenant__r.Name == 'animesh') {
                System.assertEquals(Date.today().addDays(35).addYears(1), lease.End_Date__c, 'Lease2 end date should be extended by one year.');
            } else if (lease.Tenant__r.Name == 'fahad') {
                System.assertEquals(Date.today().addDays(45), lease.End_Date__c, 'Lease3 end date should remain unchanged.');
            }
            System.assertEquals('Active', lease.Status__c, 'Lease status should remain Active.');
        }
    }
}