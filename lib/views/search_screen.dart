import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF172036),
      body: SafeArea(
        child: Consumer<WeatherViewModel>(
          builder: (context, viewModel, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Custom Header: Tombol kembali + Judul
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF223052),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF374B7A),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            LucideIcons.arrowLeft,
                            color: Color(0xFFF2B66D),
                            size: 20,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      const Text(
                        'Cari lokasi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFF6F1E7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Kolom Input Pencarian Kota
                  TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Color(0xFFF6F1E7)),
                    textInputAction: TextInputAction.search,
                    onSubmitted: (_) => _onSearchSubmitted(viewModel),
                    onChanged: (text) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF223052),
                      hintText: 'Cari nama kota...',
                      hintStyle: const TextStyle(color: Color(0xFF8B99B5)),
                      prefixIcon: const Icon(
                        LucideIcons.search,
                        color: Color(0xFFF2B66D),
                        size: 20,
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => _onClearSearch(viewModel),
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF2B3C66),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    LucideIcons.x,
                                    size: 14,
                                    color: Color(0xFFF6F1E7),
                                  ),
                                ),
                              ),
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF374B7A),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFF374B7A),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: Color(0xFFF2B66D),
                          width: 1.5,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Bagian Lokasi Favorit
                  _buildFavoritesSection(context, viewModel),

                  const SizedBox(height: 24),

                  // Bagian Hasil Pencarian
                  _buildSearchResultsSection(context, viewModel),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context, WeatherViewModel viewModel) {
    final favorites = viewModel.favoriteLocations;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(
              LucideIcons.bookmark,
              color: Color(0xFFF2B66D),
              size: 18,
            ),
            SizedBox(width: 8),
            Text(
              'Lokasi favorit',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF6F1E7),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (favorites.isEmpty)
          CustomPaint(
            painter: _DashedRectPainter(
              color: const Color(0xFF374B7A),
              strokeWidth: 1.2,
              radius: 18,
              gap: 5,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFF223052),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.bookmark,
                      color: Color(0xFF8B99B5),
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Belum ada favorit. Ketuk ikon bookmark untuk menyimpan lokasi.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B99B5),
                      ),
                    ),
                  ),
                ],
              ),
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

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF2B3C66) : const Color(0xFF223052),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isSelected ? const Color(0xFFF2B66D) : const Color(0xFF374B7A),
                    width: isSelected ? 1.5 : 0.8,
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2B3C66),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      LucideIcons.mapPin,
                      color: Color(0xFFF2B66D),
                      size: 20,
                    ),
                  ),
                  title: Text(
                    loc.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF2B66D),
                      fontSize: 16,
                    ),
                  ),
                  subtitle: Text(
                    region.isNotEmpty ? region : 'Lat: ${loc.latitude}, Lon: ${loc.longitude}',
                    style: const TextStyle(
                      color: Color(0xFFB0BDD6),
                      fontSize: 13,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      LucideIcons.bookmark,
                      color: Color(0xFFF2B66D),
                    ),
                    tooltip: 'Hapus dari favorit',
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hasil pencarian',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF6F1E7),
              ),
            ),
            if (!viewModel.isSearching && viewModel.searchResults.isNotEmpty)
              Text(
                '${viewModel.searchResults.length} lokasi',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF8B99B5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        if (viewModel.isSearching)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: CircularProgressIndicator(
                color: Color(0xFFF2B66D),
              ),
            ),
          )
        else if (viewModel.searchError != null)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF223052),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
            ),
            child: Row(
              children: [
                const Icon(LucideIcons.cloudOff, color: Colors.redAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    viewModel.searchError!,
                    style: const TextStyle(color: Colors.redAccent),
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
              color: const Color(0xFF223052),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF374B7A),
                width: 0.8,
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  LucideIcons.search,
                  size: 40,
                  color: Color(0xFF8B99B5),
                ),
                SizedBox(height: 10),
                Text(
                  'Kota tidak ditemukan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFF6F1E7),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Coba gunakan kata kunci nama kota yang lain.',
                  style: TextStyle(
                    color: Color(0xFF8B99B5),
                    fontSize: 13,
                  ),
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
              final coordString =
                  '${loc.latitude.toStringAsFixed(2)}, ${loc.longitude.toStringAsFixed(2)}';

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 6),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF223052),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF374B7A),
                    width: 0.8,
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    viewModel.selectLocation(loc);
                    Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      // Kiri: Kotak Ikon Pin Lokasi (48x48)
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2B3C66),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          LucideIcons.mapPin,
                          color: Color(0xFFF2B66D),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Tengah: Info Kota, Wilayah, & Pill Badge Koordinat
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              loc.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF2B66D),
                              ),
                            ),
                            if (region.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                region,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFB0BDD6),
                                ),
                              ),
                            ],
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF172036),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                coordString,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF8B99B5),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Kanan: Tombol Bookmark
                      IconButton(
                        icon: Icon(
                          LucideIcons.bookmark,
                          color: isFav ? const Color(0xFFF2B66D) : const Color(0xFF8B99B5),
                        ),
                        onPressed: () {
                          viewModel.toggleFavorite(loc);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final double radius;

  _DashedRectPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
    this.radius = 18.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    const dashWidth = 6.0;
    final dashGap = gap;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = (distance + dashWidth < metric.length)
            ? dashWidth
            : metric.length - distance;
        canvas.drawPath(
          metric.extractPath(distance, distance + len),
          paint,
        );
        distance += dashWidth + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRectPainter oldDelegate) => false;
}
