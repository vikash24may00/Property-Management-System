public class MaintenanceRequestTriggerHandler {
    public static void updatePropertyStatusToUnderMaintenance(List<Maintenance_Request__c> maintenanceRequests)
    {
        // Create a set to store unique property IDs from the maintenance requests
        Set<Id> propertyIds = new Set<Id>();
        
        // Iterate through the maintenance requests
        for (Maintenance_Request__c request : maintenanceRequests) 
        {
            // Check if the maintenance request has an associated property
            if (request.Property__c != null) 
            {
                // Add the property ID to the set   
                propertyIds.add(request.Property__c);
            }
        }
        
        // Proceed only if there are property IDs to update
        if (!propertyIds.isEmpty()) 
        {
            // Query properties that need to be updated based on the collected property IDs  
            List<Property__c> propertiesToUpdate = [
                SELECT Id, Status__c FROM Property__c WHERE Id IN :propertyIds
            ];
            
            // Iterate through the properties and update their status 
            for (Property__c property : propertiesToUpdate) {
                property.Status__c = 'Under Maintenance';
            }
            
            // Perform the DML operation to update the properties in the database
            update propertiesToUpdate;
        }
    }
}