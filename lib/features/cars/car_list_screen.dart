import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/api_service.dart';
import '../../services/search_service.dart';
import '../../widgets/car_card.dart';
import '../../widgets/staggered_list_item.dart';
import '../../widgets/state_views.dart';
import '../../widgets/skeleton_loader.dart';
import '../../utils/constants.dart';

class CarListScreen extends StatefulWidget {
  const CarListScreen({super.key});

  @override
  State<CarListScreen> createState() => _CarListScreenState();
}

class _CarListScreenState extends State<CarListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String _selectedCategory = 'All';
  String _selectedFuelType = 'All';
  RangeValues _priceRange = const RangeValues(0, 10000000);
  SortBy _sortBy = SortBy.priceHighToLow; // Default to premium feel
  
  List<Car> _allCars = [];
  List<Car> _filteredCars = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCars();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce search input
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _applyFilters();
    });
  }

  Future<void> _loadCars() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    
    try {
      final cars = await ApiService.getCars();
      if (mounted) {
        setState(() {
          _allCars = cars;
          _filteredCars = cars;
          _isLoading = false;
        });
        _applyFilters();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _applyFilters() {
    if (!mounted) return;
    setState(() {
      _filteredCars = SearchService.searchCars(
        _allCars,
        query: _searchController.text,
        category: _selectedCategory,
        fuelType: _selectedFuelType,
        priceRange: PriceRange(_priceRange.start, _priceRange.end),
        sortBy: _sortBy,
      );
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = 'All';
      _selectedFuelType = 'All';
      _priceRange = const RangeValues(0, 10000000);
      _sortBy = SortBy.priceHighToLow;
      _applyFilters();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: LoadingView(message: "Loading cars..."));
    if (_hasError) return Scaffold(
      appBar: AppBar(title: const Text("All Cars")),
      body: ErrorView(message: "Failed to load cars", onRetry: _loadCars),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Find Your Car"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Reset Filters",
            onPressed: _resetFilters,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar & Sort
          Padding(
            padding: const EdgeInsets.fromLTRB(AppLayout.paddingM, AppLayout.paddingM, AppLayout.paddingM, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search brand, model...",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.lightSurface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onChanged: (_) => _applyFilters(),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
                  ),
                  child: PopupMenuButton<SortBy>(
                    icon: const Icon(Icons.sort),
                    tooltip: "Sort By",
                    onSelected: (SortBy result) {
                      setState(() {
                        _sortBy = result;
                        _applyFilters();
                      });
                    },
                    itemBuilder: (BuildContext context) => <PopupMenuEntry<SortBy>>[
                      const PopupMenuItem<SortBy>(
                        value: SortBy.priceLowToHigh,
                        child: Text('Price: Low to High'),
                      ),
                      const PopupMenuItem<SortBy>(
                        value: SortBy.priceHighToLow,
                        child: Text('Price: High to Low'),
                      ),
                      const PopupMenuItem<SortBy>(
                        value: SortBy.ratingHighToLow,
                        child: Text('Rating: High to Low'),
                      ),
                      const PopupMenuItem<SortBy>(
                        value: SortBy.nameAZ,
                        child: Text('Name: A-Z'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.paddingM),
              children: SearchService.getCategories(_allCars).map((cat) {
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                      _applyFilters();
                    },
                    selectedColor: AppColors.buyButton,
                    backgroundColor: AppColors.lightSurface,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textDark,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Price Filter & Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppLayout.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price Range", style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                    Text(
                      '₹${(_priceRange.start / 100000).toStringAsFixed(0)}L - ₹${(_priceRange.end / 100000).toStringAsFixed(0)}L',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                  child: RangeSlider(
                    values: _priceRange,
                    min: 0,
                    max: 10000000,
                    divisions: 100,
                    activeColor: AppColors.primaryAccent,
                    onChanged: (values) {
                      setState(() => _priceRange = values);
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),

          // Results Count
          Padding(
            padding: const EdgeInsets.fromLTRB(AppLayout.paddingM, 8, AppLayout.paddingM, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${_filteredCars.length} cars found",
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey),
              ),
            ),
          ),

          // Car List with pull-to-refresh
          Expanded(
            child: _filteredCars.isEmpty
                ? EmptyView(
                    message: "No cars match your filters",
                    icon: Icons.search_off,
                    action: TextButton(
                      onPressed: _resetFilters,
                      child: const Text("Clear Filters"),
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: _loadCars,
                    color: AppColors.primaryAccent,
                    child: ListView.builder(
                      padding: const EdgeInsets.all(AppLayout.paddingM),
                      itemCount: _filteredCars.length,
                      itemBuilder: (context, index) {
                        return StaggeredListItem(
                          index: index,
                          totalItems: _filteredCars.length,
                          child: CarCard(
                            car: _filteredCars[index],
                            onTap: () => Navigator.pushNamed(
                              context,
                              '/details',
                              arguments: _filteredCars[index],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
           ),
        ],
      ),
    );
  }
}
