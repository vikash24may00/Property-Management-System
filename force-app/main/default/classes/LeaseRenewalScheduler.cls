public class LeaseRenewalScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        LeaseRenewalBatch batch = new LeaseRenewalBatch();
        Database.executeBatch(batch, 100); // Adjust batch size as needed
    }
    
    // Method to schedule the batch job
    public static void scheduleLeaseRenewalBatch() {
        String cronExpression = '0 38 8 * * ?';
        System.schedule('Daily Lease Renewal Batch', cronExpression, new LeaseRenewalScheduler());
    }
}