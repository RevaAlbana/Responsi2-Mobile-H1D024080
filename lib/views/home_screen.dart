import 'package:flutter/material.dart';
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
            title: Text(location?.name ?? 'Responsi Cuaca'),
            actions: [
              if (location != null)
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.bookmark : Icons.bookmark_border,
                    color: isFavorite ? Colors.amberAccent : Colors.white,
                  ),
                  tooltip: isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit',
                  onPressed: () {
                    viewModel.toggleFavorite(location);
                  },
                ),
              IconButton(
                icon: const Icon(Icons.search),
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
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Memuat data cuaca...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
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
                Icons.error_outline,
                size: 64,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 16),
              Text(
                'Terjadi Kesalahan',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.weatherError!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => viewModel.fetchWeather(),
                icon: const Icon(Icons.refresh),
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
                Icons.cloud_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              const Text(
                'Belum Ada Data Cuaca',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan cari dan pilih kota terlebih dahulu.',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.search),
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
            const SizedBox(height: 20),
            Text(
              'Detail Cuaca Hari Ini',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            WeatherMetricsGrid(
              currentWeather: weather.current,
              precipitationProbabilityMax: todayPrecipProb,
            ),
            const SizedBox(height: 24),
            if (weather.daily.isNotEmpty) ...[
              Text(
                'Prakiraan Cuaca Harian',
                style: Theme.of(context).textTheme.titleLarge,
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
