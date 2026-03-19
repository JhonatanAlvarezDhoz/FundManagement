import 'dart:convert';

import 'package:fund_management/core/constants/storege_keys.dart';
import 'package:fund_management/features/simulation/data/datasources/simulation_local_data_source.dart';
import 'package:fund_management/features/simulation/data/models/simulation_state_model.dart';
import 'package:fund_management/features/simulation/domain/entities/simulation_state_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimulationLocalDataSourceImpl implements SimulationLocalDataSource {
  final SharedPreferences prefs;

  SimulationLocalDataSourceImpl(this.prefs);

  @override
  Future<SimulationStateModel> getState() async {
    final raw = prefs.getString(StorageKeys.simulationState);
    if (raw == null)
      return SimulationStateModel.fromEntity(SimulationStateEntity.initial());
    return SimulationStateModel.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
  }

  @override
  Future<void> saveState(SimulationStateModel model) async {
    await prefs.setString(
      StorageKeys.simulationState,
      jsonEncode(model.toJson()),
    );
  }

  @override
  Future<void> reset() async {
    await prefs.remove(StorageKeys.simulationState);
  }
}
