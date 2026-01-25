import 'package:flutter/material.dart';
import '../utils/strings.dart';

/// Reusable confirmation dialog utility
class ConfirmDialog {
  /// Show a confirmation dialog
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              cancelText,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: isDangerous ? Colors.red : confirmColor,
            ),
            child: Text(
              confirmText,
              style: TextStyle(
                color: isDangerous ? Colors.red : confirmColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Confirm sign out
  static Future<bool> confirmSignOut(BuildContext context) {
    return show(
      context: context,
      title: AppStrings.signOut,
      message: AppStrings.confirmSignOut,
      confirmText: AppStrings.signOut,
      isDangerous: true,
    );
  }

  /// Confirm clear comparison
  static Future<bool> confirmClearComparison(BuildContext context) {
    return show(
      context: context,
      title: AppStrings.clearComparison,
      message: AppStrings.confirmClearComparison,
      confirmText: AppStrings.clearComparison,
      isDangerous: true,
    );
  }

  /// Confirm clear filters
  static Future<bool> confirmClearFilters(BuildContext context) {
    return show(
      context: context,
      title: AppStrings.clearFilters,
      message: 'This will reset all your current filter selections.',
      confirmText: AppStrings.clearFilters,
    );
  }

  /// Confirm delete favorite
  static Future<bool> confirmRemoveFavorite(BuildContext context, String carName) {
    return show(
      context: context,
      title: AppStrings.removeFromFavorites,
      message: 'Remove $carName from your favorites?',
      confirmText: AppStrings.remove,
      isDangerous: true,
    );
  }

  // Add more confirmation dialogs as needed
}
