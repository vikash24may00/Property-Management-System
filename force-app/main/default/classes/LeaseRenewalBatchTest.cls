@IsTest
public class LeaseRenewalBatchTest {

    @testSetup
    static void setupTestData() 
    {
        // Create a property
        Property__c property = new Property__c(Name = 'Test Property', Location__c = 'Test Location');
        insert property;

        // Create tenants
        Tenant__c tenant1 = new Tenant__c(Name = 'John Doe', Contact_Info__c = 'john.doe@example.com', Lease_Start_Date__c = Date.today().addYears(-1), Lease_End_Date__c = Date.today().addDays(25));
        Tenant__c tenant2 = new Tenant__c(Name = 'Jane Smith', Contact_Info__c = 'jane.smith@example.com', Lease_Start_Date__c = Date.today().addYears(-1), Lease_End_Date__c = Date.today().addDays(35));

        insert new List<Tenant__c> { tenant1, tenant2 };

        // Create leases
        Lease__c lease1 = new Lease__c(Property__c = property.Id, Tenant__c = tenant1.Id, End_Date__c = Date.today().addDays(25), Status__c = 'Active');
        Lease__c lease2 = new Lease__c(Property__c = property.Id, Tenant__c = tenant2.Id, End_Date__c = Date.today().addDays(35), Status__c = 'Active');

        insert new List<Lease__c> { lease1, lease2 };
    }

    @IsTest
    static void testLeaseRenewalBatch() {
        // Start the test
        Test.startTest();

        // Execute the batch job
        LeaseRenewalBatch batch = new LeaseRenewalBatch();
        Database.executeBatch(batch, 100);

        Test.stopTest();

        // Verify the lease end date is extended by one year for lease1
        Lease__c lease1 = [SELECT End_Date__c FROM Lease__c WHERE End_Date__c = :Date.today().addDays(25)];
        System.assertEquals(Date.today().addDays(25).addYears(1), lease1.End_Date__c, 'Lease end date should be extended by one year.');

        // Verify that lease2 is not renewed because its expiration date is not within 30 days
        Lease__c lease2 = [SELECT End_Date__c FROM Lease__c WHERE End_Date__c = :Date.today().addDays(35)];
        System.assertEquals(Date.today().addDays(35), lease2.End_Date__c, 'Lease end date should remain unchanged.');
    }
}