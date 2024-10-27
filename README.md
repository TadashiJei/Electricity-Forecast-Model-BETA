# Electricity Forecast Model Integration Guide

This repository contains a machine learning model for electricity forecasting, integrated with FastAPI backend and Flutter/FlutterFlow frontend.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Model Export](#model-export)
- [Backend Setup](#backend-setup)
- [Frontend Integration](#frontend-integration)
- [FlutterFlow Integration](#flutterflow-integration)
- [API Documentation](#api-documentation)
- [Model Features](#model-features)
- [Troubleshooting](#troubleshooting)

## Prerequisites
- Python 3.7+
- Flutter SDK
- FlutterFlow account
- Google Colab (for model training)
- FastAPI
- Joblib

## Project Structure
```
├── main.py                         # FastAPI backend server
├── electricity_service.dart        # Flutter service for API calls
├── electricity_forecast_model.joblib # Trained ML model
└── requirements.txt                # Python dependencies
```

## Model Features
The model expects the following 8 features in this exact order:

1. **Hour of Day** (0-23)
   - Integer value representing the hour of the day
   - Example: 14 (2:00 PM)

2. **Temperature** (°C)
   - Float value of the temperature in Celsius
   - Example: 25.5

3. **Humidity** (%)
   - Float value of relative humidity percentage
   - Example: 65.0

4. **Wind Speed** (km/h)
   - Float value of wind speed in kilometers per hour
   - Example: 12.3

5. **General Diffuse Flows** (W/m²)
   - Float value measuring solar radiation
   - Example: 100.5

6. **Diffuse Flows** (W/m²)
   - Float value of diffuse solar radiation
   - Example: 80.2

7. **Day of Week** (0-6)
   - Integer value representing the day of the week
   - 0 = Monday, 6 = Sunday
   - Example: 2 (Wednesday)

8. **Month** (1-12)
   - Integer value representing the month
   - Example: 7 (July)

### Example Feature List
```python
features = [
    14,     # Hour: 2 PM
    25.5,   # Temperature: 25.5°C
    65.0,   # Humidity: 65%
    12.3,   # Wind Speed: 12.3 km/h
    100.5,  # General Diffuse Flows: 100.5 W/m²
    80.2,   # Diffuse Flows: 80.2 W/m²
    2,      # Day of Week: Wednesday
    7       # Month: July
]
```

## Model Export
1. Open your model in Google Colab
2. Add the following code at the end of your notebook:
```python
import joblib

# Save the model
joblib.dump(model, 'electricity_forecast_model.joblib')

# Download to local machine
from google.colab import files
files.download('electricity_forecast_model.joblib')
```
3. Run the cell and save the downloaded model file

## Backend Setup

1. Install required Python packages:
```bash
pip install fastapi uvicorn joblib numpy pydantic scikit-learn
```

2. Place your `electricity_forecast_model.joblib` file in the same directory as `main.py`

3. Start the FastAPI server:
```bash
python main.py
```

4. The API will be available at `http://localhost:8000`

### Deploy to Production
1. Choose a cloud provider (e.g., Heroku, Google Cloud, or AWS)
2. Deploy the FastAPI application
3. Note down your deployed API URL

## Frontend Integration

### Flutter Service Setup
1. Add HTTP dependency to your `pubspec.yaml`:
```yaml
dependencies:
  http: ^0.13.0
```

2. Update the `baseUrl` in `electricity_service.dart` with your deployed API URL:
```dart
final String baseUrl = 'https://your-deployed-api.com';
```

### Example API Usage in Flutter
```dart
final features = [
    14,     // Hour
    25.5,   // Temperature
    65.0,   // Humidity
    12.3,   // Wind Speed
    100.5,  // General Diffuse Flows
    80.2,   // Diffuse Flows
    2,      // Day of Week
    7       // Month
];

final prediction = await electricityService.getForecast(features);
print('Predicted electricity consumption: ${prediction.toStringAsFixed(2)} kWh');
```

## FlutterFlow Integration

1. **Custom Code Integration**:
   - In FlutterFlow, go to Custom Code section
   - Add `electricity_service.dart` as a custom code file

2. **Action Setup**:
   - Create a new action in FlutterFlow
   - Use the following code snippet:
```dart
final electricityService = ElectricityService();
try {
  final prediction = await electricityService.getForecast([
    hourController.value,          // Hour
    temperatureController.value,   // Temperature
    humidityController.value,      // Humidity
    windSpeedController.value,     // Wind Speed
    diffuseFlowsGenController.value, // General Diffuse Flows
    diffuseFlowsController.value,  // Diffuse Flows
    dayOfWeekController.value,     // Day of Week
    monthController.value          // Month
  ]);
  // Use the prediction value in your UI
} catch (e) {
  // Handle error
}
```

3. **UI Integration**:
   - Create input fields for all 8 features
   - Add validation for each input field
   - Add a button to trigger the prediction
   - Create a display widget for the prediction result

## API Documentation

### Predict Endpoint
- **URL**: `/predict`
- **Method**: POST
- **Request Body**:
```json
{
  "features": [14, 25.5, 65.0, 12.3, 100.5, 80.2, 2, 7]
}
```
- **Response**:
```json
{
  "prediction": 45.67
}
```

## Input Validation
Ensure your input values are within these ranges:
- Hour: 0-23 (integer)
- Temperature: -20 to 50 (float)
- Humidity: 0-100 (float)
- Wind Speed: 0-150 (float)
- General Diffuse Flows: 0-1500 (float)
- Diffuse Flows: 0-1500 (float)
- Day of Week: 0-6 (integer)
- Month: 1-12 (integer)

## Troubleshooting

### Common Issues
1. **Model Loading Error**:
   - Ensure the model file is in the correct location
   - Verify model file permissions
   - Check if all scikit-learn dependencies are installed

2. **API Connection Issues**:
   - Check if the API URL is correct
   - Verify network connectivity
   - Ensure CORS is properly configured

3. **Prediction Errors**:
   - Verify all 8 features are provided in the correct order
   - Check if feature values are within expected ranges
   - Ensure numeric types are correct (integers/floats)

### Support
For additional support:
1. Check the FastAPI documentation
2. Visit FlutterFlow documentation
3. Review the model training notebook in Google Colab

## Security Considerations
1. Implement proper authentication
2. Secure your API endpoints
3. Validate input data ranges
4. Use HTTPS in production
5. Handle sensitive data appropriately

## Performance Optimization
1. Cache frequent predictions
2. Implement batch processing if needed
3. Optimize model size and loading
4. Use appropriate instance sizes for deployment
