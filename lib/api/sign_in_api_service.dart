import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInApiService {
  final String baseUrl = 'http://apps.qubators.biz/reachoutworlddc/login.php'; // Correct backend URL

  Future<Map<String, dynamic>> signInUser(String email, String password) async {
    try {
      // Sending data as application/x-www-form-urlencoded
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'email': email,
          'password': password,
        },
      );

      // Debugging the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          // Login success, return the full response
          return responseData;
        } else if (responseData['status'] == 'error') {
          // Login failed, return the error message
          return responseData;
        } else {
          // Handle unexpected responses
          throw Exception('Unexpected server response.');
        }
      } else {
        // Handle non-200 HTTP responses
        throw Exception(
            'Failed to sign in. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in. Error: $e');
    }
  }
}
