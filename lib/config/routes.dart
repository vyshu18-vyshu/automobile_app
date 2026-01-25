import 'package:flutter/material.dart';
import '../features/splash/splash_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/signup_screen.dart';
import '../features/main_navigation/main_wrapper.dart';
import '../features/home/home_screen.dart';
import '../features/cars/car_list_screen.dart';
import '../features/cars/car_details_screen.dart';
import '../features/booking/test_drive_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/tools/emi_calculator_screen.dart';
import '../features/compare/compare_screen.dart';
import '../features/dealers/dealer_locator_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/financing/financing_screen.dart';
import '../features/viewer/car_360_viewer_screen.dart';
import '../features/insurance/insurance_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String home = '/home';
  static const String cars = '/cars';
  static const String details = '/details';
  static const String booking = '/booking';
  static const String profile = '/profile';
  static const String emiCalculator = '/emi-calculator';
  static const String compare = '/compare';
  static const String dealers = '/dealers';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  static const String financing = '/financing';
  static const String viewer360 = '/360-view';
  static const String insurance = '/insurance';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    login: (context) => const LoginScreen(),
    signup: (context) => const SignupScreen(),
    main: (context) => const MainWrapper(),
    home: (context) => const HomeScreen(),
    cars: (context) => const CarListScreen(),
    details: (context) => const CarDetailsScreen(),
    booking: (context) => const TestDriveScreen(),
    profile: (context) => const ProfileScreen(),
    emiCalculator: (context) => const EMICalculatorScreen(),
    compare: (context) => const CompareScreen(),
    dealers: (context) => const DealerLocatorScreen(),
    settings: (context) => const SettingsScreen(),
    notifications: (context) => const NotificationsScreen(),
    financing: (context) => const FinancingScreen(),
    viewer360: (context) => const Car360ViewerScreen(),
    insurance: (context) => const InsuranceScreen(),
  };
}
