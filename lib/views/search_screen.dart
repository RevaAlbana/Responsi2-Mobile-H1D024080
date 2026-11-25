import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(WeatherViewModel viewModel) {
    FocusScope.of(context).unfocus();
    viewModel.searchCity(_searchController.text);
  }

  void _onClearSearch(WeatherViewModel viewModel) {
    _searchController.clear();
    viewModel.searchCity('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cari Lokasi'),
      ),
      body: Consumer<WeatherViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input Pencarian
                TextField(
                  controller: _searchController,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _onSearchSubmitted(viewModel),
                  decoration: InputDecoration(
                    hintText: 'Masukkan nama kota (cth: Purwokerto, Jakarta)...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => _onClearSearch(viewModel),
                          )
                        : IconButton(
                            icon: const Icon(Icons.arrow_forward),
                            onPressed: () => _onSearchSubmitted(viewModel),
                          ),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                ),
                const SizedBox(height: 24),

                // Bagian Lokasi Favorit Tersimpan
                _buildFavoritesSection(context, viewModel),

                const SizedBox(height: 24),

                // Bagian Hasil Pencarian
                _buildSearchResultsSection(context, viewModel),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context, WeatherViewModel viewModel) {
    final favorites = viewModel.favoriteLocations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.bookmark, color: Color(0xFF0288D1), size: 20),
            const SizedBox(width: 8),
            Text(
              'Lokasi Favorit Tersimpan',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (favorites.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Text(
              'Belum ada lokasi favorit tersimpan.',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final loc = favorites[index];
              final isSelected = viewModel.selectedLocation?.id == loc.id;
              final region = [
                if (loc.admin1 != null && loc.admin1!.isNotEmpty) loc.admin1!,
                loc.country
              ].join(', ');

              return Card(
                color: isSelected ? const Color(0xFFE0F2FE) : Colors.white,
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE0F7FA),
                    child: Icon(Icons.location_city, color: Color(0xFF0288D1)),
                  ),
                  title: Text(
                    loc.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(region.isNotEmpty ? region : 'Lat: ${loc.latitude}, Lon: ${loc.longitude}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                    tooltip: 'Hapus dari Favorit',
                    onPressed: () {
                      viewModel.toggleFavorite(loc);
                    },
                  ),
                  onTap: () {
                    viewModel.selectLocation(loc);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSearchResultsSection(BuildContext context, WeatherViewModel viewModel) {
    if (!viewModel.hasSearched) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hasil Pencarian',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),

        if (viewModel.isSearching)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(),
            ),
          )
        else if (viewModel.searchError != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    viewModel.searchError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          )
        else if (viewModel.searchResults.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Column(
              children: [
                Icon(Icons.search_off, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text(
                  'Kota tidak ditemukan.',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Coba gunakan kata kunci nama kota yang lain.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: viewModel.searchResults.length,
            itemBuilder: (context, index) {
              final loc = viewModel.searchResults[index];
              final isFav = viewModel.isLocationFavorite(loc.id);
              final region = [
                if (loc.admin1 != null && loc.admin1!.isNotEmpty) loc.admin1!,
                loc.country
              ].join(', ');

              return Card(
                child: ListTile(
                  title: Text(
                    loc.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '$region\nKoordinat: ${loc.latitude.toStringAsFixed(2)}, ${loc.longitude.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.bookmark : Icons.bookmark_border,
                      color: isFav ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      viewModel.toggleFavorite(loc);
                    },
                  ),
                  onTap: () {
                    viewModel.selectLocation(loc);
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
      ],
    );
  }
}
