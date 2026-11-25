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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0288D1), Color(0xFF01579B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0288D1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                color: Colors.white70,
                size: 20,
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  location.name,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (regionText.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              regionText,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                weatherIcon,
                size: 64,
                color: Colors.amberAccent,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentWeather.temperature2m.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Terasa seperti ${currentWeather.apparentTemperature.toStringAsFixed(1)}°C',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              weatherDesc,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
