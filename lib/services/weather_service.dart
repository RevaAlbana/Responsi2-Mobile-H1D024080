import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/location_model.dart';
import '../models/weather_model.dart';

class WeatherService {
  Future<List<LocationModel>> searchLocations(String query) async {
    final encodedQuery = Uri.encodeComponent(query);
    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$encodedQuery&count=10&language=id&format=json',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data.containsKey('results') && data['results'] != null) {
          final List results = data['results'] as List;
          return results
              .map((item) => LocationModel.fromJson(item as Map<String, dynamic>))
              .toList();
        }
        return [];
      } else {
        throw Exception(
            'Gagal mencari lokasi. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal terhubung ke layanan geocoding: $e');
    }
  }

  Future<WeatherResponse> getWeather(double latitude, double longitude) async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m,relative_humidity_2m,apparent_temperature,precipitation,weather_code,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return WeatherResponse.fromJson(data);
      } else {
        throw Exception(
            'Gagal mengambil data cuaca. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal terhubung ke layanan cuaca: $e');
    }
  }
}
