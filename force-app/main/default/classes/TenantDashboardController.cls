public with sharing class TenantDashboardController {
    
    @AuraEnabled(cacheable=true)
    public static List<Maintenance_Request__c> getMaintenanceRequests(Id propertyId) {
        return [
            SELECT Id, Request_Date__c, Status__c, Description__c
            FROM Maintenance_Request__c
            WHERE Property__c = :propertyId
        ];
    }
}