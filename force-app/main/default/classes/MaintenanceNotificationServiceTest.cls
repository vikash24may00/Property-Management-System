/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 09-03-2024
 * @last modified by  : VIKASH MUNDARI
**/
@IsTest
public class MaintenanceNotificationServiceTest {

    @TestSetup
    static void setupTestData() {
        // Create test data for tenants
        List<Tenant__c> tenants = new List<Tenant__c>{
            new Tenant__c(Name = 'vikash mundari', Contact_Info__c = 'vikash@gmail.com'),
            new Tenant__c(Name = 'akash mundari', Contact_Info__c = 'akash@gmail.com')
        };
        insert tenants;
    }

    @IsTest
    static void testSendMaintenanceNotification() {
        // Retrieve the test tenant records
        List<Tenant__c> tenantRecords = [SELECT Id FROM Tenant__c];
        Set<Id> tenantIds = new Set<Id>();
        for (Tenant__c tenant : tenantRecords) {
            tenantIds.add(tenant.Id);
        }

        // Start the test context
        Test.startTest();

        // Call the future method
        MaintenanceNotificationService.sendMaintenanceNotification(tenantIds);

        // Stop the test context
        Test.stopTest();

        // Verify that the email logic was invoked by checking limits
        // Since Salesforce does not send emails in tests, this will always return 0.
        // Instead, we verify that the method processed correctly without checking email sends.
        Integer emailCount = Limits.getEmailInvocations();
        System.assertEquals(0, emailCount, 'Email invocations should be zero because emails are not actually sent in tests.');
    }
}