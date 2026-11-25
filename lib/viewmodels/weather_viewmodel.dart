import 'package:flutter/foundation.dart';
import '../models/location_model.dart';
import '../models/weather_model.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService;
  final StorageService _storageService;

  WeatherViewModel({
    WeatherService? weatherService,
    StorageService? storageService,
  })  : _weatherService = weatherService ?? WeatherService(),
        _storageService = storageService ?? StorageService();

  // State cuaca aktif
  LocationModel? _selectedLocation;
  WeatherResponse? _weatherData;
  bool _isLoadingWeather = false;
  String? _weatherError;

  // State pencarian lokasi
  List<LocationModel> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;
  bool _hasSearched = false;

  // State lokasi favorit
  List<LocationModel> _favoriteLocations = [];

  // Getters state cuaca
  LocationModel? get selectedLocation => _selectedLocation;
  WeatherResponse? get weatherData => _weatherData;
  bool get isLoadingWeather => _isLoadingWeather;
  String? get weatherError => _weatherError;

  // Getters state pencarian
  List<LocationModel> get searchResults => _searchResults;
  bool get isSearching => _isSearching;
  String? get searchError => _searchError;
  bool get hasSearched => _hasSearched;

  // Getters state favorit
  List<LocationModel> get favoriteLocations => _favoriteLocations;

  /// Inisialisasi awal: memuat lokasi favorit dan lokasi terakhir.
  /// Jika lokasi terakhir tidak ada, memuat lokasi default ("Purwokerto") dari Rest API.
  Future<void> init() async {
    try {
      _favoriteLocations = await _storageService.getFavorites();
      notifyListeners();

      final lastLoc = await _storageService.getLastLocation();
      if (lastLoc != null) {
        _selectedLocation = lastLoc;
        await fetchWeather();
      } else {
        final defaultLocations = await _weatherService.searchLocations('Purwokerto');
        if (defaultLocations.isNotEmpty) {
          _selectedLocation = defaultLocations.first;
          await _storageService.saveLastLocation(_selectedLocation!);
          await fetchWeather();
        } else {
          _weatherError = 'Lokasi default tidak ditemukan.';
          notifyListeners();
        }
      }
    } catch (e) {
      _weatherError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  /// Memilih lokasi baru, meng-update penyimpanan lokasi terakhir, dan mengambil data cuaca.
  Future<void> selectLocation(LocationModel location) async {
    _selectedLocation = location;
    await _storageService.saveLastLocation(location);
    notifyListeners();
    await fetchWeather();
  }

  /// Mengambil data cuaca terbaru dari REST API Open-Meteo berdasarkan lokasi yang dipilih.
  Future<void> fetchWeather() async {
    if (_selectedLocation == null) return;

    _isLoadingWeather = true;
    _weatherError = null;
    notifyListeners();

    try {
      final data = await _weatherService.getWeather(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );
      _weatherData = data;
    } catch (e) {
      _weatherError = e.toString().replaceAll('Exception: ', '');
    } finally {
      _isLoadingWeather = false;
      notifyListeners();
    }
  }

  /// Mencari kota/lokasi melalui Open-Meteo Geocoding API.
  Future<void> searchCity(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.isEmpty) {
      _searchResults = [];
      _hasSearched = false;
      _searchError = null;
      _isSearching = false;
      notifyListeners();
      return;
    }

    _isSearching = true;
    _hasSearched = true;
    _searchError = null;
    notifyListeners();

    try {
      final results = await _weatherService.searchLocations(trimmedQuery);
      _searchResults = results;
    } catch (e) {
      _searchError = e.toString().replaceAll('Exception: ', '');
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Menambah atau menghapus lokasi favorit dari storage.
  Future<void> toggleFavorite(LocationModel location) async {
    final isFav = isLocationFavorite(location.id);
    if (isFav) {
      await _storageService.removeFavorite(location.id);
    } else {
      await _storageService.saveFavorite(location);
    }
    _favoriteLocations = await _storageService.getFavorites();
    notifyListeners();
  }

  /// Mengecek apakah suatu lokasi ada di dalam daftar lokasi favorit.
  bool isLocationFavorite(int id) {
    return _favoriteLocations.any((loc) => loc.id == id);
  }
}
