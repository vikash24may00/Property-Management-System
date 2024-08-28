import { LightningElement, wire } from 'lwc';
import getPropertyItems from '@salesforce/apex/PropertyController.getPropertyItems';
import searchPropertyItems from '@salesforce/apex/PropertyController.searchPropertyItems';

export default class propertyListComponent extends LightningElement {
    propertyItems;
    error;
    loading = false;
    searchTerm = '';
    location = '';
    selectedPropertyTypes = [];
    priceRange = 99999;
    maxPrice = 99999; // Define the maximum price range based on your data
    propertyTypeOptions = [
        { label: 'Apartment', value: 'Apartment' },
        { label: 'House', value: 'House' },
        { label: 'Condo', value: 'Condo' }
    ];

    @wire(getPropertyItems)
    wiredPropertyItems(result) {
        this.wiredPropertyItemsResult = result;
        if (result.data) {
            this.propertyItems = result.data;
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
            this.propertyItems = undefined;
        }
    }

    handleInputChange(event) {
        this.searchTerm = event.target.value;
        this.search();
    }

    handleLocationChange(event) {
        this.location = event.target.value;
        this.search();
    }

    handleTypeChange(event) {
        this.selectedPropertyTypes = event.detail.value;
        this.search();
    }

    handlePriceChange(event) {
        this.priceRange = event.target.value;
        this.search();
    }

    handleSearch() {
        this.loading = true;
        searchPropertyItems({ searchKeywords: this.searchTerm, location: this.location, propertyTypes: this.selectedPropertyTypes, maxPrice: this.priceRange })
            .then(result => {
                this.propertyItems = result;
                this.error = undefined;
            })
            .catch(error => {
                this.error = error;
                this.propertyItems = undefined;
            })
            .finally(() => {
                this.loading = false;
            });
    }
}
