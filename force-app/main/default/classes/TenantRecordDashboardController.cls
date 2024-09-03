public with sharing class TenantRecordDashboardController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getTenantData(Id tenantId) {
        // Fetch the lease details associated with the provided tenant ID
        Lease__c lease = [
            SELECT Property__r.Name, Start_Date__c, End_Date__c, Rent_Amount__c
            FROM Lease__c
            WHERE Tenant__c = :tenantId
            LIMIT 1
        ];
        
        // Count the number of maintenance requests associated with the provided tenant ID
        Integer maintenanceRequestCount = [
            SELECT COUNT()
            FROM Maintenance_Request__c
            WHERE Tenant__c = :tenantId
        ];
        
        // Prepare a map to hold the result data for the component
        Map<String, Object> result = new Map<String, Object>();
        
        // Populate lease details into the result map
        result.put('leaseDetails', new Map<String, Object>{
            'PropertyName' => lease.Property__r.Name,
                'StartDate' => lease.Start_Date__c,
                'EndDate' => lease.End_Date__c,
                'RentAmount' => lease.Rent_Amount__c
                });
        
        // Add the maintenance request count to the result map
        result.put('maintenanceRequestCount', maintenanceRequestCount);
        
        // Return the populated result map
        return result;
    }
}