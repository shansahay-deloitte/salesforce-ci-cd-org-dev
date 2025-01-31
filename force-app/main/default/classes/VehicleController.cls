public with sharing class VehicleController {
    @AuraEnabled(cacheable=true)
    public static List<Vehicle__c> getVehicles(String searchText){
            if(String.isEmpty(searchText)){
 
            return [SELECT Id, Name, Model__c FROM Vehicle__c];
            }
            else{
                searchText='%' +searchText + '%';
                return [SELECT Id, Name, Model__c FROM Vehicle__c WHERE Name LIKE :searchText];
            }
        } 

    @AuraEnabled(cacheable=true)
    public static Vehicle__c selectedVehicle(String id){
          try {
          return [SELECT Id, Name, Make__c,Model__c,Price__c,VIN__c FROM Vehicle__c WHERE Id= :id LIMIT 1];
        } catch (Exception e) {
            throw new AuraHandledException ('Error fetching the selected vehicle: ' + e.getMessage());
        }
	}
}