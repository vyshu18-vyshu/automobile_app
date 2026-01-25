import 'dart:ui';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../widgets/glassmorphic_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'image':
          'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?w=1200',
      'title': 'Find Your\nDream Car',
      'subtitle': 'Discover premium vehicles from top brands',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=1200',
      'title': 'Compare &\nChoose',
      'subtitle': 'Side-by-side comparison of specs and prices',
    },
    {
      'image':
          'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=1200',
      'title': 'Easy\nFinancing',
      'subtitle': 'Get instant loan approval at lowest rates',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return Image.network(
                _pages[index]['image']!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (c, e, s) =>
                    Container(color: AppColors.darkBackground),
              );
            },
          ),

          // Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black.withValues(alpha: 0.95),
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Skip button
                  Align(
                    alignment: Alignment.topRight,
                    child: GlassmorphicButton(
                      text: "Skip",
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                    ),
                  ),

                  const Spacer(),

                  // Title
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _pages[_currentPage]['title']!,
                      key: ValueKey(_currentPage),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle in glassmorphic card
                  GlassmorphicCard(
                    blur: 15,
                    opacity: 0.15,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      _pages[_currentPage]['subtitle']!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Page indicators
                  Row(
                    children: List.generate(_pages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(right: 8),
                        width: index == _currentPage ? 30 : 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: index == _currentPage
                              ? AppColors.primaryAccent
                              : Colors.white.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: _currentPage == _pages.length - 1
                            ? ElevatedButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                  context,
                                  '/login',
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryAccent,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "Get Started",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                            : GlassmorphicButton(
                                text: "Next",
                                icon: Icons.arrow_forward,
                                onPressed: () {
                                  _pageController.nextPage(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
