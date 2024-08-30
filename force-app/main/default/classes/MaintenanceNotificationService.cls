public class MaintenanceNotificationService {
    @future(callout=false)
    public static void sendMaintenanceNotification(Set<Id> tenantIds) {
        List<Tenant__c> tenants = [SELECT Id, Name, Contact_Info__c FROM Tenant__c WHERE Id IN :tenantIds];
        
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        
        for (Tenant__c tenant : tenants) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { tenant.Contact_Info__c });
            mail.setSubject('Upcoming Maintenance Notification');
            mail.setPlainTextBody('Dear ' + tenant.Name + ',\n\nThis is a reminder that you have an upcoming maintenance task scheduled.');
            emails.add(mail);
        }
        
        if (!emails.isEmpty()) {
            Messaging.sendEmail(emails);
        }
    }
}