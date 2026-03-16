import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../cards/notification/notification_card.dart';
import '../../provider/notification_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/app_bar.dart';

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final unreadCount =
        ref.watch(unreadNotificationCountProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: MRAppBar(
        showBack: true,
        showActions: false,
        titleText: 'Notifications',
        subtitleText:
            unreadCount > 0 ? 'You have $unreadCount unread' : 'All caught up',
        onBack: () => context.pop(),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Iconsax.notification,
                    size: 80,
                    color: AppColors.quaternary.withAlpha(76),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'No Notifications',
                    style: AppTypography.h3.copyWith(
                      color: AppColors.quaternary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'You\'re all caught up!',
                    style: AppTypography.body.copyWith(
                      color: AppColors.quaternary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(notification.title),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                  },
                  onDelete: () {
                    ref
                        .read(notificationProvider.notifier)
                        .deleteNotification(notification.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Notification deleted'),
                        backgroundColor: AppColors.secondary,
                      ),
                    );
                  },
                  onMarkAsRead: (id) {
                    ref
                        .read(notificationProvider.notifier)
                        .markAsRead(id);
                  },
                );
              },
            ),
      floatingActionButton: unreadCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                ref
                    .read(notificationProvider.notifier)
                    .markAllAsRead();
              },
              icon: const Icon(Iconsax.tick_circle),
              label: const Text('Mark All as Read'),
              backgroundColor: AppColors.primary,
            )
          : null,
    );
  }
}
