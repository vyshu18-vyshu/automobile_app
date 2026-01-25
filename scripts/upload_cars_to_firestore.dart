import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/car_data.dart';

/// Script to upload all cars from car_data.dart to Firestore
/// Run this once to populate your Firebase database
Future<void> uploadCarsToFirestore() async {
  final firestore = FirebaseFirestore.instance;
  final carsCollection = firestore.collection('cars');

  print('Starting upload of ${allCarsData.length} cars to Firestore...');

  int successCount = 0;
  int errorCount = 0;

  for (final car in allCarsData) {
    try {
      // Convert Car model to JSON
      final carJson = car.toJson();
      
      // Upload using the car's ID as the document ID
      await carsCollection.doc(car.id).set(carJson);
      
      successCount++;
      print('✓ Uploaded: ${car.brand} ${car.model} ($successCount/${allCarsData.length})');
    } catch (e) {
      errorCount++;
      print('✗ Failed to upload ${car.brand} ${car.model}: $e');
    }
  }

  print('\n=== Upload Complete ===');
  print('Success: $successCount');
  print('Errors: $errorCount');
  print('Total: ${allCarsData.length}');
}

void main() async {
  print('Firebase Data Migration Tool');
  print('============================\n');
  
  print('This will upload ${allCarsData.length} cars to Firestore.');
  print('Make sure you have initialized Firebase in your app first!');
  print('\nPress Enter to continue or Ctrl+C to cancel...');
  stdin.readLineSync();
  
  try {
    await uploadCarsToFirestore();
    print('\n✓ Migration completed successfully!');
  } catch (e) {
    print('\n✗ Migration failed: $e');
    exit(1);
  }
}
