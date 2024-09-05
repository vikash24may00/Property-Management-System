/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 09-04-2024
 * @last modified by  : VIKASH MUNDARI
**/

@isTest
public class TenantRecordDashboardControllerTest {
    @isTest
    static void testGetTenantData() {
        // Create a tenant
        Tenant__c tenant = new Tenant__c(Name = 'vikash mundari', Contact_Info__c = 'vikash@test.com');
        insert tenant;

        // Create a lease
        Property__c property = new Property__c(Name = 'Test Property');
        insert property;

        Lease__c lease = new Lease__c(Property__c = property.Id, Tenant__c = tenant.Id, End_Date__c = Date.today().addYears(1));
        insert lease;

        // Create some maintenance requests
        for (Integer i = 0; i < 5; i++) {
            Maintenance_Request__c request = new Maintenance_Request__c(Property__c = property.Id, Tenant__c = tenant.Id);
            insert request;
        }

        // Call the method under test
        Map<String, Object> result = TenantRecordDashboardController.getTenantData(tenant.Id);

        // Assert the results
        Map<String, Object> leaseDetails = (Map<String, Object>) result.get('leaseDetails');
        System.assertEquals(property.Name, leaseDetails.get('PropertyName'));
        System.assertEquals(lease.Start_Date__c, leaseDetails.get('StartDate'));
        System.assertEquals(lease.End_Date__c, leaseDetails.get('EndDate'));
        System.assertEquals(lease.Rent_Amount__c, leaseDetails.get('RentAmount'));

        System.assertEquals(5, result.get('maintenanceRequestCount'));
    }
}


