import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiService {
  final String baseUrl = 'http://apps.qubators.biz/reachoutworlddc'; // Your live server URL

  // Updated method signature to include region and zone
  Future<Map<String, dynamic>> registerUser(
      String userId,
      String name,
      String email,
      String phone,
      String country,
      String? userCountry,  // Nullable location parameters
      String? userState,
      String? userRegion,   // User region
      String? region,       // New region field
      String? zone) async { // New zone field
    try {
      // Send the POST request with JSON data
      final response = await http.post(
        Uri.parse('$baseUrl/data_capture.php'),
        headers: {
          'Content-Type': 'application/json', // Ensure JSON content is sent
        },
        body: json.encode(
          {
            'user_id': userId,
            'name': name,
            'email': email,
            'phone': phone,
            'country': country,
            'user_country': userCountry ?? 'N/A', // If null, send 'N/A'
            'user_state': userState ?? 'N/A',     // If null, send 'N/A'
            'user_region': userRegion ?? 'N/A',   // Corrected to match backend expectations
            'region': region ?? 'N/A',            // Region field
            'zone': zone ?? 'N/A',                // Zone field
          },
        ),
      ).timeout(const Duration(seconds: 120)); // Set timeout for request

      // Debugging: Print response for troubleshooting
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle the response from the server
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response indicates success
        if (responseData.containsKey('status') && responseData['status'] == 'success') {
          return responseData; // Successfully captured data
        } else {
          // Handle error message from the server
          throw Exception(responseData['message'] ?? 'Failed to capture data');
        }
      } else {
        // Handle non-200 status codes
        throw Exception('Failed to capture data. Status code: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      // Handle timeout error
      throw Exception('Request timeout. Please try again.');
    } on Exception catch (e) {
      // Handle general network or server errors
      print('Error in registerUser API call: $e');
      throw Exception('Network or server error: $e');
    }
  }
}
