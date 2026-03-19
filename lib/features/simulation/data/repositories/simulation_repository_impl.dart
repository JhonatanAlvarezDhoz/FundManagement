import 'package:fund_management/core/errors/failures.dart';
import 'package:fund_management/core/result/result.dart';
import 'package:fund_management/features/simulation/data/datasources/simulation_local_data_source.dart';
import 'package:fund_management/features/simulation/data/models/simulation_state_model.dart';
import 'package:fund_management/features/simulation/domain/entities/simulation_state_entity.dart';
import 'package:fund_management/features/simulation/domain/repositories/simulation_repository.dart';

class SimulationRepositoryImpl implements SimulationRepository {
  final SimulationLocalDataSource dataSource;

  SimulationRepositoryImpl(this.dataSource);

  @override
  Future<Result<SimulationStateEntity>> getSimulationState() async {
    try {
      return Success(await dataSource.getState());
    } catch (_) {
      return const FailureResult<SimulationStateEntity>(
        StorageFailure('No fue posible restaurar el estado de simulación.'),
      );
    }
  }

  @override
  Future<Result<void>> saveSimulationState(SimulationStateEntity state) async {
    try {
      await dataSource.saveState(SimulationStateModel.fromEntity(state));
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible guardar la simulación.'),
      );
    }
  }

  @override
  Future<Result<void>> reset() async {
    try {
      await dataSource.reset();
      return const Success(null);
    } catch (_) {
      return const FailureResult<void>(
        StorageFailure('No fue posible resetear la simulación.'),
      );
    }
  }
}
