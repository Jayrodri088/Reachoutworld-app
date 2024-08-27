import 'dart:convert';
import 'package:http/http.dart' as http;

class SignInApiService {
  final String baseUrl =
      'http://10.11.0.106/reachoutworlddc/login.html'; // Replace with your actual backend URL

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
        return responseData;
      } else {
        throw Exception(
            'Failed to sign in. Server responded with status code ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to sign in. Error: $e');
    }
  }
}
