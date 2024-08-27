import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost/Data-app/reachoutworlddc'; // Change this to your live server URL

  Future<Map<String, dynamic>> registerUser(String name, String email, String phone, String country) async {
    final response = await http.post(
      Uri.parse('$baseUrl/data_capture.php'),
      body: {
        'name': name,
        'email': email,
        'phone': phone,
        'country': country,
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to capture data');
    }
  }

  Future<List<dynamic>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/get_users.php'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['data'];
      } else {
        throw Exception(data['message']);
      }
    } else {
      throw Exception('Failed to fetch users');
    }
  }
}
