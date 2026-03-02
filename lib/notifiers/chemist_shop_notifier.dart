import 'package:flutter_riverpod/legacy.dart';
import '../models/chemist_shop.dart';

class ChemistShopNotifier extends StateNotifier<List<ChemistShop>> {
  ChemistShopNotifier() : super([]) {
    _loadChemistShops();
  }

  // Load chemist shops - mock data for now
  void _loadChemistShops() {
    state = [
      ChemistShop(
        id: '1',
        name: 'MediCare Pharmacy',
        phoneNumber: '+880 1700 111222',
        email: 'medicare@pharmacy.com',
        photo: 'https://via.placeholder.com/400x300?text=MediCare+Pharmacy',
        location: '123 Gulshan Avenue, Dhaka',
        description:
            'A trusted pharmacy serving the community for over 20 years. We provide quality medicines and healthcare products with excellent customer service.',
        doctorIds: ['1', '2'],
      ),
      ChemistShop(
        id: '2',
        name: 'HealthPlus Chemist',
        phoneNumber: '+880 1800 333444',
        email: 'healthplus@pharmacy.com',
        photo: 'https://via.placeholder.com/400x300?text=HealthPlus+Chemist',
        location: '456 Dhanmondi Road, Dhaka',
        description:
            'Modern pharmacy with a wide range of medicines and health products. We also offer free health consultations and home delivery services.',
        doctorIds: ['2', '3'],
      ),
      ChemistShop(
        id: '3',
        name: 'City Pharmacy',
        phoneNumber: '+880 1900 555666',
        email: 'city@pharmacy.com',
        photo: 'https://via.placeholder.com/400x300?text=City+Pharmacy',
        location: '789 Mirpur Road, Dhaka',
        description:
            '24/7 pharmacy service with experienced pharmacists. We stock all major brands and generic medicines at competitive prices.',
        doctorIds: ['1'],
      ),
    ];
  }

  // Add a new chemist shop
  void addChemistShop(ChemistShop shop) {
    state = [...state, shop.copyWith(id: DateTime.now().toString())];
  }

  // Update a chemist shop
  void updateChemistShop(ChemistShop updatedShop) {
    state = [
      for (final shop in state)
        if (shop.id == updatedShop.id) updatedShop else shop,
    ];
  }

  // Delete a chemist shop
  void deleteChemistShop(String id) {
    state = [for (final shop in state) if (shop.id != id) shop];
  }

  // Get a chemist shop by id
  ChemistShop? getChemistShopById(String id) {
    try {
      return state.firstWhere((shop) => shop.id == id);
    } catch (e) {
      return null;
    }
  }

  // Search chemist shops
  List<ChemistShop> searchChemistShops(String query) {
    if (query.isEmpty) return state;
    final lowerQuery = query.toLowerCase();
    return state
        .where((shop) =>
            shop.name.toLowerCase().contains(lowerQuery) ||
            shop.location.toLowerCase().contains(lowerQuery))
        .toList();
  }

  // Filter by location
  List<ChemistShop> filterByLocation(String location) {
    if (location.isEmpty) return state;
    return state
        .where((shop) => shop.location.toLowerCase().contains(location.toLowerCase()))
        .toList();
  }
}
