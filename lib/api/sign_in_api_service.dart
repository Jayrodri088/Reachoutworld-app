import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInApiService {
  final String baseUrl =
      'http://10.11.0.106/reachoutworlddc/login.php'; // Correct backend URL for the sign-in endpoint

  Future<Map<String, dynamic>> signInUser(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'password': password,
        }),
      );

      // Debugging the response
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData.containsKey('user_id')) {
          // Ensure the response contains a user_id
          return responseData;
        } else {
          throw Exception('Invalid response: Missing user_id');
        }
      } else {
        throw Exception(
            'Failed to sign in. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in. Error: $e');
    }
  }
}
