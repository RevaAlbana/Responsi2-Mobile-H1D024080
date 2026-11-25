import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/location_model.dart';

class StorageService {
  static const String _favoritesKey = 'favorite_locations';
  static const String _lastLocationKey = 'last_location';

  Future<List<LocationModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonStringList = prefs.getStringList(_favoritesKey);
    if (jsonStringList == null) {
      return [];
    }
    return jsonStringList.map((item) {
      final Map<String, dynamic> jsonMap = jsonDecode(item);
      return LocationModel.fromJson(jsonMap);
    }).toList();
  }

  Future<void> saveFavorite(LocationModel location) async {
    final favorites = await getFavorites();
    if (!favorites.any((loc) => loc.id == location.id)) {
      favorites.add(location);
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonStringList =
          favorites.map((loc) => jsonEncode(loc.toJson())).toList();
      await prefs.setStringList(_favoritesKey, jsonStringList);
    }
  }

  Future<void> removeFavorite(int locationId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((loc) => loc.id == locationId);
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonStringList =
        favorites.map((loc) => jsonEncode(loc.toJson())).toList();
    await prefs.setStringList(_favoritesKey, jsonStringList);
  }

  Future<bool> isFavorite(int locationId) async {
    final favorites = await getFavorites();
    return favorites.any((loc) => loc.id == locationId);
  }

  Future<void> saveLastLocation(LocationModel location) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(location.toJson());
    await prefs.setString(_lastLocationKey, jsonString);
  }

  Future<LocationModel?> getLastLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_lastLocationKey);
    if (jsonString == null) {
      return null;
    }
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return LocationModel.fromJson(jsonMap);
  }
}
