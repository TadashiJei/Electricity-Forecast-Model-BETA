import 'package:shared_preferences.dart';
import 'dart:convert';

class PredictionStorage {
  static const String _storageKey = 'electricity_predictions';
  
  Future<void> savePrediction({
    required List<double> features,
    required double prediction,
    required DateTime timestamp,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final predictions = await getPredictions();
    
    predictions.add({
      'features': features,
      'prediction': prediction,
      'timestamp': timestamp.toIso8601String(),
    });

    // Keep only last 50 predictions
    if (predictions.length > 50) {
      predictions.removeAt(0);
    }

    await prefs.setString(_storageKey, jsonEncode(predictions));
  }

  Future<List<Map<String, dynamic>>> getPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);
    
    if (storedData == null) {
      return [];
    }

    final List<dynamic> decoded = jsonDecode(storedData);
    return decoded.cast<Map<String, dynamic>>();
  }

  Future<void> clearPredictions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}