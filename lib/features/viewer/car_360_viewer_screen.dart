import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../models/car_model.dart';
import '../../utils/constants.dart';

class Car360ViewerScreen extends StatefulWidget {
  const Car360ViewerScreen({super.key});

  @override
  State<Car360ViewerScreen> createState() => _Car360ViewerScreenState();
}

class _Car360ViewerScreenState extends State<Car360ViewerScreen> {
  double _rotationAngle = 0;
  int _currentImageIndex = 0;
  bool _isAutoRotating = false;

  // Simulated 360 view with 8 angles
  final List<String> _carAngles = [
    'https://images.unsplash.com/photo-1544636331-e26879cd4d9b?w=800',
    'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800',
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800',
    'https://images.unsplash.com/photo-1552519507-da3b142c6e3d?w=800',
    'https://images.unsplash.com/photo-1542362567-b07e54358753?w=800',
    'https://images.unsplash.com/photo-1553440569-bcc63803a83d?w=800',
    'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800',
    'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800',
  ];

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      _rotationAngle += details.delta.dx * 0.5;
      _currentImageIndex = ((_rotationAngle / 45).floor() % _carAngles.length)
          .abs();
    });
  }

  void _toggleAutoRotate() {
    setState(() => _isAutoRotating = !_isAutoRotating);
    if (_isAutoRotating) {
      _autoRotate();
    }
  }

  void _autoRotate() async {
    while (_isAutoRotating && mounted) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted && _isAutoRotating) {
        setState(() {
          _rotationAngle += 5;
          _currentImageIndex =
              ((_rotationAngle / 45).floor() % _carAngles.length).abs();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = ModalRoute.of(context)?.settings.arguments as Car?;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          car?.fullName ?? "360° View",
          style: const TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              _isAutoRotating ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
            ),
            onPressed: _toggleAutoRotate,
          ),
        ],
      ),
      body: Column(
        children: [
          // 360 Viewer
          Expanded(
            flex: 3,
            child: GestureDetector(
              onPanUpdate: _onPanUpdate,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Car Image
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 150),
                    child: Image.network(
                      _carAngles[_currentImageIndex],
                      key: ValueKey(_currentImageIndex),
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(
                        Icons.directions_car,
                        size: 100,
                        color: Colors.white30,
                      ),
                    ),
                  ),

                  // Rotation indicator
                  Positioned(
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.swipe,
                            color: Colors.white54,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Swipe to rotate • ${(_rotationAngle % 360).toStringAsFixed(0)}°",
                            style: const TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 360 badge
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primaryAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        "360°",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Thumbnail strip
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _carAngles.length,
              itemBuilder: (context, index) {
                final isSelected = index == _currentImageIndex;
                return GestureDetector(
                  onTap: () => setState(() {
                    _currentImageIndex = index;
                    _rotationAngle = index * 45.0;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryAccent
                            : Colors.white24,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        _carAngles[index],
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) =>
                            Container(color: Colors.grey[800]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Color options
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Exterior Colors",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildColorOption(Colors.black, "Midnight Black", true),
                    _buildColorOption(Colors.white, "Pearl White", false),
                    _buildColorOption(Colors.red, "Racing Red", false),
                    _buildColorOption(Colors.blue, "Ocean Blue", false),
                    _buildColorOption(Colors.grey, "Graphite", false),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorOption(Color color, String name, bool isSelected) {
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? AppColors.primaryAccent : Colors.white24,
              width: isSelected ? 3 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryAccent.withValues(alpha: 0.5),
                      blurRadius: 10,
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name.split(' ').first,
          style: TextStyle(color: Colors.white54, fontSize: 10),
        ),
      ],
    );
  }
}
