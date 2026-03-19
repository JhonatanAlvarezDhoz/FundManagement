import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/simulation/domain/entities/simulation_state_entity.dart';

abstract class SimulationRepository {
  Future<Result<SimulationStateEntity>> getSimulationState();
  Future<Result<void>> saveSimulationState(SimulationStateEntity state);
  Future<Result<void>> reset();
}
