import 'package:flutter/material.dart';
import '../../models/car_model.dart';
import '../../services/api_service.dart';
import '../../services/storage_service.dart';
import '../../utils/constants.dart';
import '../../widgets/state_views.dart';

class CompareScreen extends StatefulWidget {
  const CompareScreen({super.key});

  @override
  State<CompareScreen> createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  Car? _car1;
  Car? _car2;
  List<Car> _allCars = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cars = await ApiService.getCars();
    final savedIds = StorageService.getComparison();
    
    Car? c1, c2;
    if (savedIds.isNotEmpty) {
      c1 = cars.firstWhere((c) => c.id == savedIds[0], orElse: () => cars[0]);
      if (savedIds.length > 1) {
        c2 = cars.firstWhere((c) => c.id == savedIds[1], orElse: () => cars[1]);
      }
    }

    setState(() {
      _allCars = cars;
      _car1 = c1;
      _car2 = c2;
      _isLoading = false;
    });
  }

  Future<void> _updateComparison(int slot, Car car) async {
    setState(() {
      if (slot == 1) _car1 = car;
      else _car2 = car;
    });

    // Save to storage
    final ids = <String>[];
    if (_car1 != null) ids.add(_car1!.id);
    if (_car2 != null) ids.add(_car2!.id);
    await StorageService.saveComparison(ids);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Scaffold(body: LoadingView(message: "Loading cars..."));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Compare Cars"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: "Clear Comparison",
            onPressed: () async {
              setState(() {
                _car1 = null;
                _car2 = null;
              });
              await StorageService.clearComparison();
            },
          ),
        ],
      ),
      body: _allCars.isEmpty
          ? const ErrorView(message: "No cars available to compare")
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppLayout.paddingM),
              child: Column(
                children: [
                  // Car Selectors
                  Row(
                    children: [
                      Expanded(child: _buildCarSelector(1, _car1)),
                      const SizedBox(width: 16),
                      Expanded(child: _buildCarSelector(2, _car2)),
                    ],
                  ),
                  const SizedBox(height: AppLayout.paddingL),

                  // Comparison Table
                  if (_car1 != null && _car2 != null) ...[
                    _buildComparisonRow("Brand", _car1!.brand, _car2!.brand),
                    _buildComparisonRow("Model", _car1!.model, _car2!.model),
                    _buildComparisonRow(
                      "Price",
                      _car1!.formattedPrice,
                      _car2!.formattedPrice,
                      highlightBetter: false, // Price is subjective (lower better usually)
                    ),
                    _buildComparisonRow(
                      "Category",
                      _car1!.category,
                      _car2!.category,
                    ),
                    _buildComparisonRow(
                      "Top Speed",
                      "${_car1!.topSpeed} km/h",
                      "${_car2!.topSpeed} km/h",
                      highlightBetter: true,
                    ),
                    _buildComparisonRow(
                      "0-100 km/h",
                      "${_car1!.acceleration}s",
                      "${_car2!.acceleration}s",
                      highlightBetter: true,
                      lowerIsBetter: true,
                    ),
                    _buildComparisonRow(
                      "Horsepower",
                      "${_car1!.horsepower} hp",
                      "${_car2!.horsepower} hp",
                      highlightBetter: true,
                    ),
                    _buildComparisonRow(
                      "Seats",
                      "${_car1!.seats}",
                      "${_car2!.seats}",
                    ),
                    _buildComparisonRow(
                      "Transmission",
                      _car1!.transmission,
                      _car2!.transmission,
                    ),
                    _buildComparisonRow(
                      "Rating",
                      "⭐ ${_car1!.rating}",
                      "⭐ ${_car2!.rating}",
                      highlightBetter: true,
                    ),
                  ] else 
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: EmptyView(
                        message: "Select two cars to compare details",
                        icon: Icons.compare_arrows,
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _buildCarSelector(int carNumber, Car? selected) {
    return GestureDetector(
      onTap: () => _showCarSelector(carNumber),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.lightSurface,
          borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
          border: Border.all(
            color: selected != null 
                ? AppColors.primaryAccent.withValues(alpha: 0.5) 
                : Colors.grey.withValues(alpha: 0.2),
            width: selected != null ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Text(
              "Car $carNumber",
              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textGrey),
            ),
            const SizedBox(height: 8),
            if (selected != null) ...[
               Image.network(
                selected.imageUrl,
                height: 80,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => const Icon(Icons.directions_car, size: 40),
              ),
              const SizedBox(height: 8),
              Text(
                selected.fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ] else
              const SizedBox(
                height: 100, 
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline, size: 30, color: AppColors.primaryAccent),
                      SizedBox(height: 4),
                      Text("Select", style: TextStyle(color: AppColors.primaryAccent)),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showCarSelector(int carNumber) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: const BoxDecoration(
          color: AppColors.lightBackground,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: _CarSearchModal(
          allCars: _allCars,
          onSelect: (car) {
            _updateComparison(carNumber, car);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }


  Widget _buildComparisonRow(
    String label, 
    String value1, 
    String value2, {
    bool highlightBetter = false,
    bool lowerIsBetter = false,
  }) {
    bool val1Better = false;
    bool val2Better = false;

    if (highlightBetter) {
      try {
        final v1 = double.parse(value1.replaceAll(RegExp(r'[^0-9.]'), ''));
        final v2 = double.parse(value2.replaceAll(RegExp(r'[^0-9.]'), ''));
        
        if (lowerIsBetter) {
          val1Better = v1 < v2;
          val2Better = v2 < v1;
        } else {
          val1Better = v1 > v2;
          val2Better = v2 > v1;
        }
      } catch (_) {
        // Parse error, ignore highlighting
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(AppLayout.borderRadiusS),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value1,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: val1Better ? Colors.green : AppColors.textDark,
                fontWeight: val1Better ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textGrey, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value2,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: val2Better ? Colors.green : AppColors.textDark,
                fontWeight: val2Better ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CarSearchModal extends StatefulWidget {
  final List<Car> allCars;
  final Function(Car) onSelect;

  const _CarSearchModal({required this.allCars, required this.onSelect});

  @override
  State<_CarSearchModal> createState() => _CarSearchModalState();
}

class _CarSearchModalState extends State<_CarSearchModal> {
  List<Car> _filteredCars = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCars = widget.allCars;
    _searchController.addListener(_filterCars);
  }

  void _filterCars() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCars = widget.allCars.where((car) {
        return car.fullName.toLowerCase().contains(query) ||
               car.brand.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(AppLayout.paddingM),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "Select a Car",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search by brand or model...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCars.length,
              itemBuilder: (context, index) {
                final car = _filteredCars[index];
                return ListTile(
                  leading: Image.network(
                    car.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => const Icon(Icons.directions_car),
                  ),
                  title: Text(car.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(car.formattedPrice),
                  onTap: () => widget.onSelect(car),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}
