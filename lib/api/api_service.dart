import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';

class ApiService {
  final String baseUrl = 'http://apps.qubators.biz/reachoutworlddc'; // Your live server URL

  Future<Map<String, dynamic>> registerUser(
      String userId, String name, String email, String phone, String country) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/data_capture.php'),
        headers: {
          'Content-Type': 'application/json', // If PHP expects form data
        },
        body: json.encode(
          {
          'user_id': userId, // Ensure this matches the input expected by your PHP backend
          'name': name,
          'email': email,
          'phone': phone,
          'country': country,
        },
        )
      ).timeout(const Duration(seconds: 10)); // Set a timeout to prevent long wait times

      // Debugging the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      // Handle response
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if the response contains a status and is successful
        if (responseData.containsKey('status') && responseData['status'] == 'success') {
          return responseData; // Successfully captured data
        } else {
          throw Exception(responseData['message'] ?? 'Failed to capture data');
        }
      } else {
        throw Exception('Failed to capture data. Status code: ${response.statusCode}');
      }
    } on TimeoutException catch (_) {
      throw Exception('Request timeout. Please try again.');
    } on Exception catch (e) {
      print('Error in registerUser API call: $e');
      throw Exception('Network or server error: $e');
    }
  }
}
