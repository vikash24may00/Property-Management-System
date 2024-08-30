public class LeaseRenewalScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        LeaseRenewalBatch batch = new LeaseRenewalBatch();
        Database.executeBatch(batch, 100); // Adjust batch size as needed
    }
    
    // Method to schedule the batch job
    public static void scheduleLeaseRenewalBatch() {
        String cronExpression = '0 12 23 * * ?'; // Schedule to run at 11:02 PM every day
        System.schedule('Daily Lease Renewal Batch', cronExpression, new LeaseRenewalScheduler());
    }
}