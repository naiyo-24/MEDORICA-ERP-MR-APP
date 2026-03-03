import 'package:flutter_riverpod/legacy.dart';
import '../models/mr.dart';

class ProfileNotifier extends StateNotifier<MedicalRepresentative?> {
  ProfileNotifier()
      : super(
          MedicalRepresentative(
            id: '1',
            name: 'Rajdeep Dey',
            phone: '+880 1234567890',
            email: 'rajdeep.dey@medorica.com',
            designation: 'Senior Medical Representative',
            territory: 'Dhaka Division',
            profileImage: null,
          ),
        );

  void updateProfile(MedicalRepresentative profile) {
    state = profile;
  }

  void updateProfileImage(String imagePath) {
    if (state != null) {
      state = state!.copyWith(profileImage: imagePath);
    }
  }

  void updatePhone(String phone) {
    if (state != null) {
      state = state!.copyWith(phone: phone);
    }
  }

  void updateEmail(String email) {
    if (state != null) {
      state = state!.copyWith(email: email);
    }
  }
}
