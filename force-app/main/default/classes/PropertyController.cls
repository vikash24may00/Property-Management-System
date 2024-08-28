/**
 * @description       : 
 * @author            : VIKASH MUNDARI
 * @group             : 
 * @last modified on  : 08-28-2024
 * @last modified by  : VIKASH MUNDARI
**/
public with sharing class PropertyController {
    @AuraEnabled(cacheable=true)
    public static List<Property__c> getPropertyItems() {
        return [SELECT Id, Name, Location__c, PropertyType__c, Price__c, Image__c FROM Property__c];
    }

    @AuraEnabled
    public static List<Property__c> searchPropertyItems(String searchKeywords, String location, List<String> propertyTypes, Integer maxPrice) {
        String searchTerm = '%' + searchKeywords + '%';
        String queryString = 'SELECT Id, Name, Location__c, PropertyType__c, Price__c, Image__c FROM Property__c WHERE (Name LIKE :searchTerm OR Location__c LIKE :searchTerm)';

        if (location != null && location != '') {
            queryString += ' AND Location__c = :location';
        }

        if (propertyTypes != null && !propertyTypes.isEmpty()) {
            queryString += ' AND PropertyType__c IN :propertyTypes';
        }

        if (maxPrice != null) {
            queryString += ' AND Price__c <= :maxPrice';
        }

        return Database.query(queryString);
    }
}
