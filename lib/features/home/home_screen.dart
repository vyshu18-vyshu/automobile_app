import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/api_service.dart';
import '../../services/user_service.dart';
import '../../utils/constants.dart';
import '../cars/brand_cars_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello, ${UserService.instance.userName}",
              style: TextStyle(
                color: AppColors.textGrey,
                fontSize: 14,
              ),
            ),
            const Text(
              "Find Your Dream Car",
              style: TextStyle(
                color: AppColors.textDark,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
            icon: Stack(
              children: [
                const Icon(Icons.notifications_outlined, color: AppColors.textDark),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppLayout.paddingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textGrey),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search for cars...",
                          hintStyle: TextStyle(color: AppColors.textGrey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onTap: () => Navigator.pushNamed(context, '/cars'),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Brands Grid
              _buildSectionHeader(context, "Browse by Brand", () {}),
              const SizedBox(height: 12),
              FutureBuilder<List<Map<String, String>>>(
                future: ApiService.getBrands(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final brands = snapshot.data!;
                  // Show top 8 brands efficiently, or all? Request says "Redesign... to show ALL car brands".
                  // A grid of 50 brands might be too much for the home screen immediately.
                  // But "show ALL car brands... This section must visually resemble modern car platforms".
                  // I will show a GridView with a fixed height or expandable.
                  // For a clean layout, let's show a 4x2 grid (8 brands) and a "View All" button, 
                  // OR just a scrollable grid if it's inside a SingleChildScrollView (which it is).
                  // But we need to limit height or disable scrolling of the grid.
                  // Let's make it a horizontal scrolling grid or a vertical list of rows?
                  // "Clean grid layout" usually implies vertical grid.
                  
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: brands.length, 
                    // Showing all brands might result in a very long page. 
                    // I will show first 12 and add a "See All" button behavior if needed.
                    // However, the request says "Redesign... to show ALL car brands".
                    // I will show ALL brands since there are ~45, 4 per row = ~12 rows. That's acceptable.
                    
                    itemBuilder: (context, index) {
                      final brand = brands[index];
                      return GestureDetector(
                        onTap: () => _navigateToBrandCars(context, brand['name']!),
                        child: Column(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.05),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Image.network(
                                  brand['logo']!,
                                  fit: BoxFit.contain,
                                  errorBuilder: (c, e, s) => Center(
                                    child: Text(
                                      brand['name']!.substring(0, 1),
                                      style: const TextStyle(
                                        fontSize: 20, 
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              brand['name']!,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 24),

              // Featured Cars
              _buildSectionHeader(context, "Featured Cars", () => Navigator.pushNamed(context, '/cars')),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: FutureBuilder<List<Car>>(
                  future: ApiService.getCars(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    final featuredCars = snapshot.data!.where((car) => car.isFeatured).toList();
                    if (featuredCars.isEmpty) {
                      return const Center(child: Text("No featured cars"));
                    }
                    
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: featuredCars.length,
                      itemBuilder: (context, index) {
                        return _buildFeaturedCarCard(context, featuredCars[index]);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Quick Tools
              _buildSectionHeader(context, "Quick Tools", () {}),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildQuickTool(context, "EMI Calculator", Icons.calculate, '/emi-calculator'),
                  const SizedBox(width: 12),
                  _buildQuickTool(context, "Compare Cars", Icons.compare_arrows, '/compare'),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        TextButton(
          onPressed: onSeeAll,
          child: const Text("See All"),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String name, IconData icon) {
    return Container(
      width: 80,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryAccent.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primaryAccent),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.textDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCarCard(BuildContext context, Car car) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/details', arguments: car),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppLayout.borderRadiusM),
                topRight: Radius.circular(AppLayout.borderRadiusM),
              ),
              child: Image.network(
                car.imageUrl,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 120,
                  color: AppColors.lightSurface,
                  child: const Center(
                    child: Icon(Icons.directions_car, color: AppColors.textGrey, size: 40),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.fullName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textDark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        car.formattedPrice,
                        style: const TextStyle(
                          color: AppColors.primaryAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.starYellow),
                          const SizedBox(width: 4),
                          Text(
                            car.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTool(BuildContext context, String title, IconData icon, String route) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.lightSurface,
            borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
          ),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryAccent, size: 28),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToBrandCars(BuildContext context, String brandName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandCarsScreen(brandName: brandName),
      ),
    );
  }
}
