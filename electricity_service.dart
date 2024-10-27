import 'package:http/http.dart' as http;
import 'dart:convert';

class ValidationException implements Exception {
  final String message;
  ValidationException(this.message);
  @override
  String toString() => message;
}

class ElectricityService {
  final String baseUrl = 'YOUR_API_URL'; // Replace with your deployed API URL

  // Input validation
  void validateFeatures(List<double> features) {
    if (features.length != 8) {
      throw ValidationException('Exactly 8 features are required');
    }

    // Hour validation (0-23)
    if (features[0] < 0 || features[0] > 23 || features[0] % 1 != 0) {
      throw ValidationException('Hour must be an integer between 0 and 23');
    }

    // Temperature validation (-20 to 50°C)
    if (features[1] < -20 || features[1] > 50) {
      throw ValidationException('Temperature must be between -20°C and 50°C');
    }

    // Humidity validation (0-100%)
    if (features[2] < 0 || features[2] > 100) {
      throw ValidationException('Humidity must be between 0% and 100%');
    }

    // Wind Speed validation (0-150 km/h)
    if (features[3] < 0 || features[3] > 150) {
      throw ValidationException('Wind speed must be between 0 and 150 km/h');
    }

    // General Diffuse Flows validation (0-1500 W/m²)
    if (features[4] < 0 || features[4] > 1500) {
      throw ValidationException('General diffuse flows must be between 0 and 1500 W/m²');
    }

    // Diffuse Flows validation (0-1500 W/m²)
    if (features[5] < 0 || features[5] > 1500) {
      throw ValidationException('Diffuse flows must be between 0 and 1500 W/m²');
    }

    // Day of Week validation (0-6)
    if (features[6] < 0 || features[6] > 6 || features[6] % 1 != 0) {
      throw ValidationException('Day of week must be an integer between 0 and 6');
    }

    // Month validation (1-12)
    if (features[7] < 1 || features[7] > 12 || features[7] % 1 != 0) {
      throw ValidationException('Month must be an integer between 1 and 12');
    }
  }

  Future<double> getForecast(List<double> features) async {
    try {
      // Validate input features
      validateFeatures(features);

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
        throw Exception('Failed to get forecast: ${response.body}');
      }
    } catch (e) {
      if (e is ValidationException) {
        rethrow;
      }
      throw Exception('Error: $e');
    }
  }
}
