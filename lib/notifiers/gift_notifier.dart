import 'package:flutter_riverpod/legacy.dart';
import '../models/gift.dart';
import '../services/gift/gift_services.dart';

class GiftNotifier extends StateNotifier<List<Gift>> {
  final GiftServices _giftServices = GiftServices();
  List<GiftItem> _giftInventoryItems = [];
  List<GiftItem> get giftInventoryItems => _giftInventoryItems;


  String? _currentMrId;
  String? get currentMrId => _currentMrId;
  set currentMrId(String? mrId) {
    _currentMrId = mrId;
    if (mrId != null) fetchGiftsForMr();
  }

  GiftNotifier() : super([]) {
    _fetchGiftInventory();
  }


  // Fetch gifts for the current MR from backend
  Future<void> fetchGiftsForMr([String? mrId]) async {
    final id = mrId ?? _currentMrId;
    if (id == null) {
      state = [];
      return;
    }
    try {
      final data = await _giftServices.getMrGiftApplicationsByMrId(id);
      state = data.map((json) => Gift(
        id: json['request_id'].toString(),
        doctorId: json['doctor_id'] ?? '',
        giftItem: json['gift_name'] ?? '',
        date: json['gift_date'] != null ? DateTime.parse(json['gift_date']) : DateTime.now(),
        occasion: json['occassion'] ?? '',
        remarks: json['remarks'] ?? '',
        status: GiftStatus.values.firstWhere(
          (e) => e.name == (json['status']?.toLowerCase() ?? ''),
          orElse: () => GiftStatus.pending,
        ),
      )).toList();
    } catch (e) {
      state = [];
    }
  }

  // Post a new MR Gift Application
  Future<void> postMrGiftApplication({
    String? mrId,
    required String doctorId,
    required int giftId,
    String? occassion,
    String? message,
    DateTime? giftDate,
    String? remarks,
  }) async {
    final id = mrId ?? _currentMrId;
    if (id == null) return;
    await _giftServices.postMrGiftApplication(
      mrId: id,
      doctorId: doctorId,
      giftId: giftId,
      occassion: occassion,
      message: message,
      giftDate: giftDate,
      remarks: remarks,
    );
    await fetchGiftsForMr(id);
  }

  // Update MR Gift Application
  Future<void> updateMrGiftApplication({
    String? mrId,
    required int requestId,
    String? doctorId,
    String? occassion,
    String? message,
    DateTime? giftDate,
    String? remarks,
    String? status,
  }) async {
    final id = mrId ?? _currentMrId;
    if (id == null) return;
    await _giftServices.updateMrGiftApplication(
      mrId: id,
      requestId: requestId,
      doctorId: doctorId,
      occassion: occassion,
      message: message,
      giftDate: giftDate,
      remarks: remarks,
      status: status,
    );
    await fetchGiftsForMr(id);
  }

  // Delete MR Gift Application
  Future<void> deleteMrGiftApplication(int requestId, [String? mrId]) async {
    final id = mrId ?? _currentMrId;
    if (id == null) return;
    await _giftServices.deleteMrGiftApplication(requestId);
    await fetchGiftsForMr(id);
  }

  Future<void> _fetchGiftInventory() async {
    try {
      _giftInventoryItems = await _giftServices.fetchGiftInventory();
    } catch (e) {
      _giftInventoryItems = [];
    }
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
