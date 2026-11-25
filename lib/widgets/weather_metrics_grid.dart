import 'package:flutter/material.dart';
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
        icon: Icons.water_drop,
        iconColor: Colors.blue,
        label: 'Kelembapan',
        value: '${currentWeather.relativeHumidity2m}%',
      ),
      _MetricItem(
        icon: Icons.air,
        iconColor: Colors.teal,
        label: 'Kecepatan Angin',
        value: '${currentWeather.windSpeed10m.toStringAsFixed(1)} km/h',
      ),
      _MetricItem(
        icon: Icons.grain,
        iconColor: Colors.indigo,
        label: 'Curah Hujan',
        value: '${currentWeather.precipitation.toStringAsFixed(1)} mm',
      ),
      _MetricItem(
        icon: Icons.umbrella,
        iconColor: Colors.deepPurple,
        label: 'Peluang Hujan',
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
        childAspectRatio: 2.2,
      ),
      itemCount: metrics.length,
      itemBuilder: (context, index) {
        final item = metrics[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: item.iconColor.withValues(alpha: 0.12),
                  child: Icon(
                    item.icon,
                    color: item.iconColor,
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
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricItem {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  _MetricItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });
}
