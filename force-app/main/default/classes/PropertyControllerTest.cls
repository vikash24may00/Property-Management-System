@IsTest
public class PropertyControllerTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test data
        List<Property__c> properties = new List<Property__c> {
            new Property__c(Name = 'Test Property 1', Location__c = 'Test Location 1', Type__c = 'Commercial', Price__c = 10000),
            new Property__c(Name = 'Test Property 2', Location__c = 'Test Location 2', Type__c = 'Residential', Price__c = 20000)
        };
        insert properties;
    }

    @IsTest
    static void testGetPropertyListWithValidParameters() {
        // Test with valid parameters
        List<String> types = new List<String> { 'Commercial' };
        List<Property__c> result = PropertyController.getPropertyList('Test Location 1', types, 15000);

        // Assertions
        System.assertEquals(1, result.size(), 'The result size should be 1 when filtering by location and type.');
        System.assertEquals('Test Property 1', result[0].Name, 'The returned property name should match the expected name.');
    }

    @IsTest
    static void testGetPropertyListWithInvalidParameters() {
        // Test with invalid parameters
        List<String> types = new List<String> { 'Invalid Type' };
        List<Property__c> result = PropertyController.getPropertyList(null, types, 0);

        // Assertions
        System.assertEquals(0, result.size(), 'The result size should be 0 when filtering by invalid type and price range.');
    }

    @IsTest
static void testDeleteProperty() {
    // Get a property to delete
    Property__c propertyToDelete = [SELECT Id FROM Property__c LIMIT 1];

    // Delete the property using the controller method
    PropertyController.deleteProperty(propertyToDelete.Id);

    // Verify that the property is deleted
    Integer countDeleted = [SELECT count() FROM Property__c WHERE Id = :propertyToDelete.Id];
    
    // Assertion
    System.assertEquals(0, countDeleted, 'The property should be deleted and no longer exist in the database.');
}

    @IsTest
    static void testSaveProperty() {
        // Create a new property
        Property__c newProperty = new Property__c(Name = 'New Property', Location__c = 'New Location', Type__c = 'Commercial', Price__c = 30000);

        // Save the property
        PropertyController.saveProperty(newProperty);

        // Query for the saved property
        Property__c savedProperty = [SELECT Id, Name FROM Property__c WHERE Id = :newProperty.Id LIMIT 1];

        // Assertions
        System.assertNotEquals(null, savedProperty, 'The property should be saved successfully.');
        System.assertEquals('New Property', savedProperty.Name, 'The property name should match the expected name.');
    }
}