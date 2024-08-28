import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.11.0.106/reachoutworlddc'; // Base URL without the endpoint

  // Modify this method to include userId
  Future<Map<String, dynamic>> registerUser(String userId, String name, String email, String phone, String country) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/data_capture.php'),  // Complete endpoint here
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': userId,  // Send user_id along with other data
          'name': name,
          'email': email,
          'phone': phone,
          'country': country,
        },
      ).timeout(const Duration(seconds: 10)); // Set a timeout for the request

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to capture data: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/get_users.php')).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'success') {
          return data['data'];
        } else {
          throw Exception(data['message']);
        }
      } else {
        throw Exception('Failed to fetch users: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
