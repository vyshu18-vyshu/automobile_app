import '../models/car_model.dart';
import 'car_data.dart';
import 'firestore_service.dart';

class ApiService {
  static final FirestoreService _firestoreService = FirestoreService();
  static bool _useFirestore = true; // Toggle for cloud vs local

  static Future<List<Car>> getCars() async {
    if (_useFirestore) {
      try {
        final cars = await _firestoreService.getCars();
        if (cars.isNotEmpty) return cars;
      } catch (e) {
        print('Firestore fetch failed, using local data: $e');
      }
    }
    // Fallback to local data
    await Future.delayed(const Duration(milliseconds: 500));
    return allCarsData;
  }

  static Future<List<Car>> getFeaturedCars() async {
    final allCars = await getCars();
    return allCars.where((car) => [
      'bugatti_chiron', 'ferrari_sf90', 'tesla_model_s', 'mahindra_xuv700', 'maruti_grand_vitara'
    ].contains(car.id) || car.rating >= 4.9).take(10).toList();
  }

  static Future<List<Car>> getCarsByCategory(String category) async {
    final allCars = await getCars();
    if (category == 'All') return allCars;
    return allCars.where((car) => car.category == category).toList();
  }
  
  static Future<List<Car>> getCarsByBrand(String brandName) async {
    final allCars = await getCars();
    return allCars.where((car) => car.brand == brandName).toList();
  }

  static Future<List<Map<String, String>>> getBrands() async {
    final allCars = await getCars();
    final brands = allCars.map((e) => e.brand).toSet().toList();
    brands.sort();
    
    return brands.map((brand) => {
      'name': brand,
      'logo': _getBrandLogoUrl(brand),
    }).toList();
  }
  
  static String _getBrandLogoUrl(String brand) {
    final slug = brand.toLowerCase().replaceAll(' ', '-').replaceAll('ë', 'e').replaceAll('š', 's');
    return 'https://www.carlogos.org/car-logos/$slug-logo.png'; 
  }
  
  // Popular brands with logos
  static List<Map<String, String>> get popularBrands => [
    {'name': 'Toyota', 'logo': _getBrandLogoUrl('Toyota')},
    {'name': 'Mercedes', 'logo': _getBrandLogoUrl('Mercedes-Benz')},
    {'name': 'BMW', 'logo': _getBrandLogoUrl('BMW')},
    {'name': 'Audi', 'logo': _getBrandLogoUrl('Audi')},
    {'name': 'Tesla', 'logo': _getBrandLogoUrl('Tesla')},
    {'name': 'Ferrari', 'logo': _getBrandLogoUrl('Ferrari')},
  ];
}
