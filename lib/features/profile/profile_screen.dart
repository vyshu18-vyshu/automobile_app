import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/glassmorphic_widgets.dart';
import '../../services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
              ),
            ),
          ),

          // Background circles
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryAccent.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryAccent.withValues(alpha: 0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "My Profile",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushNamed(context, '/settings'),
                        child: GlassmorphicCard(
                          blur: 10,
                          opacity: 0.15,
                          padding: const EdgeInsets.all(10),
                          borderRadius: BorderRadius.circular(12),
                          child: const Icon(
                            Icons.settings_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Profile Card
                  GlassmorphicCard(
                    blur: 20,
                    opacity: 0.15,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primaryAccent,
                              width: 3,
                            ),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://i.pravatar.cc/200',
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          UserService.instance.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          UserService.instance.userEmail,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.2,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star,
                                color: AppColors.starYellow,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                              const Text(
                                "Premium Member",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats
                  Row(
                    children: [
                      _buildStatCard("3", "Saved Cars"),
                      const SizedBox(width: 12),
                      _buildStatCard("2", "Test Drives"),
                      const SizedBox(width: 12),
                      _buildStatCard("1", "Bookings"),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quick Tools
                  Row(
                    children: [
                      _buildToolButton(
                        context,
                        Icons.calculate,
                        "EMI",
                        '/emi-calculator',
                      ),
                      const SizedBox(width: 12),
                      _buildToolButton(
                        context,
                        Icons.compare_arrows,
                        "Compare",
                        '/compare',
                      ),
                      const SizedBox(width: 12),
                      _buildToolButton(
                        context,
                        Icons.store,
                        "Dealers",
                        '/dealers',
                      ),
                      const SizedBox(width: 12),
                      _buildToolButton(
                        context,
                        Icons.account_balance,
                        "Finance",
                        '/financing',
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Menu Items
                  GlassmorphicCard(
                    blur: 15,
                    opacity: 0.1,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildMenuItem(
                          Icons.favorite_outline,
                          "Saved Vehicles",
                          () => Navigator.pushNamed(context, '/saved-vehicles'),
                        ),
                        _buildDivider(),
                        _buildMenuItem(
                          Icons.history,
                          "Recently Viewed", 
                          () => Navigator.pushNamed(context, '/recently-viewed'),
                        ),
                        // Removed placeholder items for Phase 1
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  GlassmorphicCard(
                    blur: 15,
                    opacity: 0.1,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        _buildMenuItem(Icons.info_outline, "About App", 
                          () => _navigateToPlaceholder(context, "About App")),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Logout
                  GestureDetector(
                    onTap: () {
                      UserService.instance.clear();
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    },
                    child: GlassmorphicCard(
                      blur: 10,
                      opacity: 0.1,
                      borderColor: Colors.red.withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 8),
                          Text(
                            "Log Out",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: GlassmorphicCard(
        blur: 15,
        opacity: 0.15,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolButton(
    BuildContext context,
    IconData icon,
    String label,
    String route,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: GlassmorphicCard(
          blur: 10,
          opacity: 0.15,
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: AppColors.primaryAccent, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 11),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withValues(alpha: 0.8)),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.white.withValues(alpha: 0.4),
      ),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withValues(alpha: 0.1),
      indent: 56,
    );
  }

  void _navigateToPlaceholder(BuildContext context, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 64, color: AppColors.textGrey),
                const SizedBox(height: 16),
                Text(
                  "$title Coming Soon",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text("This feature is under development."),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
