// import { LightningElement, track } from 'lwc';
// import getPropertyList from '@salesforce/apex/PropertyController.getPropertyList';

// export default class PropertyListing extends LightningElement {
//     @track location = '';
//     @track Type = '';
//     @track Discription = '';
//     // @track Image = '';

//     @track priceRange = 1000000; // Default to max price
//     @track properties;
//     @track error;

//     propertyTypeOptions = [
//         { label: 'Commercial', value: 'Commercial' },
//         { label: 'Residential', value: 'Residential' }
//     ];



//     connectedCallback() {
//         this.fetchProperties(); // Fetch properties on initialization
//     }

//     handleLocationChange(event) {
//         this.location = event.target.value;
//     }

//     handlePropertyTypeChange(event) {
//         this.Type = event.detail.value;
//     }

//     handlePriceRangeChange(event) {
//         this.priceRange = event.target.value;
//     }

//     handleSearch() {
//         this.fetchProperties(); // Fetch properties with current filters
//     }

//     fetchProperties() {
//         getPropertyList({ location: this.location, Type: this.Type, priceRange: this.priceRange })
//             .then(result => {
//                 this.properties = result;
//                 this.error = undefined;
//             })
//             .catch(error => {
//                 this.error = error;
//                 this.properties = undefined;
//             });
//     }


   
// }


import { LightningElement, track, wire } from 'lwc';
import getPropertyList from '@salesforce/apex/PropertyController.getPropertyList';
import deleteProperty from '@salesforce/apex/PropertyController.deleteProperty';
import saveProperty from '@salesforce/apex/PropertyController.saveProperty';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class PropertyListing extends LightningElement {
    @track location = '';
    @track selectedTypes = [];
    @track priceRange = 1000000;
    @track properties;
    @track error;
    wiredProperties;

    @track isEditModalOpen = false;
    @track isDeleteModalOpen = false;
    @track editProperty = {};
    @track deletePropertyId;

    propertyTypeOptions = [
        { label: 'Commercial', value: 'Commercial' },
        { label: 'Residential', value: 'Residential' }
    ];

    // Cache the result of getPropertyList for refreshApex
    @wire(getPropertyList, { location: '$location', types: '$selectedTypes', priceRange: '$priceRange' })
    wiredGetPropertyList(result) {
        this.wiredProperties = result;
        if (result.data) {
            this.properties = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.properties = undefined;
        }
    }

     // Getter to check if a property type is selected
     get computedPropertyTypes() {
        return this.propertyTypeOptions.map(option => ({
            ...option,
            isChecked: this.selectedTypes.includes(option.value)
        }));
    }

    handleLocationChange(event) {
        this.location = event.target.value;
        if (this.location.length >= 3 || this.location.length === 0) {
            refreshApex(this.wiredProperties); // Refresh the property list when location changes
        }
    }

    handlePropertyTypeChange(event) {
        const value = event.target.value;
        if (event.target.checked) {
            this.selectedTypes = [...this.selectedTypes, value];
        } else {
            this.selectedTypes = this.selectedTypes.filter(type => type !== value);
        }
        refreshApex(this.wiredProperties); // Refresh the property list when property type changes
    }

    handlePriceRangeChange(event) {
        this.priceRange = event.target.value;
        refreshApex(this.wiredProperties); // Refresh the property list when price range changes
    }

    handleClearFilters() {
        this.location = '';
        this.selectedTypes = [];
        this.priceRange = 1000000;
        this.handleSearch(); // Trigger search with cleared filters
        // refreshApex(this.wiredProperties); // Refresh the property list when filters are cleared
    }

    handleEdit(event) {
        const propertyId = event.currentTarget.dataset.id;
        this.editProperty = this.properties.find(prop => prop.Id === propertyId);
        this.isEditModalOpen = true;
    }

    handleSearch() {
        // console.log('search button worked');
        refreshApex(this.wiredProperties); // Refresh the property list based on current filters
    }

    handleDelete(event) {
        this.deletePropertyId = event.currentTarget.dataset.id;
        this.isDeleteModalOpen = true;
    }

    handleEditChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;

        if (this.editProperty && field) {
            this.editProperty = { ...this.editProperty, [field]: value };
        }
    }

    closeEditModal() {
        this.isEditModalOpen = false;
    }

    closeDeleteModal() {
        this.isDeleteModalOpen = false;
    }

    saveEdit() {
        saveProperty({ property: this.editProperty })
            .then(() => {
                this.showToast('Success', 'Property updated successfully', 'success');
                this.isEditModalOpen = false;
                return refreshApex(this.wiredProperties); // Refresh the property list after saving
            })
            .catch(error => {
                this.showToast('Error', 'Failed to save property', 'error');
                console.error('Error saving property:', error);
            });
    }

    confirmDelete() {
        deleteProperty({ propertyId: this.deletePropertyId })
            .then(() => {
                this.showToast('Success', 'Property deleted successfully', 'success');
                this.isDeleteModalOpen = false;
                return refreshApex(this.wiredProperties); // Refresh the property list after deletion
            })
            .catch(error => {
                this.showToast('Error', 'Failed to delete property', 'error');
                console.error('Error deleting property:', error);
            });
    }
    
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });
        this.dispatchEvent(event);
    }
}

