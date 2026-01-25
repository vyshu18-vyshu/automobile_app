import 'package:firebase_analytics/firebase_analytics.dart';

/// Analytics service for tracking user behavior and app usage
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver observer = 
      FirebaseAnalyticsObserver(analytics: _analytics);

  // Screen tracking
  static Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);
  }

  // Car interactions
  static Future<void> logCarView(String carId, String carName) async {
    await _analytics.logEvent(
      name: 'view_car',
      parameters: {
        'car_id': carId,
        'car_name': carName,
      },
    );
  }

  static Future<void> logCarShare(String carId, String carName) async {
    await _analytics.logEvent(
      name: 'share_car',
      parameters: {
        'car_id': carId,
        'car_name': carName,
      },
    );
  }

  static Future<void> logAddToFavorites(String carId, String carName) async {
    await _analytics.logEvent(
      name: 'add_favorite',
      parameters: {
        'car_id': carId,
        'car_name': carName,
      },
    );
  }

  static Future<void> logRemoveFromFavorites(String carId, String carName) async {
    await _analytics.logEvent(
      name: 'remove_favorite',
      parameters: {
        'car_id': carId,
        'car_name': carName,
      },
    );
  }

  static Future<void> logAddToCompare(String carId, String carName) async {
    await _analytics.logEvent(
      name: 'add_to_compare',
      parameters: {
        'car_id': carId,
        'car_name': carName,
      },
    );
  }

  // Search tracking
  static Future<void> logSearch(String query, int resultsCount) async {
    await _analytics.logSearch(
      searchTerm: query,
    );
  }

  static Future<void> logFilterUsed(String filterType, String filterValue) async {
    await _analytics.logEvent(
      name: 'filter_applied',
      parameters: {
        'filter_type': filterType,
        'filter_value': filterValue,
      },
    );
  }

  // Auth events
  static Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  static Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  // EMI Calculator
  static Future<void> logEMICalculation({
    required double loanAmount,
    required double interestRate,
    required int tenure,
  }) async {
    await _analytics.logEvent(
      name: 'emi_calculated',
      parameters: {
        'loan_amount': loanAmount,
        'interest_rate': interestRate,
        'tenure_months': tenure,
      },
    );
  }

  // App usage
  static Future<void> logAppOpen() async {
    await _analytics.logAppOpen();
  }

  // Errors
  static Future<void> logError(String errorType, String errorMessage) async {
    await _analytics.logEvent(
      name: 'app_error',
      parameters: {
        'error_type': errorType,
        'error_message': errorMessage.substring(0, 100), // Limit length
      },
    );
  }

  // Custom events
  static Future<void> logCustomEvent(String eventName, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(
      name: eventName,
      parameters: parameters.cast<String, Object>(),
    );
  }
}
