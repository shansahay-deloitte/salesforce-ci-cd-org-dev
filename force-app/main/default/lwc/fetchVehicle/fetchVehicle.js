import { LightningElement, api } from 'lwc';
import fetchAndInsertVehicles from '@salesforce/apex/FetchVehicles.fetchAndInsertVehicles';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class FetchVehicles extends LightningElement {
    @api recordId;
 
    handleClick() {
        fetchAndInsertVehicles()
            .then(() => {
                this.showToast('Success', 'Vehicles fetched and inserted successfully.', 'success');
            })
            .catch(error => {
                // Log full error object to understand the structure
                console.error('Error:', error);
   
                // Safely check for error details
                const errorMessage = error?.body?.message || error?.message || 'An unknown error occurred';
                this.showToast('Error', errorMessage, 'error');
            });
    }
   
 
    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title,
            message,
            variant
        });
        this.dispatchEvent(event);
    }
}