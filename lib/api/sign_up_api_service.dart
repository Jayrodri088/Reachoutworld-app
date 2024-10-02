import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpApiService {
  final String baseUrl =
      'http://apps.qubators.biz/reachoutworlddc/register.php'; // Correct backend URL

  Future<Map<String, dynamic>> registerUser(
      String name, String email, String country, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': name,
            'email': email,
            'country': country,
            'password': password,
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Attempt to parse the JSON response from the backend
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check for a success or error message from the server
        if (responseData['status'] == 'success') {
          return responseData;
        } else if (responseData['status'] == 'error') {
          return responseData;  // Return error message
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to register user. Server responded with status code ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to register user. Error: $error');
    }
  }
}
