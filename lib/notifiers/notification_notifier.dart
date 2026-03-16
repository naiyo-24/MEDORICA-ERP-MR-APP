import 'package:flutter_riverpod/legacy.dart';

import '../models/notification.dart';
import '../services/notification/notification_services.dart';

class NotificationState {
  final bool isLoading;
  final List<NotificationModel> notifications;
  final String? error;

  const NotificationState({
    this.isLoading = false,
    this.notifications = const [],
    this.error,
  });

  NotificationState copyWith({
    bool? isLoading,
    List<NotificationModel>? notifications,
    String? error,
  }) {
    return NotificationState(
      isLoading: isLoading ?? this.isLoading,
      notifications: notifications ?? this.notifications,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  NotificationNotifier(this._notificationServices)
    : super(const NotificationState());

  final NotificationServices _notificationServices;
  String? _activemrId;

  Future<void> syncAsm(String? mrId) async {
    final nextmrId = mrId?.trim();
    if (nextmrId == null || nextmrId.isEmpty) {
      _activemrId = null;
      state = const NotificationState();
      return;
    }

    if (_activemrId == nextmrId &&
        (state.notifications.isNotEmpty || state.isLoading)) {
      return;
    }

    _activemrId = nextmrId;
    await loadNotifications();
  }

  Future<void> loadNotifications({bool forceRefresh = false}) async {
    if (_activemrId == null || _activemrId!.isEmpty) {
      state = const NotificationState();
      return;
    }

    if (!forceRefresh &&
        state.notifications.isNotEmpty &&
        !state.isLoading &&
        state.error == null) {
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final notifications = await _notificationServices.fetchAsmNotifications();
      state = state.copyWith(
        isLoading: false,
        notifications: notifications,
        error: null,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        notifications: forceRefresh ? state.notifications : const [],
        error: _readErrorMessage(error),
      );
    }
  }

  void markAsRead(String notificationId) {
    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          if (notification.id == notificationId)
            notification.copyWith(isRead: true)
          else
            notification,
      ],
    );
  }

  void markAllAsRead() {
    state = state.copyWith(
      notifications: [
        for (final notification in state.notifications)
          notification.copyWith(isRead: true),
      ],
    );
  }

  void deleteNotification(String notificationId) {
    state = state.copyWith(
      notifications: state.notifications
          .where((notification) => notification.id != notificationId)
          .toList(),
    );
  }

  void addNotification(NotificationModel notification) {
    state = state.copyWith(
      notifications: [notification, ...state.notifications],
    );
  }

  int getUnreadCount() {
    return state.notifications
        .where((notification) => !notification.isRead)
        .length;
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _readErrorMessage(Object error) {
    final message = error.toString();
    if (message.startsWith('Exception: ')) {
      return message.substring('Exception: '.length);
    }

    return message;
  }
}
