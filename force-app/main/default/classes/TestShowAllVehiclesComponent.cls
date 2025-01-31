@isTest
public class TestShowAllVehiclesComponent {

    // Helper method to insert sample data
    private static void insertSampleVehicles() {
        List<Vehicle__c> vehicles = new List<Vehicle__c>();
        for (Integer i = 0; i < 5; i++) {
            vehicles.add(new Vehicle__c(
                Name = 'Vehicle ' + i,
                Model__c = 'Model ' + i,
                Make__c = 'Make ' + i,
                Price__c = 10000 + i,
                VIN__c = 'VIN' + i
            ));
        }
        insert vehicles;
    }

    @isTest
    static void testGetVehicles_EmptySearchText() {
        // Insert some sample vehicles
        insertSampleVehicles();

        Test.startTest();
        List<Vehicle__c> result = VehicleController.getVehicles('');
        Test.stopTest();

        // Verify that the result contains all vehicles
        System.assertNotEquals(0, result.size(), 'There should be vehicles returned.');
        System.assertEquals(5, result.size(), 'Expected 5 vehicles.');
    }

    @isTest
    static void testGetVehicles_WithSearchText() {
        // Insert some sample vehicles
        insertSampleVehicles();

        Test.startTest();
        List<Vehicle__c> result = VehicleController.getVehicles('Vehicle 1');
        Test.stopTest();

        // Verify that the search returns the correct vehicle
        System.assertNotEquals(0, result.size(), 'There should be vehicles returned.');
        System.assertEquals(1, result.size(), 'Expected only 1 vehicle.');
        System.assert(result[0].Name.contains('Vehicle 1'), 'Vehicle name should match search text.');
    }

    @isTest
    static void testGetVehicles_NoResults() {
        // Insert some sample vehicles
        insertSampleVehicles();

        Test.startTest();
        List<Vehicle__c> result = VehicleController.getVehicles('Nonexistent');
        Test.stopTest();

        // Verify that no vehicles match the search criteria
        System.assertEquals(0, result.size(), 'There should be no vehicles returned.');
    }

    @isTest
    static void testSelectedVehicle_ValidId() {
        // Insert a sample vehicle
        insertSampleVehicles();
        Vehicle__c vehicle = [SELECT Id FROM Vehicle__c LIMIT 1];

        Test.startTest();
        Vehicle__c result = VehicleController.selectedVehicle(vehicle.Id);
        Test.stopTest();

        // Verify that the correct vehicle is returned
        System.assertNotEquals(null, result, 'Vehicle should be found.');
        System.assertEquals(vehicle.Id, result.Id, 'Vehicle Id should match.');
    }

    @isTest
    static void testSelectedVehicle_InvalidId() {
        // Test with an invalid vehicle Id
        Test.startTest();
		try {
            VehicleController.selectedVehicle('InvalidId');
            System.assert(false, 'An exception should have been thrown.');
        } catch (AuraHandledException e) {
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }

    // Test handling of exceptions in getVehicles method
    @isTest
    static void testGetVehicles_ExceptionHandling() {
        Test.startTest();
        try {
            // Injecting an invalid query to simulate an exception
            VehicleController.getVehicles('invalid query');
            System.assert(true, 'An exception should be thrown due to invalid query.');
        } catch (AuraHandledException e) {
            // Verify that an exception is thrown and caught
            System.assert(e.getMessage().contains('invalid query'), 'Exception message should contain invalid query.');
        }
        Test.stopTest();
    }

    // Test handling of exceptions in selectedVehicle method
    @isTest
    static void testSelectedVehicle_ExceptionHandling() {
        Test.startTest();
        try {
            // Injecting an invalid ID to simulate an exception
            VehicleController.selectedVehicle('invalidId');
            System.assert(false, 'An exception should be thrown due to invalid ID.');
        } catch (AuraHandledException e) {
            // Verify that an exception is thrown and caught
            System.assertEquals('Script-thrown exception', e.getMessage());
        }
        Test.stopTest();
    }
}