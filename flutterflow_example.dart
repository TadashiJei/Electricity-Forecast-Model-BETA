import 'package:flutter/material.dart';
import 'electricity_service.dart';

// Custom widget for numeric input with validation
class NumericInputField extends StatelessWidget {
  final String label;
  final String hint;
  final double min;
  final double max;
  final bool isInteger;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  NumericInputField({
    required this.label,
    required this.hint,
    required this.min,
    required this.max,
    this.isInteger = false,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.numberWithOptions(decimal: !isInteger),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
      validator: validator ?? (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a value';
        }
        final number = double.tryParse(value);
        if (number == null) {
          return 'Please enter a valid number';
        }
        if (isInteger && number % 1 != 0) {
          return 'Please enter a whole number';
        }
        if (number < min || number > max) {
          return 'Value must be between $min and $max';
        }
        return null;
      },
    );
  }
}

// FlutterFlow Custom Widget
class ElectricityForecastWidget extends StatefulWidget {
  const ElectricityForecastWidget({Key? key}) : super(key: key);

  @override
  _ElectricityForecastWidgetState createState() => _ElectricityForecastWidgetState();
}

class _ElectricityForecastWidgetState extends State<ElectricityForecastWidget> {
  final _formKey = GlobalKey<FormState>();
  final _hourController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humidityController = TextEditingController();
  final _windSpeedController = TextEditingController();
  final _diffuseFlowsGenController = TextEditingController();
  final _diffuseFlowsController = TextEditingController();
  final _dayOfWeekController = TextEditingController();
  final _monthController = TextEditingController();
  
  double? _prediction;
  String? _error;

  final _electricityService = ElectricityService();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Electricity Consumption Forecast',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            NumericInputField(
              label: 'Hour of Day',
              hint: 'Enter hour (0-23)',
              min: 0,
              max: 23,
              isInteger: true,
              controller: _hourController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'Temperature (°C)',
              hint: 'Enter temperature',
              min: -20,
              max: 50,
              controller: _temperatureController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'Humidity (%)',
              hint: 'Enter humidity',
              min: 0,
              max: 100,
              controller: _humidityController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'Wind Speed (km/h)',
              hint: 'Enter wind speed',
              min: 0,
              max: 150,
              controller: _windSpeedController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'General Diffuse Flows (W/m²)',
              hint: 'Enter general diffuse flows',
              min: 0,
              max: 1500,
              controller: _diffuseFlowsGenController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'Diffuse Flows (W/m²)',
              hint: 'Enter diffuse flows',
              min: 0,
              max: 1500,
              controller: _diffuseFlowsController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'Day of Week',
              hint: 'Enter day (0=Mon, 6=Sun)',
              min: 0,
              max: 6,
              isInteger: true,
              controller: _dayOfWeekController,
            ),
            SizedBox(height: 10),
            NumericInputField(
              label: 'Month',
              hint: 'Enter month (1-12)',
              min: 1,
              max: 12,
              isInteger: true,
              controller: _monthController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getForecast,
              child: Text('Get Forecast'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
            if (_prediction != null) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Column(
                  children: [
                    Text(
                      'Predicted Consumption',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${_prediction!.toStringAsFixed(2)} kWh',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_error != null) ...[
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _getForecast() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _prediction = null;
      _error = null;
    });

    try {
      final features = [
        double.parse(_hourController.text),
        double.parse(_temperatureController.text),
        double.parse(_humidityController.text),
        double.parse(_windSpeedController.text),
        double.parse(_diffuseFlowsGenController.text),
        double.parse(_diffuseFlowsController.text),
        double.parse(_dayOfWeekController.text),
        double.parse(_monthController.text),
      ];

      final prediction = await _electricityService.getForecast(features);
      setState(() {
        _prediction = prediction;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _hourController.dispose();
    _temperatureController.dispose();
    _humidityController.dispose();
    _windSpeedController.dispose();
    _diffuseFlowsGenController.dispose();
    _diffuseFlowsController.dispose();
    _dayOfWeekController.dispose();
    _monthController.dispose();
    super.dispose();
  }
}
