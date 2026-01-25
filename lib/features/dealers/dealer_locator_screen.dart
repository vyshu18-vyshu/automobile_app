import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class DealerLocatorScreen extends StatelessWidget {
  const DealerLocatorScreen({super.key});

  static final List<Map<String, String>> _dealers = [
    {
      'name': 'Luxe Motors - Bangalore Central',
      'address': '123 MG Road, Bangalore 560001',
      'phone': '+91 80 1234 5678',
      'hours': 'Mon-Sat: 9AM - 8PM',
    },
    {
      'name': 'Luxe Motors - Whitefield',
      'address': '456 ITPL Main Road, Whitefield 560066',
      'phone': '+91 80 2345 6789',
      'hours': 'Mon-Sat: 10AM - 9PM',
    },
    {
      'name': 'Luxe Motors - Koramangala',
      'address': '789 80 Feet Road, Koramangala 560034',
      'phone': '+91 80 3456 7890',
      'hours': 'Mon-Sun: 9AM - 7PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Find Dealers")),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(AppLayout.paddingM),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search by location...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.my_location),
                filled: true,
                fillColor: AppColors.lightSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Dealer List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppLayout.paddingM),
              itemCount: _dealers.length,
              itemBuilder: (context, index) {
                final dealer = _dealers[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(AppLayout.paddingM),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(AppLayout.borderRadiusM),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.primaryAccent.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppLayout.borderRadiusS),
                            ),
                            child: const Icon(Icons.store, color: AppColors.primaryAccent),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(dealer['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(dealer['address']!, style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: AppColors.textGrey),
                          const SizedBox(width: 8),
                          Text(dealer['phone']!, style: TextStyle(color: AppColors.textGrey)),
                          const Spacer(),
                          const Icon(Icons.access_time, size: 16, color: AppColors.textGrey),
                          const SizedBox(width: 8),
                          Text(dealer['hours']!, style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.call, size: 18),
                              label: const Text("Call"),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.directions, size: 18),
                              label: const Text("Directions"),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
