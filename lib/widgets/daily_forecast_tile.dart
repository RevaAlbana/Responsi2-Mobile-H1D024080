import 'package:flutter/material.dart';
import '../models/weather_code_mapper.dart';
import '../models/weather_model.dart';

class DailyForecastTile extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastTile({
    super.key,
    required this.forecast,
  });

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();

      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return 'Hari Ini';
      }

      const dayNames = ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'];
      const monthNames = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      final dayName = dayNames[dt.weekday - 1];
      final monthName = monthNames[dt.month - 1];
      return '$dayName, ${dt.day} $monthName';
    } catch (_) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final weatherIcon = WeatherCodeMapper.getIcon(forecast.weatherCode);
    final weatherDesc = WeatherCodeMapper.getDescription(forecast.weatherCode);
    final formattedDate = _formatDate(forecast.date);

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Date & Condition description
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    weatherDesc,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Icon & Rain Probability
            Row(
              children: [
                Icon(
                  weatherIcon,
                  color: const Color(0xFF0288D1),
                  size: 28,
                ),
                const SizedBox(width: 8),
                if (forecast.precipitationProbabilityMax > 0) ...[
                  Row(
                    children: [
                      const Icon(
                        Icons.water_drop,
                        size: 14,
                        color: Colors.blueAccent,
                      ),
                      Text(
                        '${forecast.precipitationProbabilityMax}%',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                ],
              ],
            ),

            // Min & Max Temperature
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${forecast.temperature2mMax.round()}°C',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  '${forecast.temperature2mMin.round()}°C',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
