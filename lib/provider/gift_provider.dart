import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/gift.dart';
import '../notifiers/gift_notifier.dart';

// Provider for the list of gifts
final giftProvider = StateNotifierProvider<GiftNotifier, List<Gift>>((ref) {
  return GiftNotifier();
});

// Provider for a single gift by ID
final giftDetailProvider = Provider.family<Gift?, String>((ref, id) {
  final gifts = ref.watch(giftProvider);
  try {
    return gifts.firstWhere((gift) => gift.id == id);
  } catch (e) {
    return null;
  }
});

// Provider for gifts by doctor ID
final giftsByDoctorProvider =
    Provider.family<List<Gift>, String>((ref, doctorId) {
  final gifts = ref.watch(giftProvider);
  return gifts.where((gift) => gift.doctorId == doctorId).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

// Provider for gifts filtered by date
final giftsByDateProvider =
    Provider.family<List<Gift>, DateTime>((ref, date) {
  final gifts = ref.watch(giftProvider);
  return gifts
      .where((gift) =>
          gift.date.year == date.year &&
          gift.date.month == date.month &&
          gift.date.day == date.day)
      .toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

// Provider for gifts filtered by status
final giftsByStatusProvider =
    Provider.family<List<Gift>, GiftStatus>((ref, status) {
  final gifts = ref.watch(giftProvider);
  return gifts.where((gift) => gift.status == status).toList()
    ..sort((a, b) => b.date.compareTo(a.date));
});

// Provider for all occasions
final allGiftOccasionsProvider = Provider<List<String>>((ref) {
  final gifts = ref.watch(giftProvider);
  return gifts.map((gift) => gift.occasion).toSet().toList();
});

// Provider for all gift items
final allGiftItemsProvider = Provider<List<String>>((ref) {
  final gifts = ref.watch(giftProvider);
  return gifts.map((gift) => gift.giftItem).toSet().toList();
});

// Provider for gift inventory items
final giftInventoryProvider = Provider<List<GiftItem>>((ref) {
  final notifier = ref.watch(giftProvider.notifier);
  return notifier.giftInventoryItems;
});
