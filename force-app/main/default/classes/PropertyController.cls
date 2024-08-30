/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 08-29-2024
 * @last modified by  : VIKASH MUNDARI
**/


public with sharing class PropertyController {
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getPropertyList(String location, String Type, Decimal priceRange) {
        String query = 'SELECT Id, Name, Location__c, Type__c, Price__c FROM Property__c WHERE Price__c <= :priceRange';
        
        if (location != null && location != '') {
            query += ' AND Location__c LIKE \'%' + location + '%\'';
        }
        if (Type != null && Type != '') {
            query += ' AND Type__c = :Type';
        }
        
        return Database.query(query);
    }
}