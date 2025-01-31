@isTest
public class TestFetchVehicles {
    
    // Mock implementation for success response
    private class FetchVehiclesMockSuccess implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"Vehicles":[{"vehicleName":"Car A","make":"Toyota","model":"Camry","price":25000,"year":2023},{"vehicleName":"Car B","make":"Honda","model":"Civic","price":22000,"year":2022}]}');
            return res;
        }
    }

    // Mock implementation for empty response
    private class FetchVehiclesMockEmpty implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"Vehicles"}');
            return res;
        }
    }

    // Mock implementation for error response
    private class FetchVehiclesMockError implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(500);
            res.setBody('Internal Server Error');
            return res;
        }
    }

    @isTest
    static void testFetchAndInsertVehicles_Success() {
        Test.setMock(HttpCalloutMock.class, new FetchVehiclesMockSuccess());

        Test.startTest();
        FetchVehicles.fetchAndInsertVehicles();
        Test.stopTest();

        List<Vehicle__c> insertedVehicles = [SELECT Name, Make__c, Model__c, Price__c, Year__c FROM Vehicle__c];
        System.assertEquals(2, insertedVehicles.size(), 'Two vehicles should be inserted.');

        System.assertEquals('Car A', insertedVehicles[0].Name, 'First vehicle name should be Car A.');
        System.assertEquals('Toyota', insertedVehicles[0].Make__c, 'First vehicle make should be Toyota.');
        System.assertEquals(25000, insertedVehicles[0].Price__c, 'First vehicle price should be 25000.');
    }

    @isTest
    static void testFetchAndInsertVehicles_EmptyResponse() {
        Test.setMock(HttpCalloutMock.class, new FetchVehiclesMockEmpty());

        Test.startTest();
        try {
            FetchVehicles.fetchAndInsertVehicles();
            System.assert(true, 'No exception was thrown for empty vehicle response.');
        } catch (exception e) {
            System.assert(e.getMessage().contains('No vehicles data in the response.'));
        }
        Test.stopTest();
    }

    @isTest
    static void testFetchAndInsertVehicles_ErrorResponse() {
        Test.setMock(HttpCalloutMock.class, new FetchVehiclesMockError());

        Test.startTest();
        try {
            FetchVehicles.fetchAndInsertVehicles();
            System.assert(true, 'No exception was thrown for error response.');
        } catch (exception e) {
            System.assert(e.getMessage().contains('Failed to fetch vehicle data.'));
        }
        Test.stopTest();
    }
}