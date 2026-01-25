import 'package:share_plus/share_plus.dart';
import '../models/car_model.dart';
import 'analytics_service.dart';

/// Service for sharing car information
class ShareService {
  /// Share a car's details
  static Future<void> shareCar(Car car, {String? subject}) async {
    final text = _buildShareText(car);
    
    try {
      await Share.share(
        text,
        subject: subject ?? car.fullName,
      );
      
      // Track share event
      await AnalyticsService.logCarShare(car.id, car.fullName);
    } catch (e) {
      print('Error sharing car: $e');
    }
  }

  /// Share a car with an image (requires file path)
  static Future<void> shareCarWithImage(
    Car car,
    String imagePath, {
    String? subject,
  }) async {
    final text = _buildShareText(car);
    
    try {
      await Share.shareXFiles(
        [XFile(imagePath)],
        text: text,
        subject: subject ?? car.fullName,
      );
      
      await AnalyticsService.logCarShare(car.id, car.fullName);
    } catch (e) {
      print('Error sharing car with image: $e');
    }
  }

  /// Build the share message text
  static String _buildShareText(Car car) {
    return '''
🚗 Check out the ${car.fullName}!

💰 Price: ${car.formattedPrice}
⚡ ${car.horsepower} HP | 🏎️ ${car.topSpeed} km/h
⭐ ${car.rating}/5.0 (${car.reviews} reviews)

${car.description}

Learn more: ${car.officialUrl.isNotEmpty ? car.officialUrl : 'Available in AutoMobile App'}
''';
  }

  /// Share app download link (for referrals)
  static Future<void> shareApp() async {
    const text = '''
🚗 Discover your dream car with AutoMobile App!

Browse 50+ premium cars, compare specs, calculate EMI, and more.

Download now: [App Store Link]
''';
    
    try {
      await Share.share(text, subject: 'Check out AutoMobile App!');
    } catch (e) {
      print('Error sharing app: $e');
    }
  }
}
