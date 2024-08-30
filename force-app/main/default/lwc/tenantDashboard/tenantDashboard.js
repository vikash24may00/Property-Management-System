import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

// Lease__c fields
import LEASE_START_DATE_FIELD from '@salesforce/schema/Lease__c.Start_Date__c';
import LEASE_END_DATE_FIELD from '@salesforce/schema/Lease__c.End_Date__c';
import RENT_AMOUNT_FIELD from '@salesforce/schema/Lease__c.Rent_Amount__c';
import LEASE_STATUS_FIELD from '@salesforce/schema/Lease__c.Status__c';

// Related Property__c fields via Lease__c
import PROPERTY_NAME_FIELD from '@salesforce/schema/Lease__c.Property__r.Name';
import PROPERTY_LOCATION_FIELD from '@salesforce/schema/Lease__c.Property__r.Location__c';

import getMaintenanceRequests from '@salesforce/apex/TenantDashboardController.getMaintenanceRequests';

export default class TenantDashboard extends LightningElement {
    @api recordId; // Lease ID
    lease;
    maintenanceRequests;

    // Fields from Lease__c including related Property__c fields
    leaseFields = [
        LEASE_START_DATE_FIELD,
        LEASE_END_DATE_FIELD,
        RENT_AMOUNT_FIELD,
        LEASE_STATUS_FIELD,
        PROPERTY_NAME_FIELD,
        PROPERTY_LOCATION_FIELD
    ];

    @wire(getRecord, { recordId: '$recordId', fields: '$leaseFields' })
    wiredLease({ error, data }) {
        if (data) {
            console.log('Lease data:', JSON.stringify(data));
            this.lease = data.fields;

            // Defensive check to ensure Property__c is available and not undefined
            const propertyField = data.fields.Property__c;
            const propertyId = propertyField ? propertyField.value : null;

            if (propertyId) {
                this.fetchMaintenanceRequests(propertyId);
            } else {
                console.error('Property__c is undefined or null.');
            }
        } else if (error) {
            console.error('Error fetching lease:', error);
        }
    }

    fetchMaintenanceRequests(propertyId) {
        getMaintenanceRequests({ propertyId })
            .then(result => {
                console.log('Maintenance requests:', result);
                this.maintenanceRequests = result;
            })
            .catch(error => {
                console.error('Error fetching maintenance requests:', error);
            });
    }
}
