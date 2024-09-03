import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpApiService {
  final String baseUrl =
      'http://apps.qubators.biz/reachoutworlddc/register.php'; // Ensure this URL is correct

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
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          if (responseData.containsKey('status') &&
              responseData['status'] == 'success') {
            return responseData;
          } else {
            throw Exception(responseData['message'] ?? 'Unknown error occurred');
          }
        } catch (e) {
          throw Exception('Failed to parse JSON. Server response: ${response.body}');
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
