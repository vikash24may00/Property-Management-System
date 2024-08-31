public class MaintenanceRequestTriggerHandler {
    public static void updatePropertyStatusToUnderMaintenance(List<Maintenance_Request__c> maintenanceRequests) {
        Set<Id> propertyIds = new Set<Id>();
        
        for (Maintenance_Request__c request : maintenanceRequests) {
            if (request.Property__c != null) {
                propertyIds.add(request.Property__c);
            }
        }

        if (!propertyIds.isEmpty()) {
            List<Property__c> propertiesToUpdate = [
                SELECT Id, Status__c FROM Property__c WHERE Id IN :propertyIds
            ];

            for (Property__c property : propertiesToUpdate) {
                property.Status__c = 'Under Maintenance';
            }

            update propertiesToUpdate;
        }
    }
}