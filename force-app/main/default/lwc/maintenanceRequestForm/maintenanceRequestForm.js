import { LightningElement } from 'lwc';

export default class MaintenanceRequestForm extends LightningElement {
    handleSuccess(event) {
        // Handle the success event from the record edit form
        const recordId = event.detail.id;
        console.log(`Record successfully created with Id: ${recordId}`);
        // Optionally, show a success message or redirect the user
    }
}
