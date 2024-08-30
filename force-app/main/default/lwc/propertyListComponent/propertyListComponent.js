import { LightningElement, track } from 'lwc';
import getPropertyList from '@salesforce/apex/PropertyController.getPropertyList';

export default class PropertyListing extends LightningElement {
    @track location = '';
    @track Type = '';

    @track priceRange = 1000000; // Default to max price
    @track properties;
    @track error;

    propertyTypeOptions = [
        { label: 'Commercial', value: 'Commercial' },
        { label: 'Residential', value: 'Residential' }
    ];



    connectedCallback() {
        this.fetchProperties(); // Fetch properties on initialization
    }

    handleLocationChange(event) {
        this.location = event.target.value;
    }

    handlePropertyTypeChange(event) {
        this.Type = event.detail.value;
    }

    handlePriceRangeChange(event) {
        this.priceRange = event.target.value;
    }

    handleSearch() {
        this.fetchProperties(); // Fetch properties with current filters
    }

    fetchProperties() {
        getPropertyList({ location: this.location, Type: this.Type, priceRange: this.priceRange })
            .then(result => {
                this.properties = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.properties = undefined;
            });
    }


   
}

