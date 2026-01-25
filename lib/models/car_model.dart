import 'package:intl/intl.dart';

class Car {
  final String id;
  final String brand;
  final String model;
  final double price;
  final String imageUrl;
  final String description;
  final double rating;
  final int reviews;
  final int topSpeed;
  final double acceleration;
  final int seats;
  final int horsepower;
  final String transmission;
  final String category;
  final bool isFeatured;
  final bool isFavorite;
  final String fuelType;
  final String engine;
  final String mileage;
  final String bodyType;
  final String officialUrl;
  final List<String> keyFeatures;

  const Car({
    required this.id,
    required this.brand,
    required this.model,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.rating = 0.0,
    this.reviews = 0,
    required this.topSpeed,
    required this.acceleration,
    this.seats = 4,
    this.horsepower = 0,
    this.transmission = 'Auto',
    required this.category,
    this.isFeatured = false,
    this.isFavorite = false,
    this.fuelType = 'Petrol',
    this.engine = '',
    this.mileage = '',
    this.bodyType = 'Sedan',
    this.officialUrl = '',
    this.keyFeatures = const [],
    this.variants = const [],
  });
  
  final List<String> variants;

  String get fullName => '$brand $model';

  String get formattedPrice {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );
    return formatter.format(price);
  }

  // Convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'rating': rating,
      'reviews': reviews,
      'topSpeed': topSpeed,
      'acceleration': acceleration,
      'seats': seats,
      'horsepower': horsepower,
      'transmission': transmission,
      'category': category,
      'isFeatured': isFeatured,
      'isFavorite': isFavorite,
      'fuelType': fuelType,
      'engine': engine,
      'mileage': mileage,
      'bodyType': bodyType,
      'officialUrl': officialUrl,
      'keyFeatures': keyFeatures,
      'variants': variants,
    };
  }

  // Create from JSON
  factory Car.fromJson(Map<String, dynamic> json) {
    return Car(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviews: json['reviews'] as int? ?? 0,
      topSpeed: json['topSpeed'] as int,
      acceleration: (json['acceleration'] as num).toDouble(),
      seats: json['seats'] as int? ?? 4,
      horsepower: json['horsepower'] as int? ?? 0,
      transmission: json['transmission'] as String? ?? 'Auto',
      category: json['category'] as String,
      isFeatured: json['isFeatured'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      fuelType: json['fuelType'] as String? ?? 'Petrol',
      engine: json['engine'] as String? ?? '',
      mileage: json['mileage'] as String? ?? '',
      bodyType: json['bodyType'] as String? ?? 'Sedan',
      officialUrl: json['officialUrl'] as String? ?? '',
      keyFeatures: (json['keyFeatures'] as List<dynamic>?)?.cast<String>() ?? [],
      variants: (json['variants'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }
}
