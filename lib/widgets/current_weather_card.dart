import 'package:flutter/material.dart';
import '../models/location_model.dart';
import '../models/weather_code_mapper.dart';
import '../models/weather_model.dart';

class CurrentWeatherCard extends StatelessWidget {
  final LocationModel location;
  final CurrentWeather currentWeather;

  const CurrentWeatherCard({
    super.key,
    required this.location,
    required this.currentWeather,
  });

  @override
  Widget build(BuildContext context) {
    final weatherDesc = WeatherCodeMapper.getDescription(currentWeather.weatherCode);
    final weatherIcon = WeatherCodeMapper.getIcon(currentWeather.weatherCode);

    final regionText = [
      if (location.admin1 != null && location.admin1!.isNotEmpty) location.admin1!,
      location.country,
    ].join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF223052),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF374B7A),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: Wilayah & Negara
          if (regionText.isNotEmpty)
            Text(
              regionText,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFFB0BDD6),
                fontWeight: FontWeight.w500,
              ),
            ),
          const SizedBox(height: 12),

          // Baris Tengah: Ikon Cuaca + Suhu Utama & Terasa Seperti
          Row(
            children: [
              Icon(
                weatherIcon,
                size: 64,
                color: const Color(0xFFF2B66D),
              ),
              const SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentWeather.temperature2m.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF6F1E7),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Terasa seperti ${currentWeather.apparentTemperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFB0BDD6),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Baris Bawah: Pill Badge Kondisi Cuaca
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2B3C66),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weatherDesc,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFFF6F1E7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
