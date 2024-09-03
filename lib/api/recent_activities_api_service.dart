import 'dart:convert';
import 'package:http/http.dart' as http;

class RecentActivitiesApiService {
  final String baseUrl = 'http://apps.qubators.biz/reachoutworlddc'; // Your server URL

  Future<List<Map<String, dynamic>>> getRecentActivities(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/recent_activities.php?user_id=$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception('Failed to fetch recent activities: ${responseData['message']}');
        }
      } else {
        throw Exception('Failed to fetch recent activities. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network or server error: $e');
    }
  }
}
