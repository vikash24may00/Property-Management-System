@IsTest
public class MaintenanceRequestTriggerHandlerTest {
    @IsTest
    static void testUpdatePropertyStatusToUnderMaintenance() {
        // Create a test property and insert it
        Property__c property = new Property__c(Name = 'Test Property 1');
        insert property;

        // Create test maintenance request and associate it with the property
        Maintenance_Request__c maintenanceRequest = new Maintenance_Request__c(Property__c = property.Id);
        insert maintenanceRequest;

        // Test with valid data
        Test.startTest();
        MaintenanceRequestTriggerHandler.updatePropertyStatusToUnderMaintenance(new List<Maintenance_Request__c>{maintenanceRequest});
        Test.stopTest();

        // Verify that the property's status is updated to 'Under Maintenance'
        Property__c updatedProperty = [SELECT Status__c FROM Property__c WHERE Id = :property.Id];
        System.assertEquals('Under Maintenance', updatedProperty.Status__c);

        // Test with invalid data (Property__c set to null)
        Test.startTest();
        maintenanceRequest.Property__c = null;
        update maintenanceRequest;
        MaintenanceRequestTriggerHandler.updatePropertyStatusToUnderMaintenance(new List<Maintenance_Request__c>{maintenanceRequest});
        Test.stopTest();

        // Since Property__c is null, no update should happen, so we query the property again to confirm no changes
        updatedProperty = [SELECT Status__c FROM Property__c WHERE Id = :property.Id];
        System.assertEquals('Under Maintenance', updatedProperty.Status__c);  // No change expected
    }
}