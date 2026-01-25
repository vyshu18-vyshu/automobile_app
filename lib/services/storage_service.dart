import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  /// Initialize storage service - call this in main()
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ============ Favorites ============

  static Future<void> saveFavorites(List<String> carIds) async {
    await _prefs?.setStringList('favorites', carIds);
  }

  static List<String> getFavorites() {
    return _prefs?.getStringList('favorites') ?? [];
  }

  static Future<void> addFavorite(String carId) async {
    final favorites = getFavorites();
    if (!favorites.contains(carId)) {
      favorites.add(carId);
      await saveFavorites(favorites);
    }
  }

  static Future<void> removeFavorite(String carId) async {
    final favorites = getFavorites();
    favorites.remove(carId);
    await saveFavorites(favorites);
  }

  static bool isFavorite(String carId) {
    return getFavorites().contains(carId);
  }

  // ============ Recently Viewed ============

  static Future<void> addRecentlyViewed(String carId) async {
    var recents = getRecentlyViewed();
    recents.remove(carId); // Remove if already exists
    recents.insert(0, carId); // Add to front
    if (recents.length > 10) {
      recents = recents.sublist(0, 10); // Limit to 10 items
    }
    await _prefs?.setStringList('recently_viewed', recents);
  }

  static List<String> getRecentlyViewed() {
    return _prefs?.getStringList('recently_viewed') ?? [];
  }

  static Future<void> clearRecentlyViewed() async {
    await _prefs?.remove('recently_viewed');
  }

  // ============ Search Preferences ============

  static Future<void> saveLastSearch(String query) async {
    await _prefs?.setString('last_search', query);
  }

  static String? getLastSearch() {
    return _prefs?.getString('last_search');
  }

  // ============ Comparison ============

  static Future<void> saveComparison(List<String> carIds) async {
    await _prefs?.setStringList('comparison', carIds);
  }

  static List<String> getComparison() {
    return _prefs?.getStringList('comparison') ?? [];
  }

  static Future<void> addToComparison(String carId) async {
    final comparison = getComparison();
    if (!comparison.contains(carId) && comparison.length < 3) {
      comparison.add(carId);
      await saveComparison(comparison);
    }
  }

  static Future<void> removeFromComparison(String carId) async {
    final comparison = getComparison();
    comparison.remove(carId);
    await saveComparison(comparison);
  }

  static Future<void> clearComparison() async {
    await _prefs?.remove('comparison');
  }

  // ============ General ============

  static Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
