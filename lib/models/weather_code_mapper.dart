import 'package:flutter/material.dart';

class WeatherCodeMapper {
  static String getDescription(int code) {
    switch (code) {
      case 0:
        return 'Cerah';
      case 1:
        return 'Cerah Berawan';
      case 2:
        return 'Berawan Sebagian';
      case 3:
        return 'Mendung';
      case 45:
      case 48:
        return 'Kabut';
      case 51:
        return 'Gerimis Ringan';
      case 53:
        return 'Gerimis Sedang';
      case 55:
        return 'Gerimis Lebat';
      case 56:
      case 57:
        return 'Gerimis Dingin';
      case 61:
        return 'Hujan Ringan';
      case 63:
        return 'Hujan Sedang';
      case 65:
        return 'Hujan Lebat';
      case 66:
      case 67:
        return 'Hujan Es';
      case 71:
        return 'Salju Ringan';
      case 73:
        return 'Salju Sedang';
      case 75:
        return 'Salju Lebat';
      case 77:
        return 'Bintik Salju';
      case 80:
        return 'Hujan Singkat Ringan';
      case 81:
        return 'Hujan Singkat Sedang';
      case 82:
        return 'Hujan Singkat Lebat';
      case 85:
        return 'Badai Salju Ringan';
      case 86:
        return 'Badai Salju Lebat';
      case 95:
        return 'Badai Petir';
      case 96:
      case 99:
        return 'Badai Petir dengan Hujan Es';
      default:
        return 'Kondisi Tidak Diketahui';
    }
  }

  static IconData getIcon(int code) {
    switch (code) {
      case 0:
        return Icons.wb_sunny;
      case 1:
        return Icons.wb_sunny_outlined;
      case 2:
        return Icons.wb_cloudy;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.cloudy_snowing;
      case 51:
      case 53:
      case 55:
        return Icons.grain;
      case 56:
      case 57:
        return Icons.ac_unit;
      case 61:
      case 63:
        return Icons.water_drop;
      case 65:
        return Icons.grain;
      case 66:
      case 67:
        return Icons.ac_unit;
      case 71:
      case 73:
      case 75:
      case 77:
        return Icons.ac_unit;
      case 80:
      case 81:
      case 82:
        return Icons.umbrella;
      case 85:
      case 86:
        return Icons.ac_unit;
      case 95:
      case 96:
      case 99:
        return Icons.thunderstorm;
      default:
        return Icons.help_outline;
    }
  }
}
