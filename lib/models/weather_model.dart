class CurrentWeather {
  final double temperature2m;
  final int relativeHumidity2m;
  final double apparentTemperature;
  final double precipitation;
  final int weatherCode;
  final double windSpeed10m;

  CurrentWeather({
    required this.temperature2m,
    required this.relativeHumidity2m,
    required this.apparentTemperature,
    required this.precipitation,
    required this.weatherCode,
    required this.windSpeed10m,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature2m:
          (json['temperature_2m'] ?? json['temperature2m'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity2m:
          (json['relative_humidity_2m'] ?? json['relativeHumidity2m'] as num?)?.toInt() ?? 0,
      apparentTemperature:
          (json['apparent_temperature'] ?? json['apparentTemperature'] as num?)?.toDouble() ?? 0.0,
      precipitation:
          (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode:
          (json['weather_code'] ?? json['weatherCode'] as num?)?.toInt() ?? 0,
      windSpeed10m:
          (json['wind_speed_10m'] ?? json['windSpeed10m'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature_2m': temperature2m,
      'relative_humidity_2m': relativeHumidity2m,
      'apparent_temperature': apparentTemperature,
      'precipitation': precipitation,
      'weather_code': weatherCode,
      'wind_speed_10m': windSpeed10m,
    };
  }
}

class DailyForecast {
  final String date;
  final int weatherCode;
  final double temperature2mMax;
  final double temperature2mMin;
  final int precipitationProbabilityMax;

  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.temperature2mMax,
    required this.temperature2mMin,
    required this.precipitationProbabilityMax,
  });

  factory DailyForecast.fromJson(Map<String, dynamic> json) {
    return DailyForecast(
      date: (json['date'] ?? json['time'] ?? '') as String,
      weatherCode:
          (json['weather_code'] ?? json['weatherCode'] as num?)?.toInt() ?? 0,
      temperature2mMax:
          (json['temperature_2m_max'] ?? json['temperature2mMax'] as num?)?.toDouble() ?? 0.0,
      temperature2mMin:
          (json['temperature_2m_min'] ?? json['temperature2mMin'] as num?)?.toDouble() ?? 0.0,
      precipitationProbabilityMax:
          (json['precipitation_probability_max'] ?? json['precipitationProbabilityMax'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'weather_code': weatherCode,
      'temperature_2m_max': temperature2mMax,
      'temperature_2m_min': temperature2mMin,
      'precipitation_probability_max': precipitationProbabilityMax,
    };
  }
}

class WeatherResponse {
  final CurrentWeather current;
  final List<DailyForecast> daily;

  WeatherResponse({
    required this.current,
    required this.daily,
  });

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    final currentWeather = CurrentWeather.fromJson(
      json['current'] is Map<String, dynamic>
          ? json['current'] as Map<String, dynamic>
          : {},
    );

    List<DailyForecast> dailyList = [];
    if (json['daily'] is Map<String, dynamic>) {
      final dailyMap = json['daily'] as Map<String, dynamic>;
      final times = (dailyMap['time'] as List?)?.map((e) => e.toString()).toList() ?? [];
      final weatherCodes = (dailyMap['weather_code'] ?? dailyMap['weatherCode'] as List?) ?? [];
      final tempMaxs = (dailyMap['temperature_2m_max'] ?? dailyMap['temperature2mMax'] as List?) ?? [];
      final tempMins = (dailyMap['temperature_2m_min'] ?? dailyMap['temperature2mMin'] as List?) ?? [];
      final precipProbs = (dailyMap['precipitation_probability_max'] ?? dailyMap['precipitationProbabilityMax'] as List?) ?? [];

      for (int i = 0; i < times.length; i++) {
        dailyList.add(
          DailyForecast(
            date: times[i],
            weatherCode: (i < weatherCodes.length && weatherCodes[i] != null)
                ? (weatherCodes[i] as num).toInt()
                : 0,
            temperature2mMax: (i < tempMaxs.length && tempMaxs[i] != null)
                ? (tempMaxs[i] as num).toDouble()
                : 0.0,
            temperature2mMin: (i < tempMins.length && tempMins[i] != null)
                ? (tempMins[i] as num).toDouble()
                : 0.0,
            precipitationProbabilityMax:
                (i < precipProbs.length && precipProbs[i] != null)
                    ? (precipProbs[i] as num).toInt()
                    : 0,
          ),
        );
      }
    } else if (json['daily'] is List) {
      dailyList = (json['daily'] as List)
          .map((item) => DailyForecast.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return WeatherResponse(
      current: currentWeather,
      daily: dailyList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current': current.toJson(),
      'daily': daily.map((e) => e.toJson()).toList(),
    };
  }
}
