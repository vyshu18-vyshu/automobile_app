import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class InsuranceScreen extends StatefulWidget {
  const InsuranceScreen({super.key});

  @override
  State<InsuranceScreen> createState() => _InsuranceScreenState();
}

class _InsuranceScreenState extends State<InsuranceScreen> {
  int _selectedPlanIndex = 1;

  static final List<Map<String, dynamic>> _insurancePlans = [
    {
      'provider': 'HDFC Ergo',
      'logo': '🏦',
      'type': 'Third Party',
      'premium': 3499,
      'idv': 0,
      'features': [
        'Mandatory coverage',
        'Third party liability',
        'Personal accident',
      ],
      'rating': 4.2,
      'popular': false,
    },
    {
      'provider': 'ICICI Lombard',
      'logo': '🔷',
      'type': 'Comprehensive',
      'premium': 12999,
      'idv': 850000,
      'features': [
        'Own damage',
        'Theft protection',
        'Natural calamity',
        'Zero depreciation',
        '24/7 roadside',
      ],
      'rating': 4.5,
      'popular': true,
    },
    {
      'provider': 'Bajaj Allianz',
      'logo': '🔶',
      'type': 'Comprehensive+',
      'premium': 18999,
      'idv': 900000,
      'features': [
        'All comprehensive features',
        'Engine protection',
        'Return to invoice',
        'Key replacement',
        'NCB protection',
      ],
      'rating': 4.7,
      'popular': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Insurance Quotes")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryAccent,
                    AppColors.primaryAccent.withValues(alpha: 0.7),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.directions_car,
                    color: Colors.white,
                    size: 50,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Vehicle",
                          style: TextStyle(color: Colors.white70),
                        ),
                        const Text(
                          "Toyota Fortuner 2024",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "KA-01-AB-1234",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Compare Plans
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Compare Plans",
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text("3 quotes", style: TextStyle(color: AppColors.textGrey)),
              ],
            ),
            const SizedBox(height: 16),

            // Insurance Plans
            ...List.generate(_insurancePlans.length, (index) {
              final plan = _insurancePlans[index];
              final isSelected = index == _selectedPlanIndex;

              return GestureDetector(
                onTap: () => setState(() => _selectedPlanIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryAccent
                          : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? AppColors.primaryAccent.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.05),
                        blurRadius: isSelected ? 20 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        children: [
                          Text(
                            plan['logo'] as String,
                            style: const TextStyle(fontSize: 30),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      plan['provider'] as String,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (plan['popular'] as bool) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: const Text(
                                          "POPULAR",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                Text(
                                  plan['type'] as String,
                                  style: TextStyle(
                                    color: AppColors.textGrey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "₹${plan['premium']}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                "/year",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // IDV
                      if ((plan['idv'] as int) > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightSurface,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "IDV: ₹${plan['idv']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      const SizedBox(height: 12),

                      // Features
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (plan['features'] as List<String>)
                            .map(
                              (f) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(f, style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          ...List.generate(
                            5,
                            (i) => Icon(
                              i < (plan['rating'] as double).floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.starYellow,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${plan['rating']}",
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 24),

            // Buy Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Selected: ${_insurancePlans[_selectedPlanIndex]['provider']}",
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buyButton,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  "Buy ${_insurancePlans[_selectedPlanIndex]['provider']} - ₹${_insurancePlans[_selectedPlanIndex]['premium']}",
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
