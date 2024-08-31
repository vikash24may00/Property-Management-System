/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 08-31-2024
 * @last modified by  : VIKASH MUNDARI
**/


// public with sharing class PropertyController {
    
//     @AuraEnabled(cacheable=true)
//     public static List<Property__c> getPropertyList(String location, String Type, Decimal priceRange, String Discription) {
//         String query = 'SELECT Id, Name, Location__c, Type__c, Price__c,Description__c,Image__c FROM Property__c WHERE Price__c <= :priceRange';
        
//         // If a location is given, add an additional clause to the WHERE statement to filter the results by location.
//         if (location != null && location != '') {
//             query += ' AND Location__c LIKE \'%' + location + '%\'';
//         }
        
//         // If a type is given, add an additional clause to the WHERE statement to filter the results by type.
//         if (Type != null && Type != '') {
//             query += ' AND Type__c = :Type';
//         }
        
//         // Execute the query and return the results.
//         return Database.query(query);
//     }
// }


public with sharing class PropertyController {
    // @AuraEnabled(cacheable=true)
    // public static List<Property__c> getPropertyList(String location, List<String> types, Decimal priceRange) {
    //     String query = 'SELECT Id, Name, Location__c, Type__c, Price__c, Description__c, Image__c FROM Property__c WHERE Price__c <= :priceRange';
        
    //     if (!String.isEmpty(location)) {
    //         query += ' AND Location__c LIKE \'%' + String.escapeSingleQuotes(location) + '%\'';
    //     }
        
    //     if (types != null && types.size() > 0) {
    //         query += ' AND Type__c IN :types';
    //     }

    //     return Database.query(query);
    // }

    @AuraEnabled(cacheable=true)
    public static List<Property__c> getPropertyList(String location, List<String> types, Decimal priceRange) {
        String locationSearch = location + '%'; // This will match any property location that starts with the input

        String query = 'SELECT Id, Name, Location__c, Type__c, Price__c FROM Property__c WHERE Price__c <= :priceRange';
        
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
        try {
            Property__c propertyToDelete = [SELECT Id FROM Property__c WHERE Id = :propertyId LIMIT 1];
            delete propertyToDelete;
        } catch (Exception e) {
            throw new AuraHandledException('Unable to delete property: ' + e.getMessage());
        }
    }

    @AuraEnabled
    public static void saveProperty(Property__c property) {
        try {
            upsert property;
        } catch (Exception e) {
            throw new AuraHandledException('Unable to save property: ' + e.getMessage());
        }
    }
}
