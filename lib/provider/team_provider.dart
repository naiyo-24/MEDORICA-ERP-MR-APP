import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart' show StateNotifierProvider;
import '../models/team.dart';
import '../notifiers/team_notifier.dart';
import '../services/team/team_services.dart';

final teamServicesProvider = Provider<TeamServices>((ref) => TeamServices());

final teamNotifierProvider = StateNotifierProvider<TeamNotifier, AsyncValue<List<Team>>>((ref) {
  final service = ref.watch(teamServicesProvider);
  return TeamNotifier(service);
});
