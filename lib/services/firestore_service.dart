import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/car_model.dart';

/// Firestore Service for cloud data operations
/// Handles: Cars, Favorites, History
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections
  static const String _carsCollection = 'cars';
  static const String _usersCollection = 'users';

  // Get all cars
  Future<List<Car>> getCars() async {
    try {
      final snapshot = await _firestore.collection(_carsCollection).get();
      return snapshot.docs
          .map((doc) => Car.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      print('Error fetching cars: $e');
      return [];
    }
  }

  // Get car by ID
  Future<Car?> getCarById(String id) async {
    try {
      final doc = await _firestore.collection(_carsCollection).doc(id).get();
      if (doc.exists) {
        return Car.fromJson({...doc.data()!, 'id': doc.id});
      }
      return null;
    } catch (e) {
      print('Error fetching car: $e');
      return null;
    }
  }

  // Search/filter cars
  Future<List<Car>> searchCars({
    String? query,
    String? category,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      Query<Map<String, dynamic>> qry = _firestore.collection(_carsCollection);

      if (category != null && category.isNotEmpty) {
        qry = qry.where('category', isEqualTo: category);
      }

      if (minPrice != null) {
        qry = qry.where('price', isGreaterThanOrEqualTo: minPrice);
      }

      if (maxPrice != null) {
        qry = qry.where('price', isLessThanOrEqualTo: maxPrice);
      }

      final snapshot = await qry.get();
      var cars = snapshot.docs
          .map((doc) => Car.fromJson({...doc.data(), 'id': doc.id}))
          .toList();

      // Client-side text search (Firestore doesn't support full-text search well)
      if (query != null && query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        cars = cars.where((car) {
          return car.brand.toLowerCase().contains(lowerQuery) ||
              car.model.toLowerCase().contains(lowerQuery) ||
              car.fullName.toLowerCase().contains(lowerQuery);
        }).toList();
      }

      return cars;
    } catch (e) {
      print('Error searching cars: $e');
      return [];
    }
  }

  // === USER-SPECIFIC DATA ===

  String? get _userId => _auth.currentUser?.uid;

  // Save favorite
  Future<void> saveFavorite(String carId) async {
    if (_userId == null) return;
    await _firestore
        .collection(_usersCollection)
        .doc(_userId)
        .collection('favorites')
        .doc(carId)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  // Remove favorite
  Future<void> removeFavorite(String carId) async {
    if (_userId == null) return;
    await _firestore
        .collection(_usersCollection)
        .doc(_userId)
        .collection('favorites')
        .doc(carId)
        .delete();
  }

  // Get all favorites
  Future<List<String>> getFavorites() async {
    if (_userId == null) return [];
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(_userId)
        .collection('favorites')
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  // Add to history
  Future<void> addToHistory(String carId) async {
    if (_userId == null) return;
    await _firestore
        .collection(_usersCollection)
        .doc(_userId)
        .collection('history')
        .doc(carId)
        .set({'timestamp': FieldValue.serverTimestamp()});
  }

  // Get history
  Future<List<String>> getHistory() async {
    if (_userId == null) return [];
    final snapshot = await _firestore
        .collection(_usersCollection)
        .doc(_userId)
        .collection('history')
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }
}
