public class FetchVehicles {
    public static void fetchAndInsertVehicles() {
        try {
            // API Endpoint
            String endpoint = 'https://run.mocky.io/v3/f2ba340f-cf83-449d-b320-420ca565c19a';
            // Make the HTTP GET request
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            HttpResponse response = http.send(request);
            // Check if the response is successful
            if (response.getStatusCode() == 200) {
                // Parse the JSON response
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> vehicles = (List<Object>) jsonResponse.get('Vehicles');
                // Check if the 'Vehicles' key exists and has data
                if (vehicles != null) {
                    // Prepare list for new Vehicle__c records
                    List<Vehicle__c> newVehicles = new List<Vehicle__c>();
 
                    // Loop through vehicles and map to Vehicle__c object
                    for (Object obj : vehicles) {
                        Map<String, Object> vehicleData = (Map<String, Object>) obj;
 
                        // Ensure all fields are present
                        if (vehicleData != null) {
                            Vehicle__c vehicle = new Vehicle__c();
 
                            vehicle.Name = (String) vehicleData.get('vehicleName');
                            vehicle.Make__c = (String) vehicleData.get('make');
                            vehicle.Model__c = (String) vehicleData.get('model');
                            vehicle.Price__c = Decimal.valueOf(vehicleData.get('price').toString());
                            vehicle.Year__c = Integer.valueOf(vehicleData.get('year').toString());
 
                            newVehicles.add(vehicle);
                        }
                    }
 
                    // Insert new Vehicle records
                    if (!newVehicles.isEmpty()) {
                        insert newVehicles;
                    } 
                } 
            } 
        } catch (Exception e) {
            System.debug('Error: ' + e.getMessage());
        }
    }
}