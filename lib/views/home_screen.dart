import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/daily_forecast_tile.dart';
import '../widgets/weather_metrics_grid.dart';
import 'search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        final location = viewModel.selectedLocation;
        final isFavorite = location != null && viewModel.isLocationFavorite(location.id);

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF172036),
            centerTitle: false,
            title: Row(
              children: [
                const Icon(
                  LucideIcons.mapPin,
                  color: Color(0xFFF2B66D),
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    location?.name ?? 'Responsi Cuaca',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF6F1E7),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            actions: [
              if (location != null)
                IconButton(
                  icon: Icon(
                    LucideIcons.bookmark,
                    color: isFavorite ? const Color(0xFFF2B66D) : const Color(0xFFF6F1E7),
                  ),
                  tooltip: isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                  onPressed: () {
                    viewModel.toggleFavorite(location);
                  },
                ),
              IconButton(
                icon: const Icon(
                  LucideIcons.search,
                  color: Color(0xFFF6F1E7),
                ),
                tooltip: 'Cari Lokasi',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
          body: _buildBody(context, viewModel),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, WeatherViewModel viewModel) {
    if (viewModel.isLoadingWeather && viewModel.weatherData == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: Color(0xFFF2B66D),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat data cuaca...',
              style: TextStyle(fontSize: 16, color: Color(0xFF8B99B5)),
            ),
          ],
        ),
      );
    }

    if (viewModel.weatherError != null && viewModel.weatherData == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.cloudOff,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              const Text(
                'Terjadi Kesalahan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6F1E7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.weatherError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF8B99B5)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2B66D),
                  foregroundColor: const Color(0xFF172036),
                ),
                onPressed: () => viewModel.fetchWeather(),
                icon: const Icon(LucideIcons.refreshCw),
                label: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (viewModel.weatherData == null || viewModel.selectedLocation == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.cloudOff,
                size: 64,
                color: Color(0xFF8B99B5),
              ),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Data Cuaca',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6F1E7),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan cari dan pilih kota terlebih dahulu.',
                style: TextStyle(color: Color(0xFF8B99B5)),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2B66D),
                  foregroundColor: const Color(0xFF172036),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                icon: const Icon(LucideIcons.search),
                label: const Text('Cari Kota'),
              ),
            ],
          ),
        ),
      );
    }

    final weather = viewModel.weatherData!;
    final location = viewModel.selectedLocation!;
    final todayPrecipProb = weather.daily.isNotEmpty
        ? weather.daily.first.precipitationProbabilityMax
        : 0;

    return RefreshIndicator(
      color: const Color(0xFFF2B66D),
      backgroundColor: const Color(0xFF223052),
      onRefresh: () async {
        await viewModel.fetchWeather();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CurrentWeatherCard(
              location: location,
              currentWeather: weather.current,
            ),
            const SizedBox(height: 24),
            const Text(
              'Detail hari ini',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF6F1E7),
              ),
            ),
            const SizedBox(height: 12),
            WeatherMetricsGrid(
              currentWeather: weather.current,
              precipitationProbabilityMax: todayPrecipProb,
            ),
            const SizedBox(height: 24),
            if (weather.daily.isNotEmpty) ...[
              const Text(
                'Prakiraan harian',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF6F1E7),
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: weather.daily.length,
                itemBuilder: (context, index) {
                  return DailyForecastTile(
                    forecast: weather.daily[index],
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
