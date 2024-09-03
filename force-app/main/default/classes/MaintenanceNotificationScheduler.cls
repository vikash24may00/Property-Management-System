public class MaintenanceNotificationScheduler implements Schedulable {
    
    public void execute(SchedulableContext sc) {
        Date tomorrow = Date.today().addDays(1);
        
        // Query maintenance requests scheduled for tomorrow and are open
        List<Maintenance_Request__c> requests = [SELECT Tenant__c FROM Maintenance_Request__c WHERE Request_Date__c = :tomorrow AND Status__c = 'In Progress' AND Approval_Status__c = 'Approved'
];
        
        Set<Id> tenantIds = new Set<Id>();
        for (Maintenance_Request__c request : requests) {
            tenantIds.add(request.Tenant__c);
        }
        
        if (!tenantIds.isEmpty()) {
            // Call the future method to send notifications
            MaintenanceNotificationService.sendMaintenanceNotification(tenantIds);
        }
    }
    
    // Method to schedule the batch job
    public static void scheduleMaintenanceNotificationJob() {
        String cronExpression = '0 45 8 * * ?'; 
        System.schedule('Daily Maintenance Notification Job', cronExpression, new MaintenanceNotificationScheduler());
    }
}