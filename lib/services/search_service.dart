import '../models/car_model.dart';

enum SortBy {
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  nameAZ,
}

class PriceRange {
  final double min;
  final double max;

  const PriceRange(this.min, this.max);
}

class SearchService {
  /// Search and filter cars based on various criteria
  static List<Car> searchCars(
    List<Car> cars, {
    String? query,
    PriceRange? priceRange,
    String? category,
    String? fuelType,
    SortBy? sortBy,
  }) {
    var results = List<Car>.from(cars);

    // Text search (car name, brand, model)
    if (query != null && query.trim().isNotEmpty) {
      final searchQuery = query.toLowerCase().trim();
      results = results.where((car) {
        return car.fullName.toLowerCase().contains(searchQuery) ||
            car.brand.toLowerCase().contains(searchQuery) ||
            car.model.toLowerCase().contains(searchQuery);
      }).toList();
    }

    // Price filter
    if (priceRange != null) {
      results = results.where((car) {
        return car.price >= priceRange.min && car.price <= priceRange.max;
      }).toList();
    }

    // Category filter
    if (category != null && category != 'All') {
      results = results.where((car) => car.category == category).toList();
    }

    // Fuel type filter
    if (fuelType != null && fuelType != 'All') {
      results = results.where((car) {
        return car.fuelType.toLowerCase().contains(fuelType.toLowerCase());
      }).toList();
    }

    // Sort results
    if (sortBy != null) {
      switch (sortBy) {
        case SortBy.priceLowToHigh:
          results.sort((a, b) => a.price.compareTo(b.price));
          break;
        case SortBy.priceHighToLow:
          results.sort((a, b) => b.price.compareTo(a.price));
          break;
        case SortBy.ratingHighToLow:
          results.sort((a, b) => b.rating.compareTo(a.rating));
          break;
        case SortBy.nameAZ:
          results.sort((a, b) => a.fullName.compareTo(b.fullName));
          break;
      }
    }

    return results;
  }

  /// Get unique categories from car list
  static List<String> getCategories(List<Car> cars) {
    final categories = cars.map((car) => car.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  /// Get unique fuel types from car list
  static List<String> getFuelTypes(List<Car> cars) {
    final fuelTypes = cars
        .map((car) => car.fuelType.split('/').first.trim())
        .toSet()
        .toList();
    fuelTypes.sort();
    return ['All', ...fuelTypes];
  }
}
