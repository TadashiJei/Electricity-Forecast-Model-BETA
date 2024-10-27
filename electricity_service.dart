import 'package:http/http.dart' as http;
import 'dart:convert';

class ElectricityService {
  final String baseUrl = 'YOUR_API_URL'; // Replace with your deployed API URL

  Future<double> getForecast(List<double> features) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/predict'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'features': features,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['prediction'];
      } else {
        throw Exception('Failed to get forecast');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
