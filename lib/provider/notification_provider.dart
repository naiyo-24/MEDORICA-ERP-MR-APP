import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../models/notification.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/notification_notifier.dart';
import '../services/notification/notification_services.dart';
import 'auth_provider.dart';

final notificationServicesProvider = Provider<NotificationServices>((ref) {
  return NotificationServices();
});

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
      final notifier = NotificationNotifier(
        ref.read(notificationServicesProvider),
      );

      ref.listen<AuthState>(authNotifierProvider, (previous, next) {
        unawaited(notifier.syncAsm(next.mr?.mrId));
      });

      unawaited(notifier.syncAsm(ref.read(authNotifierProvider).mr?.mrId));
      return notifier;
    });

final notificationsProvider = Provider<List<NotificationModel>>((ref) {
  return ref.watch(notificationProvider).notifications;
});

final isNotificationsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(notificationProvider).isLoading;
});

final notificationErrorProvider = Provider<String?>((ref) {
  return ref.watch(notificationProvider).error;
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((notification) => !notification.isRead).length;
});

final unreadNotificationsProvider = Provider<List<NotificationModel>>((ref) {
  final notifications = ref.watch(notificationsProvider);
  return notifications.where((notification) => !notification.isRead).toList();
});
