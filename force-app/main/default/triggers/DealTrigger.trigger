trigger DealTrigger on Deal__c (before insert, after update) {
    if(Trigger.isBefore) {
        if(Trigger.isInsert) {
    		DealTriggerHandler.preventDealCreation(Trigger.new);
        }
    }
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
			DealTriggerHandler.updateInventory(Trigger.new,Trigger.oldMap);
        }
    }
}