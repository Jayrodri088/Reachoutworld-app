import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.11.0.106/reachoutworlddc'; // Your live server URL

  Future<Map<String, dynamic>> registerUser(String userId, String name, String email, String phone, String country) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/data_capture.php'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded', // Ensure this matches what your backend expects
        },
        body: {
          'user_id': userId, // Send the user ID along with other form data
          'name': name,
          'email': email,
          'phone': phone,
          'country': country,
        },
      ).timeout(const Duration(seconds: 10)); // Timeout to avoid infinite waiting

      // Debugging the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body); // Ensure this returns a valid Map
      } else {
        throw Exception('Failed to capture data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in registerUser API call: $e');
      throw Exception('Network or server error: $e');
    }
  }
}