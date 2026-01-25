import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'New Car Alert!',
      'message': 'Ford Mustang GT 2024 is now available. Check it out!',
      'time': '2 hours ago',
      'icon': Icons.directions_car,
      'read': false,
    },
    {
      'title': 'Price Drop',
      'message': 'Tesla Model 3 price reduced by ₹2,00,000!',
      'time': '5 hours ago',
      'icon': Icons.local_offer,
      'read': false,
    },
    {
      'title': 'Test Drive Confirmed',
      'message':
          'Your test drive for Toyota Fortuner is confirmed for tomorrow at 10 AM.',
      'time': '1 day ago',
      'icon': Icons.calendar_today,
      'read': true,
    },
    {
      'title': 'EMI Reminder',
      'message': 'Your next EMI of ₹45,000 is due on 15th Jan.',
      'time': '2 days ago',
      'icon': Icons.payment,
      'read': true,
    },
    {
      'title': 'Special Offer',
      'message': 'Get 0% processing fee on car loans this month!',
      'time': '3 days ago',
      'icon': Icons.card_giftcard,
      'read': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        actions: [
          TextButton(onPressed: () {}, child: const Text("Mark all read")),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          final isUnread = !(notif['read'] as bool);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isUnread
                  ? AppColors.primaryAccent.withValues(alpha: 0.05)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: isUnread
                  ? Border.all(
                      color: AppColors.primaryAccent.withValues(alpha: 0.2),
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    notif['icon'] as IconData,
                    color: AppColors.primaryAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notif['title'] as String,
                              style: TextStyle(
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (isUnread)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notif['message'] as String,
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        notif['time'] as String,
                        style: TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
