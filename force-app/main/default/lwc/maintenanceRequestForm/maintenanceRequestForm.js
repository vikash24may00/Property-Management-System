// import { LightningElement } from 'lwc';

// export default class MaintenanceRequestForm extends LightningElement {
//     handleSuccess(event) {
//         // Handle the success event from the record edit form
//         const recordId = event.detail.id;
//         console.log(`Record successfully created with Id: ${recordId}`);
//         // Optionally, show a success message or redirect the user
//     }
// }

import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MaintenanceRequestForm extends LightningElement {
    /**
     * This event is fired by the lightning-record-edit-form component when the record is successfully saved.
     * The event contains the record ID of the newly created record.
     * @param {Event} event - The event that is fired by the component.
     */
    handleSuccess(event) {
        const recordId = event.detail.id;
        console.log(`Record successfully created with Id: ${recordId}`);

        // Show a success toast notification to the user
        // The toast notification is a visual cue to the user that the action was successful.
        // The toast notification is automatically dismissed after a few seconds.
        // The toast notification is not automatically shown, it is up to the developer to decide when to show it.
        this.dispatchEvent(
            new ShowToastEvent({
                // The title of the toast notification
                title: 'Success',
                // The message of the toast notification
                message: 'Maintenance request has been submitted.',
                // The variant of the toast notification
                // The variant determines the visual styling of the toast notification
                // The variant can be one of the following: success, error, warning, or info
                variant: 'success',
            })
        );

        // Reset the form fields manually
        // When the form is submitted, the values of the form fields are not automatically reset.
        // The form fields are only reset when the page is reloaded.
        // To reset the form fields manually, we need to loop through all the input fields and set their value to an empty string.
        this.resetForm();
    }

    /**
     * This method resets the form fields manually.
     * This method is called when the form is submitted.
     * This method loops through all the input fields and sets their value to an empty string.
     */
    resetForm() {
        // Get all input fields
        const inputs = this.template.querySelectorAll('lightning-input-field');

        // Loop through all the input fields and reset their values
        inputs.forEach(input => {
            input.value = '';
        });
    }
}

