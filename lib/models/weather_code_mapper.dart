import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

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
        return LucideIcons.sun;
      case 1:
      case 2:
        return LucideIcons.cloudSun;
      case 3:
        return LucideIcons.cloud;
      case 45:
      case 48:
        return LucideIcons.cloudFog;
      case 51:
      case 53:
      case 55:
      case 56:
      case 57:
        return LucideIcons.cloudDrizzle;
      case 61:
      case 63:
      case 65:
      case 66:
      case 67:
      case 80:
      case 81:
      case 82:
        return LucideIcons.cloudRain;
      case 71:
      case 73:
      case 75:
      case 77:
      case 85:
      case 86:
        return LucideIcons.cloudSnow;
      case 95:
      case 96:
      case 99:
        return LucideIcons.cloudLightning;
      default:
        return LucideIcons.cloud;
    }
  }
}
