import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Wrapper widget to add staggered fade-in animation to any child
class StaggeredListItem extends StatelessWidget {
  final Widget child;
  final int index;
  final int? totalItems;

  const StaggeredListItem({
    super.key,
    required this.child,
    required this.index,
    this.totalItems,
  });

  @override
  Widget build(BuildContext context) {
    // Stagger delay based on index
    final delay = Duration(milliseconds: 50 * index);
    
    return child
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: delay,
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.1,
          end: 0,
          duration: 400.ms,
          delay: delay,
          curve: Curves.easeOut,
        );
  }
}
