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
        return 'Hari ini';
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
    final subtext = '$weatherDesc • ${forecast.precipitationProbabilityMax}%';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF223052),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFF374B7A),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Kiri: Nama Hari & Deskripsi + Peluang Hujan
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF6F1E7),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtext,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF8B99B5),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Kanan: Ikon Cuaca & Suhu Maks/Min
          Row(
            children: [
              Icon(
                weatherIcon,
                color: const Color(0xFFF2B66D),
                size: 28,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${forecast.temperature2mMax.round()}°',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF6F1E7),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${forecast.temperature2mMin.round()}°',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF8B99B5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
