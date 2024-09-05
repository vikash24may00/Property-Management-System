// import { LightningElement, api, wire, track } from 'lwc';
// import { loadScript } from 'lightning/platformResourceLoader';
// import { refreshApex } from '@salesforce/apex';
// import CHARTJS from '@salesforce/resourceUrl/ChartJS';
// import getTenantData from '@salesforce/apex/TenantRecordDashboardController.getTenantData';

// export default class TenantRecordDashboard extends LightningElement {
//     @api recordId; // Tenant record ID
//     @track leaseDetails = [];
//     @track maintenanceRequestCount;
//     chartInitialized = false;
//     chart;
//     refreshInterval;

//     leaseColumns = [
//         { label: 'Property Name', fieldName: 'PropertyName' },
//         { label: 'Start Date', fieldName: 'StartDate', type: 'date' },
//         { label: 'End Date', fieldName: 'EndDate', type: 'date' },
//         { label: 'Rent Amount', fieldName: 'RentAmount', type: 'currency' }
//     ];

//     wiredTenantResult;

//     @wire(getTenantData, { tenantId: '$recordId' })
//     wiredTenantData(result) {
//         this.wiredTenantResult = result;
//         if (result.data) {
//             this.leaseDetails = [result.data.leaseDetails];
//             this.maintenanceRequestCount = result.data.maintenanceRequestCount;

//             if (this.chartInitialized) {
//                 this.updateChart();
//             }
//         } else if (result.error) {
//             console.error('Error fetching tenant data:', result.error);
//         }
//     }

//     renderedCallback() {
//         if (!this.chartInitialized) {
//             this.chartInitialized = true;

//             loadScript(this, CHARTJS)
//                 .then(() => {
//                     this.renderMaintenanceChart();
//                 })
//                 .catch(error => {
//                     console.error('Error loading Chart.js:', error);
//                 });
//         }

//         // Start the periodic refresh if not already started
//         if (!this.refreshInterval) {
//             this.startPeriodicRefresh();
//         }
//     }

//     renderMaintenanceChart() {
//         if (this.maintenanceRequestCount !== undefined && this.chartInitialized) {
//             const ctx = this.template.querySelector('canvas.maintenance-chart').getContext('2d');
//             this.chart = new window.Chart(ctx, {
//                 type: 'bar',
//                 data: {
//                     labels: ['Maintenance Requests'],
//                     datasets: [{
//                         label: 'Number of Requests',
//                         data: [this.maintenanceRequestCount],
//                         backgroundColor: 'rgba(75, 192, 192, 0.2)',
//                         borderColor: 'rgba(75, 192, 192, 1)',
//                         borderWidth: 1
//                     }]
//                 },
//                 options: {
//                     responsive: true,
//                     scales: {
//                         y: {
//                             beginAtZero: true
//                         }
//                     }
//                 }
//             });
//         }
//     }

//     updateChart() {
//         if (this.chart && this.maintenanceRequestCount !== undefined) {
//             this.chart.data.datasets[0].data = [this.maintenanceRequestCount];
//             this.chart.update(); // Update the chart with new data
//         }
//     }

//     refreshData() {
//         refreshApex(this.wiredTenantResult)
//             .then(() => {
//                 this.updateChart();
//             });
//     }

//     startPeriodicRefresh() {
//         this.refreshInterval = setInterval(() => {
//             this.refreshData();
//         }, 2000); // Refresh every 10 seconds (adjust as needed)
//     }

//     disconnectedCallback() {
//         // Clear the interval when the component is destroyed
//         if (this.refreshInterval) {
//             clearInterval(this.refreshInterval);
//         }
//     }
// }



import { LightningElement, track, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/ChartJS';
import searchTenants from '@salesforce/apex/TenantRecordDashboardController.searchTenants';
import getTenantData from '@salesforce/apex/TenantRecordDashboardController.getTenantData';

export default class TenantRecordDashboard extends LightningElement {
    @track searchKey = '';
    @track leaseDetails = [];
    @track maintenanceRequestCount;
    @track tenantSelected = false;
    @track showTenantNotFoundMessage = false;
    chartInitialized = false;
    chart;

    leaseColumns = [
        { label: 'Property Name', fieldName: 'PropertyName' },
        { label: 'Start Date', fieldName: 'StartDate', type: 'date' },
        { label: 'End Date', fieldName: 'EndDate', type: 'date' },
        { label: 'Rent Amount', fieldName: 'RentAmount', type: 'currency' }
    ];

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleTenantSearch() {
        if (this.searchKey) {
            searchTenants({ searchKey: this.searchKey })
                .then(tenantId => {
                    if (tenantId) {
                        this.showTenantNotFoundMessage = false;
                        this.loadTenantData(tenantId);
                    } else {
                        this.showTenantNotFoundMessage = true;
                        this.tenantSelected = false;
                        this.clearData();
                    }
                })
                .catch(error => {
                    console.error('Error searching tenant:', error);
                    this.showTenantNotFoundMessage = true;
                    this.tenantSelected = false;
                    this.clearData();
                });
        }
        else {
            // Clear the data when the search box is empty
            this.showTenantNotFoundMessage = false;
            this.tenantSelected = false;
            this.clearData();
        }
    }

    loadTenantData(tenantId) {
        getTenantData({ tenantId })
            .then(result => {
                this.leaseDetails = [result.leaseDetails];
                this.maintenanceRequestCount = result.maintenanceRequestCount;
                this.tenantSelected = true;

                if (this.chartInitialized) {
                    this.updateChart();
                } else {
                    this.initializeChart();
                }
            })
            .catch(error => {
                console.error('Error fetching tenant data:', error);
                this.clearData();
            });
    }

    initializeChart() {
        loadScript(this, CHARTJS)
            .then(() => {
                this.renderMaintenanceChart();
                this.chartInitialized = true;
            })
            .catch(error => {
                console.error('Error loading Chart.js:', error);
            });
    }

    renderMaintenanceChart() {
        const ctx = this.template.querySelector('canvas.maintenance-chart').getContext('2d');
        this.chart = new window.Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Maintenance Requests'],
                datasets: [{
                    label: 'Number of Requests',
                    data: [this.maintenanceRequestCount],
                    backgroundColor: 'rgba(75, 192, 192, 0.2)',
                    borderColor: 'rgba(75, 192, 192, 1)',
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true
                    }
                }
            }
        });
    }

    updateChart() {
        if (this.chart && this.maintenanceRequestCount !== undefined) {
            this.chart.data.datasets[0].data = [this.maintenanceRequestCount];
            this.chart.update();
        }
    }

    clearData() {
        this.leaseDetails = [];
        this.maintenanceRequestCount = null;
        if (this.chart) {
            this.chart.destroy();
            this.chart = null;
            this.chartInitialized = false;
        }
    }
}
