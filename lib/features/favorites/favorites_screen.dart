import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/car_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/car_card.dart';
import '../../widgets/state_views.dart';
import '../../widgets/skeleton_loader.dart';
import '../../widgets/confirm_dialog.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  Future<List<Car>>? _futureCars;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() {
    setState(() {
      _futureCars = ApiService.getCars();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.favorites),
        actions: [
          if (StorageService.getFavorites().isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Clear All',
              onPressed: () async {
                final confirm = await ConfirmDialog.show(
                  context: context,
                  title: 'Clear All Favorites?',
                  message: 'This will remove all cars from your favorites list.',
                  confirmText: 'Clear All',
                  isDangerous: true,
                );
                
                if (confirm) {
                  await StorageService.saveFavorites([]);
                  _loadFavorites();
                }
              },
            ),
        ],
      ),
      body: FutureBuilder<List<Car>>(
        future: _futureCars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SkeletonLoader.carList();
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: AppStrings.failedToLoadData,
              onRetry: _loadFavorites,
            );
          }

          final favoriteIds = StorageService.getFavorites();
          final favorites = snapshot.data
                  ?.where((car) => favoriteIds.contains(car.id))
                  .toList() ??
              [];

          if (favorites.isEmpty) {
            return EmptyView(
              icon: Icons.favorite_border,
              message: AppStrings.startAddingFavorites,
              action: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/cars'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                ),
                child: const Text("Browse Cars"),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _loadFavorites();
              await _futureCars;
            },
            color: AppColors.primaryAccent,
            child: ListView.builder(
              padding: const EdgeInsets.all(AppLayout.paddingM),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return CarCard(
                  car: favorites[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: favorites[index],
                    ).then((_) => _loadFavorites());
                  },
                ).animate().fadeIn(delay: (100 * index).ms).slideX();
              },
            ),
          );
        },
      ),
    );
  }
}
