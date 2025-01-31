import { LightningElement,wire } from 'lwc';
import getVehicles from '@salesforce/apex/VehicleController.getVehicles';
import selectedVehicle from '@salesforce/apex/VehicleController.selectedVehicle';
 
const COLUMNS = [
    { label: 'Vehicle Name', fieldName: 'Name' },
    { label: 'Model', fieldName: 'Model__c' },
];
 
 
export default class ShowAllVehiclesController extends LightningElement {
    @wire(getVehicles,{searchText:'$searchText'})
    vehicleList;
   
    @wire(selectedVehicle,{id:'$sId'})
    vehicleRadio
 
    columns=COLUMNS;
    searchText='';
    sId='';
    handleSearch(event){
        this.searchText=event.target.value;
    }
    handleRowAction(event){
        const selectedRow = event.detail.selectedRows;
    if (selectedRow.length ==1) {
        this.sId = selectedRow[0].Id;
    }
 
 
    }
 
}