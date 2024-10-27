# Electricity Consumption Forecast - FlutterFlow Integration Guide

A comprehensive guide for integrating the Electricity Consumption Forecast model into your FlutterFlow project.

## Table of Contents
- [Quick Start](#quick-start)
- [FlutterFlow Integration](#flutterflow-integration)
- [Features](#features)
- [Error Handling](#error-handling)
- [Data Persistence](#data-persistence)
- [Advanced Usage](#advanced-usage)
- [Troubleshooting](#troubleshooting)

## Quick Start

1. **Add Dependencies** to your FlutterFlow project:
```yaml
dependencies:
  http: ^0.13.0
  shared_preferences: ^2.0.0
```

2. **Import Custom Code Files**:
- `electricity_service.dart`
- `prediction_storage.dart`
- `error_handler.dart`
- `flutterflow_example.dart`

3. **Configure API Endpoint**:
Update `baseUrl` in `electricity_service.dart` with your API endpoint.

## FlutterFlow Integration

### Step 1: Create Custom Widget

1. In FlutterFlow, go to **Custom Code** section
2. Add new Custom Widget
3. Name it "ElectricityForecastWidget"
4. Import the widget code

### Step 2: Add to FlutterFlow Page

1. Drag a **Custom Widget** component onto your page
2. Select "ElectricityForecastWidget" from the dropdown
3. Configure widget properties if needed

### Step 3: Create Actions

1. Create a new Action in FlutterFlow
2. Add the following code:

```dart
// Initialize services
final electricityService = ElectricityService();
final predictionStorage = PredictionStorage();

try {
  // Get prediction
  final prediction = await electricityService.getForecast([
    FFAppState().hour,
    FFAppState().temperature,
    FFAppState().humidity,
    FFAppState().windSpeed,
    FFAppState().diffuseFlowsGen,
    FFAppState().diffuseFlows,
    FFAppState().dayOfWeek,
    FFAppState().month,
  ]);

  // Save prediction
  await predictionStorage.savePrediction(
    features: features,
    prediction: prediction,
    timestamp: DateTime.now(),
  );

  // Update UI
  setState(() {
    FFAppState().lastPrediction = prediction;
  });

} catch (e) {
  final error = ErrorHandler.handleApiError(e);
  FFAppState().lastError = ErrorHandler.getUserFriendlyMessage(error);
}
```

## Features

### Input Validation
- Hour: 0-23 (integer)
- Temperature: -20 to 50°C (float)
- Humidity: 0-100% (float)
- Wind Speed: 0-150 km/h (float)
- General Diffuse Flows: 0-1500 W/m² (float)
- Diffuse Flows: 0-1500 W/m² (float)
- Day of Week: 0-6 (integer)
- Month: 1-12 (integer)

### Data Persistence
The app stores the last 50 predictions with:
- Input features
- Prediction result
- Timestamp

### Error Handling
Comprehensive error handling for:
- Validation errors
- Network issues
- Server errors
- Timeout errors
- Unknown errors

## Advanced Usage

### Accessing Historical Predictions

```dart
final predictionStorage = PredictionStorage();
final predictions = await predictionStorage.getPredictions();

// Display in ListView
ListView.builder(
  itemCount: predictions.length,
  itemBuilder: (context, index) {
    final prediction = predictions[index];
    return ListTile(
      title: Text('${prediction['prediction']} kWh'),
      subtitle: Text(DateTime.parse(prediction['timestamp']).toString()),
    );
  },
);
```

### Custom Error Handling

```dart
try {
  // Your prediction code
} catch (e) {
  final error = ErrorHandler.handleApiError(e);
  
  switch (error.code) {
    case 'VALIDATION_ERROR':
      // Show validation error UI
      break;
    case 'NETWORK_ERROR':
      // Show network error UI
      break;
    // Handle other cases
  }
}
```

## Error Handling Scenarios

### 1. Input Validation Errors
- Invalid number format
- Out of range values
- Missing required fields

### 2. Network Errors
- No internet connection
- Weak connection
- API endpoint unreachable

### 3. Server Errors
- Internal server error (500)
- Service unavailable (503)
- Bad gateway (502)

### 4. Data Errors
- Invalid response format
- Missing response data
- Corrupted data

### 5. Authentication Errors
- Invalid API key
- Expired token
- Unauthorized access

## Troubleshooting

### Common Issues and Solutions

1. **Widget Not Updating**
   ```dart
   // Force widget update
   setState(() {});
   ```

2. **Data Not Persisting**
   ```dart
   // Check if storage is working
   final prefs = await SharedPreferences.getInstance();
   print(await prefs.getString('electricity_predictions'));
   ```

3. **Network Errors**
   ```dart
   // Add timeout
   final response = await http.post(
     Uri.parse('$baseUrl/predict'),
     headers: {'Content-Type': 'application/json'},
     body: jsonEncode({'features': features}),
   ).timeout(Duration(seconds: 10));
   ```

### Best Practices

1. **Input Validation**
   - Always validate inputs before API calls
   - Show clear error messages
   - Provide input format hints

2. **Error Handling**
   - Use try-catch blocks
   - Show user-friendly error messages
   - Log errors for debugging

3. **Data Persistence**
   - Regular data cleanup
   - Version control for stored data
   - Error handling for storage operations

4. **Performance**
   - Cache frequent predictions
   - Batch API calls when possible
   - Optimize UI updates

## Support

For additional support:
1. Check FlutterFlow documentation
2. Review API documentation
3. Contact support team

## Security Considerations

1. **API Security**
   - Use HTTPS
   - Implement rate limiting
   - Validate all inputs

2. **Data Storage**
   - Encrypt sensitive data
   - Regular data cleanup
   - Secure shared preferences

3. **Error Logging**
   - Remove sensitive data from logs
   - Implement proper error tracking
   - Monitor API usage
