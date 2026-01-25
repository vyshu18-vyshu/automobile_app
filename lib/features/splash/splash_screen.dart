import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../services/user_service.dart';
import '../../utils/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _pulseController;
  late AnimationController _carMoveController;
  late Animation<double> _logoScale;
  late Animation<double> _logoRotation;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _carPosition;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotation = Tween<double>(
      begin: -0.5,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _logoController, curve: Curves.easeOut));

    // Text animation
    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // Pulse animation
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    // Car moving animation (left to right)
    _carMoveController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _carPosition = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _carMoveController, curve: Curves.easeInOut),
    );

    // Start animations sequence
    _startAnimations();
  }

  void _startAnimations() async {
    // Step 1: Car moves from left to right (Starts immediately)
    _carMoveController.forward();
    
    // Step 2: App name and logo appear (After car animation is halfway)
    await Future.delayed(const Duration(milliseconds: 800));
    _textController.forward();
    _logoController.forward();
    
    // Step 3: Wait for total 3.5 seconds
    await Future.delayed(const Duration(milliseconds: 2700));

    if (mounted) {
      if (UserService.instance.isLoggedIn) {
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    _carMoveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1A1A2E),
              const Color(0xFF16213E),
              AppColors.primaryAccent.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Animated circles background
            ...List.generate(5, (index) => _buildFloatingCircle(index)),

            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated Logo
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Transform.rotate(
                          angle: _logoRotation.value * math.pi,
                          child: child,
                        ),
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryAccent,
                                AppColors.primaryAccent.withValues(alpha: 0.7),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withValues(
                                  alpha: 0.3 + (_pulseController.value * 0.3),
                                ),
                                blurRadius: 30 + (_pulseController.value * 20),
                                spreadRadius: 5 + (_pulseController.value * 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.directions_car,
                            size: 60,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),

                  // App Name
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textOpacity,
                      child: Column(
                        children: [
                          const Text(
                            "CAR FINDER",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Find Your Dream Car",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Loading indicator at bottom
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryAccent.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Loading...",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Animated car moving left to right
            Positioned(
              bottom: 160,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _carMoveController,
                builder: (context, child) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  // Only show sparks when car is moving and on screen
                  final showSparks = _carMoveController.value > 0.2 && _carMoveController.value < 0.8;
                  
                  return Transform.translate(
                    offset: Offset(_carPosition.value * screenWidth, 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.center,
                      children: [
                        // Sparks behind rear wheel
                        if (showSparks)
                          Positioned(
                            left: -10,
                            bottom: 5,
                            child: const WheelSparks(),
                          ),
                        // Car Body
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryAccent.withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.directions_car, color: Colors.white, size: 28),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.white70, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingCircle(int index) {
    final random = math.Random(index);
    final size = 50.0 + random.nextDouble() * 100;
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final top = random.nextDouble() * MediaQuery.of(context).size.height;

    return Positioned(
      left: left,
      top: top,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(
              math.sin(_pulseController.value * math.pi * 2 + index) * 10,
              math.cos(_pulseController.value * math.pi * 2 + index) * 10,
            ),
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryAccent.withValues(alpha: 0.1),
                    AppColors.primaryAccent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class WheelSparks extends StatefulWidget {
  const WheelSparks({super.key});

  @override
  State<WheelSparks> createState() => _WheelSparksState();
}

class _WheelSparksState extends State<WheelSparks> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SparkPainter(_controller.value),
          size: const Size(40, 40),
        );
      },
    );
  }
}

class SparkPainter extends CustomPainter {
  final double progress;
  final math.Random _random = math.Random();

  SparkPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 5; i++) {
        final angle = (math.pi / 2) + (_random.nextDouble() * math.pi / 2); // 90 to 180 degrees (backwards)
        final distance = 10.0 + (_random.nextDouble() * 20.0 * (1 - progress)); // Move out/fade
        final opacity = (1.0 - progress).clamp(0.0, 1.0);
        
        paint.color = Color(0xFFFFCC00).withValues(alpha: opacity); // Spark color
        
        final dx = math.cos(angle) * distance;
        final dy = math.sin(angle) * distance;

        canvas.drawCircle(Offset(size.width + dx, size.height / 2 + dy), 2, paint);
    }
  }

  @override
  bool shouldRepaint(SparkPainter oldDelegate) => true;
}

