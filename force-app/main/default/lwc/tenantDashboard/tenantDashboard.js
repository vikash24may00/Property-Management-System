import { LightningElement, api, wire } from 'lwc';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/ChartJS'; // If using static resource
import getTenantData from '@salesforce/apex/TenantRecordDashboardController.getTenantData';

export default class TenantRecordDashboard extends LightningElement {
    @api recordId; // Tenant record ID
    chartInitialized = false;
    leaseDetails;
    maintenanceRequestCount;

    @wire(getTenantData, { tenantId: '$recordId' })
    wiredTenantData({ error, data }) {
        if (data) {
            this.leaseDetails = data.leaseDetails;
            this.maintenanceRequestCount = data.maintenanceRequestCount;
            this.renderMaintenanceChart();
        } else if (error) {
            console.error('Error fetching tenant data:', error);
        }
    }

    renderedCallback() {
        if (this.chartInitialized) {
            return;
        }
        this.chartInitialized = true;

        loadScript(this, CHARTJS)
            .then(() => {
                this.renderMaintenanceChart();
            })
            .catch(error => {
                console.error('Error loading Chart.js:', error);
            });
    }

    renderMaintenanceChart() {
        if (this.maintenanceRequestCount && this.chartInitialized) {
            const ctx = this.template.querySelector('canvas.maintenance-chart').getContext('2d');
            new Chart(ctx, {
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
    }
}
