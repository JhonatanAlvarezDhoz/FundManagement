import '../models/simulation_state_model.dart';

abstract class SimulationLocalDataSource {
  Future<SimulationStateModel> getState();
  Future<void> saveState(SimulationStateModel model);
  Future<void> reset();
}
