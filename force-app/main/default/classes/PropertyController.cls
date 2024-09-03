/**
* @description       : 
* @author            : VIKASH MUNDARI
* @group             : 
* @last modified on  : 09-01-2024
* @last modified by  : VIKASH MUNDARI
**/


public with sharing class PropertyController {
    
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getPropertyList(String location, List<String> types, Decimal priceRange) {
        String locationSearch = location + '%'; // This will match any property location that starts with the input
        
        String query = 'SELECT Id, Name, Location__c, Type__c, Price__c,Description__c,Image__c FROM Property__c where price__c <= :priceRange';
        
        if (location != null && location != '') {
            query += ' AND Location__c LIKE :locationSearch';
        }
        
        if (types != null && !types.isEmpty()) {
            query += ' AND Type__c IN :types';
        }
        
        query += ' ORDER BY Price__c ASC';
        
        return Database.query(query);
    }
    
    @AuraEnabled
    public static void deleteProperty(Id propertyId) {
        // try {
        // Fetch the property to delete
        Property__c propertyToDelete = [SELECT Id FROM Property__c WHERE Id = :propertyId LIMIT 1];
        
        // Delete the property
        delete propertyToDelete;
        /* } catch (Exception e) {
throw new AuraHandledException('Unable to delete property: ' + e.getMessage());
} */
    }
    
    @AuraEnabled
    public static void saveProperty(Property__c property) {
        //  try {
        //  Update the property
        upsert property;
        /*  } catch (Exception e) {
throw new AuraHandledException('Unable to save property: ' + e.getMessage());
} */
    }
}