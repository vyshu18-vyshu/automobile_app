import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/car_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/car_card.dart';
import '../../widgets/state_views.dart';
import '../../utils/constants.dart';

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recently Viewed"),
        actions: [
          if (StorageService.getRecentlyViewed().isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Clear History?"),
                    content: const Text("This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Clear All"),
                      ),
                    ],
                  ),
                );
                
                if (confirm == true) {
                  await StorageService.clearRecentlyViewed();
                  setState(() {});
                }
              },
            ),
        ],
      ),
      body: FutureBuilder<List<Car>>(
        future: ApiService.getCars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingView(message: "Loading history...");
          }

          if (snapshot.hasError) {
            return ErrorView(
              message: "Failed to load history",
              onRetry: () => setState(() {}),
            );
          }

          final recentIds = StorageService.getRecentlyViewed();
          // Map cars by ID for O(1) lookup
          final carMap = {for (var car in snapshot.data ?? []) car.id: car};
          
          // Create list preserving the order of recentIds
          final recentCars = recentIds
              .where((id) => carMap.containsKey(id))
              .map((id) => carMap[id]!)
              .toList();

          if (recentCars.isEmpty) {
            return EmptyView(
              icon: Icons.history,
              message: "No recently viewed cars\n\nCars you view will appear here",
              action: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/cars'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryAccent,
                ),
                child: const Text("Browse Cars"),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(AppLayout.paddingM),
            itemCount: recentCars.length,
            itemBuilder: (context, index) {
              return CarCard(
                car: recentCars[index],
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/details',
                    arguments: recentCars[index],
                  ).then((_) => setState(() {})); // Refresh on return
                },
              ).animate().fadeIn(delay: (50 * index).ms).slideX();
            },
          );
        },
      ),
    );
  }
}
