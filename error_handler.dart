class ElectricityForecastError extends Error {
  final String message;
  final String code;
  final dynamic details;

  ElectricityForecastError({
    required this.message,
    required this.code,
    this.details,
  });

  @override
  String toString() => 'Error ($code): $message';
}

class ErrorHandler {
  static ElectricityForecastError handleApiError(dynamic error) {
    if (error is ValidationException) {
      return ElectricityForecastError(
        message: error.toString(),
        code: 'VALIDATION_ERROR',
      );
    }

    if (error.toString().contains('Failed to get forecast')) {
      return ElectricityForecastError(
        message: 'Server error occurred. Please try again later.',
        code: 'SERVER_ERROR',
        details: error.toString(),
      );
    }

    if (error.toString().contains('SocketException')) {
      return ElectricityForecastError(
        message: 'Network connection error. Please check your internet connection.',
        code: 'NETWORK_ERROR',
      );
    }

    if (error.toString().contains('TimeoutException')) {
      return ElectricityForecastError(
        message: 'Request timed out. Please try again.',
        code: 'TIMEOUT_ERROR',
      );
    }

    return ElectricityForecastError(
      message: 'An unexpected error occurred. Please try again.',
      code: 'UNKNOWN_ERROR',
      details: error.toString(),
    );
  }

  static String getUserFriendlyMessage(ElectricityForecastError error) {
    switch (error.code) {
      case 'VALIDATION_ERROR':
        return error.message;
      case 'SERVER_ERROR':
        return 'Our servers are experiencing issues. Please try again in a few minutes.';
      case 'NETWORK_ERROR':
        return 'Unable to connect to the server. Please check your internet connection.';
      case 'TIMEOUT_ERROR':
        return 'The request took too long to complete. Please try again.';
      default:
        return 'Something went wrong. Please try again later.';
    }
  }
}