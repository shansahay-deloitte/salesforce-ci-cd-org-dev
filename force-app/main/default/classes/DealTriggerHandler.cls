public class DealTriggerHandler {
    public static void preventDealGeneration(List<Deal__c> dealRecord){
        Set<Id> vehicleSet = new Set<Id>();
    	for(Deal__c deal: dealRecord){
        	if(deal.Vehicle__c != Null){
     			vehicleSet.add(deal.Vehicle__c);
    		}
    	}
     	Map<Id,Vehicle__c> vehicleMap = new Map<Id,Vehicle__c>([Select Id,Inventory__c from Vehicle__c where Id IN :vehicleSet]);
        for(Deal__c deal: dealRecord){
            Vehicle__c dealVehicle = vehicleMap.get(deal.Vehicle__c);
        	if(dealVehicle.Inventory__c == 0 || dealVehicle.Inventory__c == Null){
            	deal.addError('Insufficient inventory count for the requested deal.');
        	}
    	}
    }
    public static void updateInventory(List<Deal__c> dealRecord, Map<Id,Deal__c> oldMap){
		Set<Id> vehicleSet = new Set<Id>();
    	for(Deal__c deal: dealRecord){
        	if(deal.Vehicle__c != Null){
     			vehicleSet.add(deal.Vehicle__c);
    		}
    	}
     	Map<Id,Vehicle__c> vehicleMap = new Map<Id,Vehicle__c>([Select Id,Inventory__c from Vehicle__c where Id IN :vehicleSet]);
        List<Vehicle__c> updatedVehicles = new List<Vehicle__c>();
        for(Deal__c deal : dealRecord ){
            if(deal.Status__c != oldMap.get(deal.Id).Status__c && deal.Status__c == 'Approved'){
					Vehicle__c dealVehicle = vehicleMap.get(deal.Vehicle__c);
					dealVehicle.Inventory__c -= 1;    
                	updatedVehicles.add(dealVehicle);
            }
        }
        if(!updatedVehicles.isEmpty()){
       		update updatedVehicles;
        }
    }
}