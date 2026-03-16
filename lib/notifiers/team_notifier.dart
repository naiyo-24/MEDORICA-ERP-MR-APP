import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/team.dart';
import '../services/team/team_services.dart';

class TeamNotifier extends StateNotifier<AsyncValue<List<Team>>> {
  final TeamServices _service;

  TeamNotifier(this._service) : super(const AsyncValue.loading());

  Future<void> fetchTeamsByMrId(String mrId) async {
    try {
      state = const AsyncValue.loading();
      final teams = await _service.getTeamsByMrId(mrId);
      state = AsyncValue.data(teams);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
