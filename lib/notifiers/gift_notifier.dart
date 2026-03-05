import 'package:flutter_riverpod/legacy.dart';
import '../models/gift.dart';

class GiftNotifier extends StateNotifier<List<Gift>> {
  GiftNotifier() : super([]) {
    _loadGifts();
  }

  // Load gifts - mock data for now
  void _loadGifts() {
    state = [
      Gift(
        id: '1',
        doctorId: '1',
        giftItem: 'Luxury Pen Set',
        date: DateTime(2026, 3, 10),
        occasion: 'Birthday',
        remarks: 'High quality pen set for Dr. Ahmed Khan',
        status: GiftStatus.pending,
      ),
      Gift(
        id: '2',
        doctorId: '2',
        giftItem: 'Coffee Maker',
        date: DateTime(2026, 2, 28),
        occasion: 'Appreciation',
        remarks: 'Premium coffee maker',
        status: GiftStatus.sent,
      ),
      Gift(
        id: '3',
        doctorId: '1',
        giftItem: 'Watch',
        date: DateTime(2026, 2, 20),
        occasion: 'Service Anniversary',
        remarks: 'Elegant wristwatch',
        status: GiftStatus.received,
      ),
    ];
  }

  // Add a new gift
  void addGift(Gift gift) {
    state = [...state, gift.copyWith(id: DateTime.now().toString())];
  }

  // Update a gift
  void updateGift(Gift updatedGift) {
    state = [
      for (final gift in state)
        if (gift.id == updatedGift.id) updatedGift else gift,
    ];
  }

  // Delete a gift
  void deleteGift(String id) {
    state = [for (final gift in state) if (gift.id != id) gift];
  }

  // Get a gift by id
  Gift? getGiftById(String id) {
    try {
      return state.firstWhere((gift) => gift.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get gifts by doctor id
  List<Gift> getGiftsByDoctorId(String doctorId) {
    return state.where((gift) => gift.doctorId == doctorId).toList();
  }

  // Filter by date
  List<Gift> filterByDate(DateTime date) {
    return state
        .where((gift) =>
            gift.date.year == date.year &&
            gift.date.month == date.month &&
            gift.date.day == date.day)
        .toList();
  }

  // Filter by status
  List<Gift> filterByStatus(GiftStatus status) {
    return state.where((gift) => gift.status == status).toList();
  }

  // Get all unique occasions
  List<String> getAllOccasions() {
    return state.map((gift) => gift.occasion).toSet().toList();
  }

  // Get all unique gift items
  List<String> getAllGiftItems() {
    return state.map((gift) => gift.giftItem).toSet().toList();
  }
}
