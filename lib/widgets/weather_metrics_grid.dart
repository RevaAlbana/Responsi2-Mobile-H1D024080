import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../models/weather_model.dart';

class WeatherMetricsGrid extends StatelessWidget {
  final CurrentWeather currentWeather;
  final int? precipitationProbabilityMax;

  const WeatherMetricsGrid({
    super.key,
    required this.currentWeather,
    this.precipitationProbabilityMax,
  });

  @override
  Widget build(BuildContext context) {
    final metrics = [
      _MetricItem(
        icon: LucideIcons.droplet,
        label: 'Kelembapan',
        value: '${currentWeather.relativeHumidity2m}%',
      ),
      _MetricItem(
        icon: LucideIcons.wind,
        label: 'Kecepatan angin',
        value: '${currentWeather.windSpeed10m.toStringAsFixed(1)} km/h',
      ),
      _MetricItem(
        icon: LucideIcons.cloudRain,
        label: 'Curah hujan',
        value: '${currentWeather.precipitation.toStringAsFixed(1)} mm',
      ),
      _MetricItem(
        icon: LucideIcons.umbrella,
        label: 'Peluang hujan',
        value: '${precipitationProbabilityMax ?? 0}%',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.0,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final item = metrics[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF223052),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xFF374B7A),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFF2B3C66),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  item.icon,
                  color: const Color(0xFFF2B66D),
                  size: 22,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8B99B5),
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF6F1E7),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MetricItem {
  final IconData icon;
  final String label;
  final String value;

  _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
  });
}
