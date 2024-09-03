
import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MaintenanceRequestForm extends LightningElement {
    
    handleSuccess(event) {
        const recordId = event.detail.id;
        console.log(`Record successfully created with Id: ${recordId}`);

       this.dispatchEvent(
            new ShowToastEvent({
                // The title of the toast notification
                title: 'Success',
                // The message of the toast notification
                message: 'Maintenance request has been submitted.',
                // The variant of the toast notification
                variant: 'success',
            })
        );

        // Reset the form 
       this.resetForm();
    }

    
    resetForm() {
        // Get all input fields
        const inputs = this.template.querySelectorAll('lightning-input-field');

        // Loop through all the input fields and reset their values
        inputs.forEach(input => {
            input.value = '';
        });
    }
}

