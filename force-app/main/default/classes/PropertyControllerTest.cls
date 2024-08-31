@IsTest
public class PropertyControllerTest {
    @IsTest
    private static void testGetPropertyList() {
        // Create test data
        List<Property__c> properties = new List<Property__c> {
            new Property__c(Name = 'Test Property 1', Location__c = 'Test Location 1', Type__c = 'Commercial', Price__c = 10000),
            new Property__c(Name = 'Test Property 2', Location__c = 'Test Location 2', Type__c = 'Residential', Price__c = 20000)
        };
        insert properties;
        
        // Test with valid parameters
        List<Property__c> result = PropertyController.getPropertyList('Test Location', 'Commercial', 15000);
        System.assertEquals(1, result.size());
        System.assertEquals(properties[0].Id, result[0].Id);
        
        // Test with invalid parameters
        result = PropertyController.getPropertyList(null, 'Invalid Type', 0);
        System.assertEquals(0, result.size());
    }
}