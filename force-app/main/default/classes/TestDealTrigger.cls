@isTest
public class TestDealTrigger {
    @isTest
    static void testPreventDealCreation() {
        // Step 1: Create a Vehicle with zero inventory
        Vehicle__c vehicle = new Vehicle__c(Name = 'Car A', Inventory__c = 0);
        insert vehicle;

        // Step 2: Create a Customer
        Customer__c customer = new Customer__c(Name = 'Jane Doe', Email__c = 'janedoe@example.com', Phone__c = '9876543210');
        insert customer;

        // Step 3: Create a Deal for the vehicle with zero inventory
        Deal__c deal = new Deal__c(
            Vehicle__c = vehicle.Id, 
            Customer__c = customer.Id, 
            Status__c = 'New', 
            Actual_Price__c = 10000, 
            Discount_Amount__c = 500, 
            Purchase_Date__c = Date.today()
        );

        Test.startTest();
        try {
            insert deal;
            System.assert(false, 'Deal creation should have failed due to zero inventory.');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('Insufficient inventory count for the requested deal.'), 
                'Error message should indicate insufficient inventory.');
        }
        Test.stopTest();
    }

    @isTest
    static void testUpdateInventory() {
        // Step 1: Create a Vehicle with inventory
        Vehicle__c vehicle = new Vehicle__c(Name = 'Car B', Inventory__c = 1);
        insert vehicle;

        // Step 2: Create a Customer
        Customer__c customer = new Customer__c(Name = 'John Smith', Email__c = 'johnsmith@example.com', Phone__c = '1231231234');
        insert customer;

        // Step 3: Create a Deal
        Deal__c deal = new Deal__c(
            Vehicle__c = vehicle.Id, 
            Customer__c = customer.Id, 
            Status__c = 'New', 
            Actual_Price__c = 15000, 
            Discount_Amount__c = 1000, 
            Purchase_Date__c = Date.today()
        );
        insert deal;

        // Step 4: Update Deal to "Approved"
        deal.Status__c = 'Approved';

        Test.startTest();
        update deal;
        Test.stopTest();

        // Step 5: Validate Inventory Update
        Vehicle__c updatedVehicle = [SELECT Inventory__c FROM Vehicle__c WHERE Id = :vehicle.Id];
        System.assertEquals(0, updatedVehicle.Inventory__c, 'Inventory should decrease by 1.');
    }

    @isTest
    static void testBulkProcessing() {
        // Step 1: Create Vehicles
        Vehicle__c vehicle1 = new Vehicle__c(Name = 'Car D', Inventory__c = 2);
        Vehicle__c vehicle2 = new Vehicle__c(Name = 'Car E', Inventory__c = 3);
        insert new List<Vehicle__c>{ vehicle1, vehicle2 };

        // Step 2: Create a Customer
        Customer__c customer = new Customer__c(Name = 'Alice Doe', Email__c = 'alicedoe@example.com', Phone__c = '4567891230');
        insert customer;

        // Step 3: Create Deals
        Deal__c deal1 = new Deal__c(
            Vehicle__c = vehicle1.Id, 
            Customer__c = customer.Id, 
            Status__c = 'New', 
            Actual_Price__c = 12000, 
            Discount_Amount__c = 500, 
            Purchase_Date__c = Date.today()
        );
        Deal__c deal2 = new Deal__c(
            Vehicle__c = vehicle2.Id, 
            Customer__c = customer.Id, 
            Status__c = 'New', 
            Actual_Price__c = 18000, 
            Discount_Amount__c = 700, 
            Purchase_Date__c = Date.today()
        );
        insert new List<Deal__c>{ deal1, deal2 };

        // Step 4: Update Deals to "Approved" in bulk
        List<Deal__c> dealUpdates = [
            SELECT Id, Status__c, Vehicle__c FROM Deal__c
            WHERE Id IN :new Set<Id>{deal1.Id, deal2.Id}
        ];
        for (Deal__c deal : dealUpdates) {
            deal.Status__c = 'Approved';
        }

        Test.startTest();
        update dealUpdates;
        Test.stopTest();

        // Step 5: Validate Inventory Updates
        Vehicle__c updatedVehicle1 = [SELECT Inventory__c FROM Vehicle__c WHERE Id = :vehicle1.Id];
        Vehicle__c updatedVehicle2 = [SELECT Inventory__c FROM Vehicle__c WHERE Id = :vehicle2.Id];

        System.assertEquals(1, updatedVehicle1.Inventory__c, 'Inventory for Vehicle 1 should decrease by 1.');
        System.assertEquals(2, updatedVehicle2.Inventory__c, 'Inventory for Vehicle 2 should decrease by 1.');
    }
}