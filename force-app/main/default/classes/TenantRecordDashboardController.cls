public with sharing class TenantRecordDashboardController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getTenantData(Id tenantId) {
        // Fetch lease details for the tenant
        Lease__c lease = [
            SELECT Property__r.Name, Start_Date__c, End_Date__c, Rent_Amount__c
            FROM Lease__c
            WHERE Tenant__c = :tenantId
            LIMIT 1
        ];

        // Count the number of maintenance requests associated with this tenant
        Integer maintenanceRequestCount = [
            SELECT COUNT()
            FROM Maintenance_Request__c
            WHERE Tenant__c = :tenantId
        ];

        // Prepare data for the component
        Map<String, Object> result = new Map<String, Object>();

        result.put('leaseDetails', new Map<String, Object>{
            'PropertyName' => lease.Property__r.Name,
            'StartDate' => lease.Start_Date__c,
            'EndDate' => lease.End_Date__c,
            'RentAmount' => lease.Rent_Amount__c
        });

        result.put('maintenanceRequestCount', maintenanceRequestCount);

        return result;
    }
}