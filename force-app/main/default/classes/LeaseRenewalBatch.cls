public class LeaseRenewalBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        Date today = Date.today();
        Date next30Days = today.addDays(30);

        // Query leases that are about to expire within the next 30 days and are active
        String query = 'SELECT Id, End_Date__c, Status__c FROM Lease__c WHERE End_Date__c >= :today AND End_Date__c <= :next30Days AND Status__c = \'Active\'';
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext BC, List<Lease__c> scope) {
        List<Lease__c> leasesToRenew = new List<Lease__c>();

        for (Lease__c lease : scope) {
            // Business logic for renewing the lease, e.g., extend the lease end date by one year
            lease.End_Date__c = lease.End_Date__c.addYears(1);
            lease.Status__c = 'Active'; // Ensure the lease status remains active
            leasesToRenew.add(lease);
        }

        // Update the leases in the database
        update leasesToRenew;
    }

    public void finish(Database.BatchableContext BC) {
        // Optional: Add any logic you want to execute after the batch process finishes
        System.debug('Lease renewal batch job finished.');
    }
}